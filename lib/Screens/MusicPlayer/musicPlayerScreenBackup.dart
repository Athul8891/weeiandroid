import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Noti.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/friendBottomInvite.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/musicPlayerTimeFormater.dart';
import 'package:weei/Helper/openSingleMusicVideoBottom.dart';
import 'package:weei/Helper/roomExitBox.dart';
import 'package:weei/Helper/streamMessageBar.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/BannerAdsMusStr.dart';
import 'package:weei/Screens/Admob/InterstitialAd.dart';
import 'package:weei/Screens/Main_Screens/Chat/sessionChatList.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';
import 'package:weei/Screens/MusicPlayer/localThumbnai.dart';
import 'package:weei/Screens/VideoSession/Data/acceptOrDeclne.dart';
import 'package:weei/Screens/VideoSession/Data/sendMessageInSession.dart';
import 'package:weei/Screens/VideoSession/VideoCrontrolDrawer.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:weei/Screens/voicenote/duration.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:screen_state/screen_state.dart';
import 'package:audio_service/audio_service.dart';
import '../../Helper/Const.dart';
import '../../Helper/checkUrl.dart';

class audioPlayerScreen extends StatefulWidget {
  final id;
  final path;
  final type;
  final ConcatenatingAudioSource;

  audioPlayerScreen({this.id, this.path, this.type,this.ConcatenatingAudioSource});

  @override
  _audioPlayerScreenState createState() => _audioPlayerScreenState();
}

class _audioPlayerScreenState extends State<audioPlayerScreen> {
  StreamSubscription? positionSubscription;
  StreamSubscription? durationSubscription;

  var duration;
  var position;
  var showLeftTime=0;
  var showRightTime=0;

  late Query _ref;
  late Query _chat;
  var yourTime = 00000;
  final databaseReference = FirebaseDatabase.instance.reference();
  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();

  ///playerconf
  final player = AudioPlayer();

  ///playerconf

  // late BetterPlayerController _betterPlayerController;
  // List<BetterPlayerEvent> events = [];
  // StreamController<DateTime> _eventStreamController = StreamController.broadcast();
  var loading = true;
  var intialLoading = true;
  var listEnd = true;
  var playlistTap = false;
  var chatlistTap = false;
  var autoPlayToggle = true;
  var updateTimeLock = false;

  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  var adminTime = 00000;
  var bufferTime = 0000;
  var videoType;
  var playList;

  var chatList;
  var chatReversedList;
  var joinList;
  var totalJoined = 0;

  var path;
  var private;

  var controller;
  var playing;
  var adminId;
  var url;
  var currentIndex;
  var thumbnail;
  var name = " ";
  var exit;
  var joins;

  bool seesionJoins = false;
  bool musicPlaying = true;
  var intialStart = "false";
  var selectedShare = 0;



  bool itemLoading =false;
  bool joinAlert =true;
  bool creatorControl =true;

  ///for cht noti

  bool videoFulscreen =false;
  bool chatAlert =true;

  bool controlJoined =true;



  var navigationListner = TextEditingController();
  var voiceNotePlayingListner = TextEditingController();


  var chatSound = true;
  var chatPopup = true;
  var chatVibrate = true;
  var joinBottomShowed=false;

  ///
  var shuffle = false;
  var repeat = false;
  late Screen _screen;
  late StreamSubscription<ScreenStateEvent> _subscription;
  late Timer timer;
  var navigationExitListner = TextEditingController();
  var fetchTimeBg = true;
  bool participantsBubble =false;

  @override
  void initState() {
    print("widget.id");
    print(widget.id);
    showInterstitialAd();
    Noti.initialize(flutterLocalNotificationsPlugin);
    navigationExitListner.addListener((){
      //here you have the changes of your textfield
      print("value: ${navigationListner.text}");
      //use setState to rebuild the widget

      _onBackPressed();
    });
    navigationListner.addListener((){
      //here you have the changes of your textfield
      print("value: ${navigationListner.text}");
      //use setState to rebuild the widget

      navigationControls(navigationListner.text);

    });

    voiceNotePlayingListner.addListener((){
      //here you have the changes of your textfield
      print("vaaaaaaal");

      print("value: ${voiceNotePlayingListner.text}");
      //use setState to rebuild the widget
      if(voiceNotePlayingListner.text=="true"){
        print("korkyii");
        player.setVolume(0.1);
      }else{
        player.setVolume(1.0);
        //  print("kooott");

      }
      //  navigationControls(navigationListner.text);


    });
    this.startListening();
    this.getIntialData();
    this.listenDataFromFireBase();
    this.listenExit();
    this.listenError();

    // _ref = FirebaseDatabase.instance
    //     .reference()
    //     .child('channel').child(widget.id.toString()+"/joins");
    _chat = FirebaseDatabase.instance
        .reference()
        .child('channel')
        .child(widget.id.toString() + "/chat");

    // _controller.addListener(_scrollListener);
    _ref = FirebaseDatabase.instance
        .reference()
        .child('channel')
        .child(widget.id.toString() + "/joins");
    if(widget.type=="JOIN"){
      timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) =>   getTime());

    }
    super.initState();
  }
  listenError(){
    Future.delayed(const Duration(seconds: 59), () {

// Here you can write your code

      if(intialLoading==true){
        showToastSuccess("Error loading, something went wrong!");
        Navigator.pop(context);
      }

    });

  }
  void startListening() {
    _screen = new Screen();
    try {
      _subscription = _screen.screenStateStream!.listen(onData);
    } on ScreenStateException catch (exception) {
      print(exception);
    }
  }

  void onData(ScreenStateEvent event) {
    print("screen off");
    print(event.name);

    if(event.name.toString()=="SCREEN_OFF"){
      setState(() {
        chatlistTap=false;
      });
    }
  }
  void navigationControls(value){
    switch (value) {
      case "PVT_SESSION":
      // do something


        break;
      case "PUBLIC_SESSION":

        break;
      case "CHATALERT_TRUE":
        setState(() {
          chatAlert=true;
        });
        break;


      case "CHATALERT_FALSE":
        setState(() {
          chatAlert=false;
        });
        break;

      case "JOINALERT_TRUE":


        setState(() {
          joinAlert=true;
        });
        break;


      case "JOINALERT_FALSE":
        setState(() {
          joinAlert=false;
        });
        break;



      case "ADMINCONTROLS_TRUE":
        setState(() {
          creatorControl=true;
        });
        break;


      case "ADMINCONTROLS_FALSE":
        setState(() {
          creatorControl=false;
        });
        break;


      case "JOINCONTROLS_TRUE":
        setState(() {
          controlJoined=true;
        });
        break;


      case "JOINCONTROLS_FALSE":
        setState(() {
          controlJoined=false;
        });
        break;


    ///chat alert single controls
    ///sound
      case "CHATSOUND_TRUE":
        setState(() {
          chatSound=true;
        });
        break;


      case "CHATSOUND_FALSE":
        setState(() {
          chatSound=false;
        });
        break;

    ///sound

    ///vibrate
      case "CHATVIBRATE_TRUE":
        setState(() {
          chatVibrate=true;
        });
        break;


      case "CHATVIBRATE_FALSE":
        setState(() {
          chatVibrate=false;
        });
        break;
    ///vibrate
    ///
    ///pop
      case "CHATPOPUP_TRUE":
        setState(() {
          chatPopup=true;
        });
        break;


      case "CHATPOPUP_FALSE":
        setState(() {
          chatPopup=false;
        });
        break;
    ///pop
    }
  }

  listenExit() {
    var db = FirebaseDatabase.instance.reference();
    db
        .child('channel')
        .child(widget.id.toString() + "/joins")
        .child(auth.currentUser!.uid)
        .onChildChanged
        .listen((data) {
      switch (data.snapshot.key.toString()) {
        case "status":
        // do something

          var rsp = data.snapshot.value.toString();

          if (rsp == "exit") {
            showToastSuccess("Creator removed you !");
            Navigator.pop(context);
          }

          break;
      }
    });
  }




  void _scrollDown() {
    print("thaaazot");
    // _controller.animateTo(
    //   _controller.position.maxScrollExtent,
    //   duration: Duration(milliseconds: 1000),
    //   curve: Curves.fastOutSlowIn,
    // );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.elasticInOut,
        );
      }
    });
  }

  listenDataFromFireBase() {
    var db = FirebaseDatabase.instance.reference().child("channel");
    db.child(widget.id.toString()).onChildChanged.listen((data) {
      switch (data.snapshot.key.toString()) {


        case "private":
          var rsp = data.snapshot.value.toString();
          setState(() {
            private=rsp.toString();
          });
          break;
        case "index":
        // do something

          var rsp = data.snapshot.value.toString();

          setState(() {
            currentIndex = int.parse(rsp.toString());
          });
          break;
        case "url":
          var rsp = data.snapshot.value.toString();
          setState(() {
            url = rsp.toString();
          });
          break;

        case "name":
          var rsp = data.snapshot.value.toString();
          setState(() {
            name = rsp.toString();
          });
          break;
        case "videoType":
          var rsp = data.snapshot.value.toString();
          setState(() {
            videoType = rsp.toString();
          });
          break;
      // case "time":
      //   var rsp = data.snapshot.value.toString();
      //   if (this.mounted) {
      //     setState(() {
      //       adminTime = int.parse(rsp.toString());
      //     });
      //   }
      //   break;

        case "exit":
          var rsp = data.snapshot.value.toString();
          if (rsp == "true") {
            Navigator.pop(context);
          }
          break;

        case "chat":
          var rsp = data.snapshot.value;

          // setState(() {
          //   chatList=rsp;
          // });

          if((chatlistTap==false&&chatAlert==true)){
            ///play notification
            ///
            FlutterRingtonePlayer.playNotification();
            Vibrate.vibrate();

            if(rsp.toString().split("||").last!=auth.currentUser!.uid){
              Noti.showBigTextNotification(title: "New Message", body: rsp.toString().split("||").first.toString(), fln: flutterLocalNotificationsPlugin);

            }

            // if(chatSound==true){
            //   FlutterRingtonePlayer.playNotification();
            //
            // }
            // if(chatVibrate==true){
            //
            //   print("vibratee");
            //
            //   Vibrate.vibrate();
            //
            //
            // }
            //
            // if(chatPopup==true){
            //   showToastSuccess(rsp.toString());
            //
            //
            // }

          }
          // _scrollDown();

          // if(listEnd==true){
          // }
          ///write code here
          print("chatList");
          print(chatList);
          break;
        case "thumbnail":
          var rsp = data.snapshot.value.toString();

          setState(() {
            thumbnail = rsp;
          });

          break;
        case "controller":
          var rsp = data.snapshot.value.toString();
          print("controller");
          print(rsp);
          print("controller");

          setState(() {
            controller = rsp;
          });
          if(creatorControl==true){
            getControl(rsp);

          }
          break;

        case "joins":
          var rsp = data.snapshot.value;

          setState(() {
            joinList = rsp;
            participantsBubble=true;

          });

          if(widget.type=="CREATE"){
            if(totalJoined !=joinList.length){

              if(joinAlert==true){
                // FlutterRingtonePlayer.playNotification();
                //
                // Vibrate.vibrate();
                // showToastSuccess("New Join!");
                Noti.showBigTextNotification(title: "Join alert ", body: "Someone requested to join the session".toString(), fln: flutterLocalNotificationsPlugin);

              }
              setState(() {
                totalJoined=joinList.length;
              });
            }else{
              setState(() {
                totalJoined=joinList.length;
              });
            }


            if(joinBottomShowed==false){
              joinBottomSheet();
            }
            setState(() {
              joinBottomShowed=true;
            });
          }

          // print(totalJoined);
          break;

        case "intialStart":
          var rsp = data.snapshot.value.toString();
          setState(() {
            intialStart = rsp.toString();
          });
          break;
      }
    });
  }

  void getIntialData() {
    databaseReference
        .child('channel')
        .child(widget.id.toString())
        .once()
        .then((snapshot) async {
      var time = snapshot.snapshot.child('time').value;

      adminTime = int.parse(time.toString());
      videoType = snapshot.snapshot.child('videoType').value;
      private=snapshot.snapshot.child('private').value;

      path = snapshot.snapshot.child('playlist').value;
      controller = snapshot.snapshot.child('controller').value.toString();
      playing = snapshot.snapshot.child('playing').value;
      adminId = snapshot.snapshot.child('adminId').value;
      url = snapshot.snapshot.child('url').value;

      var ind = snapshot.snapshot.child('index').value;
      currentIndex = ind == null ? 0 : int.parse(ind.toString());
      name = snapshot.snapshot.child('name').value.toString();
      exit = snapshot.snapshot.child('exit').value;
      intialStart = snapshot.snapshot.child('intialStart').value.toString();
      thumbnail = snapshot.snapshot.child('thumbnail').value.toString();
      print("time1");
      print(time);
      if (controller == "pause") {
        setState(() {
          musicPlaying = false;
        });
      }
    }).whenComplete(() {
      getPlayList(path);
    });
  }

  void getPlayList(_path) {
    databaseReference.child(_path).once().then((snapshot) async {
      var data = snapshot.snapshot.value;
      print("dataaa");
      print(data);
      playList = data;

    }).whenComplete(() {
      if (widget.type.toString() == "CREATE") {
        updateUrl(0);
      } else {
        print("feethh");
        videoInitilize();
      }

      //  setUpChannel("playList[0][0]['fileUrl']");
    });
  }

  void updateUrl(index) async {
    var _url = await getSong(playList[index]['fileUrl'].toString(),
        playList[index]['fileType'].toString());
    databaseReference.child('channel').child(widget.id).update({
      'url': _url,
      'name': playList[index]['fileName'].toString(),
      'index': index.toString(),
      'thumbnail': playList[index]['fileThumb'].toString(),
    }).whenComplete(() {
      setState(() {
        url = _url;
        name = playList[index]['fileName'].toString();
        currentIndex = index;
        thumbnail = playList[index]['fileThumb'].toString();
      });
      videoInitilize();
    });
  }

  void playNext(index, ctx) async {
    var _url = await getSong(playList[index]['fileUrl'].toString(),
        playList[index]['fileType'].toString());
    databaseReference.child('channel').child(widget.id).update({
      'url': _url,
      'name': playList[index]['fileName'].toString(),
      'thumbnail': playList[index]['fileThumb'].toString(),
    }).whenComplete(() {
      databaseReference.child('channel').child(widget.id).update({
        'index': index.toString(),
      }).whenComplete(() {
        setState(() {
          url = _url;
          currentIndex = index;
          name = playList[index]['fileName'].toString();
          thumbnail = playList[index]['fileThumb'].toString();
          // player.dispose();

          videoInitilizeAdmin(true);
        });
        databaseReference.child('channel').child(widget.id).update({
          'controller': "pause".toString(),
        }).whenComplete(() {});
      });
    });
  }
  // void videoInitilize()async{
  //  print("urldl");
  //  print(url);
  //  print(musicPlaying);
  //
  //   final setup = await player.setUrl(url);
  //
  //  print("stateeee");
  //  print(setup?.inMilliseconds);
  //    setState(() {
  //      duration=setup!.inMilliseconds;
  //      print("stateeee");
  //      print(duration);
  //
  //    });
  //    if(intialStart=="false"){
  //      setState(() {
  //        loading=false;
  //        intialLoading=false;
  //
  //      });
  //      if(widget.type=="JOIN"){
  //        player.seek(
  //          Duration(
  //            milliseconds: adminTime,
  //          ),
  //        );
  //      }else{
  //        updateTime();
  //      }
  //
  //    }else{
  //
  //
  //    if(musicPlaying==true){
  //      player.play();
  //
  //     // _handleEvent("next");
  //      _handleEvent("play");
  //      print("oooooooooooooo");
  //    }
  //
  //   if(widget.type=="JOIN"){
  //     player.seek(
  //       Duration(
  //         milliseconds: adminTime,
  //       ),
  //     );
  //   }else{
  //     updateTime();
  //   }
  //   setState(() {
  //     loading=false;
  //     intialLoading=false;
  //   });
  //
  //
  // }}

  void videoInitilize() async {
    if (widget.type == "JOIN") {
      videoInitilizeJoin();
    } else {
      videoInitilizeAdmin(false);
    }
  }

  void videoInitilizeJoin() async {
    print("joinnnnnnn");
    print(url);
    final setup = await player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id:currentIndex.toString(),
          // Metadata to display in the notification:
          album: "Weei Audio",
          title: name,
          artUri: Uri.parse(thumbnail),
        ),
      ),
    );
    // print("musicPlaying1");
    // print(musicPlaying);

    setState(() {
      duration = setup!.inMilliseconds;
      showRightTime = setup!.inSeconds;
    });
    if (intialStart == "false") {
      print("musicPlayingSt");
      print(musicPlaying);
      var tm = await getCurrentTime();
      setState(() {
        loading = false;
        intialLoading = false;

        updateTime();
        player.seek(
          Duration(
            milliseconds: adminTime,
          ),
        );
      });
    } else {
      print("musicPlaying1");
      print(musicPlaying);
      var tm = await getCurrentTime();
      updateTime();
      player.seek(
        Duration(
          milliseconds: adminTime,
        ),
      );

      if (musicPlaying == true) {
        print("musicPlaying2");
        print(musicPlaying);
        player.play();
      }

      setState(() {
        loading = false;
        intialLoading = false;
      });
    }

    print("kazhinjjj");
  }

  void videoInitilizeAdmin(next) async {
    final setup = await player.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id:currentIndex.toString(),
          // Metadata to display in the notification:
          album: "Weei Audio",
          title: name,
          artUri: Uri.parse(thumbnail),
        ),
      ),
    );

    if (next == true) {
      _handleEvent("next");
    }
    setState(() {
      duration = setup!.inMilliseconds;
      showRightTime = setup!.inSeconds;
    });
    if (intialStart == "false") {
      setState(() {
        loading = false;
        intialLoading = false;
        updateTime();
      });
    } else {
      updateTime();

      if (musicPlaying == true) {
        player.play();

        // _handleEvent("next");
        _handleEvent("play");
      }

      setState(() {
        loading = false;
        intialLoading = false;
      });
    }
  }

  void updateTime() {
    player.positionStream.listen((time) {
      setState(() {
        position = time.inMilliseconds;
        showLeftTime = time.inSeconds;
        yourTime = position;

      });

      if (widget.type.toString() == "CREATE") {
        if (position >= duration) {
          autoPlay();
        }
        // databaseReference.child('channel').child(widget.id).update({
        //   'time': position.toString(),
        // });
        databaseReference.child('time').child(widget.id).update({
          'time': position.toString(),
        });
        // sendTimeToDb();
      }
    });

  }


  sendTimeToDb(){

    print("db updatee");
    databaseReference.child('time').child(widget.id).update({
      'time': position.toString(),
    }).whenComplete((){

    });

  }
  getTime()async{


    if(controller!="pause"){


      if((yourTime<(adminTime-3000) ||yourTime>(adminTime+2000))==false ){
        print("live-------");

        print("live aayi");
        setState(() {
          var set = adminTime +500;
          adminTime=set;
          fetchTimeBg=true;

        });
      }else {
        print("live-------");
        print("alaaa");
        if(fetchTimeBg==true){
          databaseReference.child('time').child(widget.id).once().then((
              snapshot) async {
            var rsp = snapshot.snapshot
                .child('time')
                .value;
            setState(() {
              adminTime = int.parse(rsp.toString());
              fetchTimeBg = false;
            });
          });
        }
      }
      //
      //  databaseReference.child('time').child(widget.id).once().then(( snapshot) async {
      //    var rsp = snapshot.snapshot.child('time').value;
      //    setState(() {
      //      adminTime=int.parse(rsp.toString());
      //    });
      //  });




    }




  }
  getCurrentTime()async{

    print("fetched current");
    var rsp = await  databaseReference.child('time').child(widget.id).once().then(( snapshot) async {
      var rsp = snapshot.snapshot.child('time').value;
      setState(() {
        adminTime=int.parse(rsp.toString());
      });
    });
  }
  void getControl(control) {
    // print("seekaneey");
    if (widget.type == "JOIN") {
      print("seeekUndo");
      print(control);
      if (control == "play") {
        print("cpntroool play");
        setState(() {
          player.play();
          musicPlaying = true;
        });

        getCurrentTime();
      }
      if (control == "pause") {
        setState(() {
          player.pause();
          musicPlaying = false;
        });

        getCurrentTime();
      }
      if (control == "next") {
        // player.dispose();
        player.pause();


        videoInitilize();
        getCurrentTime();
      }
      if (control == "seekTo") {
        print("fuckk");
        // _betterPlayerController. videoPlayerController?.dispose();
        // videoInitilize();
        goLive();
//         Future.delayed(const Duration(seconds: 1), () {
//
// // Here you can write your code
//        //   seekTo();
//          goLive();
//
//         });

        // goLive();
      }
      if (control == "exit") {
        print("fuckk");
        // _betterPlayerController. videoPlayerController?.dispose();
        // videoInitilize();
        //goLive();
        Navigator.pop(context);
      }
    }
  }

  void setControls(event) {
    print("eventttt");
    print(event);
    if(controlJoined==false){

      return;
    }

    if (event == "seekTo") {
      print("seekaney");
      databaseReference.child('channel').child(widget.id).update({
        'controller': event.toString(),
        'time': position.toString(),
      }).whenComplete((){

        if(musicPlaying==true){
          databaseReference.child('channel').child(widget.id).update({
            'controller': "play".toString(),
            'time': position.toString(),
          });
        }else{
          databaseReference.child('channel').child(widget.id).update({
            'controller': "pause".toString(),
            'time': position.toString(),
          });

        }



      });


    }
    if (event == "play") {
      databaseReference.child('channel').child(widget.id).update({
        'controller': event.toString(),
        'time': position.toString(),
      });

    }
    if (event == "pause") {
      databaseReference.child('channel').child(widget.id).update({
        'controller': event.toString(),
        'time': position.toString(),
      });

    }
    if (event == "next") {
      databaseReference.child('channel').child(widget.id).update({
        'controller': event.toString(),
        'time': position.toString(),
      });

    }

    if (event == "exit") {
      databaseReference.child('channel').child(widget.id).update({
        'controller': event.toString(),

      });

      // Navigator.pop(context);
    }
  }

  void goLive() async{
    // Stopwatch stopwatch = Stopwatch()..start();
    player.pause();
    //

    var liv= await   getCurrentTime();
    player
        .seek(Duration(milliseconds: (int.parse(adminTime.toString())+500)))
        .whenComplete(() {
      print("liveeee");
      setState(() {
        if (musicPlaying == true) {
          player.play();
        }

        // player.play();

        //  stopwatch.stop();
        //   bufferTime = stopwatch.elapsed.inMilliseconds;
        // print('doSomething() executed in ${stopwatch.elapsed.inMilliseconds}');
        ///stopwatch.reset();
      });
    });

    // _betterPlayerController.play();
    // _betterPlayerController.play();
  }

  void seekTo()async {
    var liv= await   getCurrentTime();
    //
    player
        .seek(Duration(milliseconds: (int.parse(adminTime.toString())+500)))
        .whenComplete(() {
      print("liveeee");
      //   setState(() {});
    });

    // _betterPlayerController.play();
    // _betterPlayerController.play();
  }

  void next()  {

    if (widget.type == "CREATE") {
      player.pause();

      setState(() {
        loading = true;
      });

      if ((currentIndex + 1) != playList.length) {
        player.stop();
        // player.dispose();
        // updateUrl(index);
        setControls("next");
        playNext((currentIndex + 1), context);
        // setControls("next");
        // return;
      } else {
        // print("nextttt");
        // print(autoPlayToggle);
        // setControls("next");
        // playNext(currentIndex, context);
        //  setControls("next");


        ///new
        if((currentIndex + 1) == playList.length){
          player.stop();
          // player.dispose();
          // updateUrl(index);
          playNext(0, context);
          ///new
        }else{
          ///old
          print("laaaaast");
          print(autoPlayToggle);
          //setControls("next");
          playNext(currentIndex, context);
          //  setControls("next");
          ///old

        }
      }
    }
  }

  void autoPlay() {
    if (widget.type == "CREATE") {
      setState(() {
        loading = true;
      });

      if ((currentIndex + 1) != playList.length && autoPlayToggle == true) {
        player.stop();
        // player.dispose();
        // updateUrl(index);
        playNext((currentIndex + 1), context);





        // setControls("next");
        // setControls("next");

      } else {



        ///new
        if((currentIndex + 1) == playList.length){
          player.stop();
          // player.dispose();
          // updateUrl(index);
          playNext(0, context);
          ///new
        }else{
          ///old
          print("nextttt");
          print(autoPlayToggle);
          //setControls("next");
          playNext(currentIndex, context);
          //  setControls("next");
          ///old

        }

      }
    }
  }

  void previos() {
    if (widget.type == "CREATE") {
      player.pause();

      setState(() {
        loading = true;
      });

      if (currentIndex != 0) {
        player.stop();
        // player.dispose();
        // updateUrl(index);
        playNext((currentIndex - 1), context);
        setControls("next");
      }else{
        player.stop();
        // player.dispose();
        // updateUrl(index);
        playNext((playList.length - 1), context);

      }
    }
  }

  @override
  void dispose() {
    showInterstitialAd();
    player.stop();
    player.dispose();
    _subscription.cancel();
    setState(() {
      timer.cancel();

    });

    super.dispose();
  }

  void _handleEvent(event) {
    if (widget.type.toString() == "CREATE") {
      setControls(event);
    }

    // var current =_betterPlayerController.videoPlayerController?.value.position.inMilliseconds;
    // setState(() {
    //   yourTime = current!;
    // });
    //

    // if(current!<=yourTime){
    //  // _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(time.toString()))));
    // }
  }
  Future<bool> _onBackPressed() async {
    bool goBack = false;

    if(chatlistTap==true){
      setState(() {
        chatlistTap=false;
      });

      return goBack;
    }


    if(playlistTap==true){
      setState(() {
        playlistTap=false;
      });

      return goBack;
    }
    if(widget.type=="JOIN"){
      roomExitJoinAlert( context,widget.id,uid);
    }else{
      roomExitAlert(context,widget.id,uid);

    }
    return goBack;
  }




  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        endDrawer: VideoDrawerWidget(type: widget.type,id: widget.id,uid: auth.currentUser!.uid,controller: navigationListner,private: private,disableComment:chatAlert,disableJoinAlert:joinAlert,disableAdminControls:creatorControl,controlJoins:controlJoined,chatPopup: chatPopup,chatSound: chatSound,chatVibrate: chatVibrate,context:context),


        resizeToAvoidBottomInset: true,
        appBar: AppBar(

          elevation: 0,
          actions: [
            Stack(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      setState(() {
                        participantsBubble=false;

                      });
                      // if(seesionJoins==true){
                      //   setState(() {
                      //     seesionJoins=false;
                      //   });
                      // }else{
                      //   setState(() {
                      //     seesionJoins=true;
                      //   });
                      // }


                      joinBottomSheet();
                    },
                    icon: const Icon(CupertinoIcons.person_3, color: Colors.white)),
                Positioned(
                  right: 5,
                  top: 10,
                  child:  participantsBubble==true?Container(
                    padding: EdgeInsets.all(1),
                    decoration:  BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 7,
                    ),
                  ):Container(),
                )
              ],
            ),

            Builder(builder: (context) => // Ensure Scaffold is in context
            IconButton(
                onPressed: () {

                  Scaffold.of(context).openEndDrawer();
                  // shareBottomSheet();
                  // PopupMenuButton(
                  //   onSelected: (value) {
                  //     // _onMenuItemSelected(value as int);
                  //     print("value");
                  //     print(value);
                  //     if(value==0){
                  //
                  //     }else{
                  //       setState(() {
                  //
                  //       });
                  //     }
                  //   },
                  //   itemBuilder: (ctx) => [
                  //     _buildPopupMenuItem(' Add More', Icons.add, 0),
                  //     _buildPopupMenuItem(' Clear All', Icons.clear, 1),
                  //     // _buildPopupMenuItem('Copy', Icons.copy, 2),
                  //     // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
                  //   ],
                  // );
                },
                icon: const Icon(
                  Icons.more_vert,
                  size: 22,
                )),


            ),
          ],
          backgroundColor: const Color(0xff7D98A8),
          leading: IconButton(
              onPressed: () {
                _onBackPressed();
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: 18,
              )),
          centerTitle: false,
          title: GestureDetector(
            onTap: () {
              friendBottomInvite( context,widget.id);
              // goLive();
              //shareSheet();
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("#" + widget.id.toString(), style: size14_500W),
                    w(5),
                    const CircleAvatar(
                      backgroundColor: grey,
                      child: Icon(Icons.share, size: 10),
                      radius: 10,
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color(0xff2B2B2B)),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: liteBlack,
          height: chatlistTap == true?7:50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: chatlistTap == true
                ? Container()
                :  playlistTap==false?(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      if (playlistTap == true) {
                        setState(() {
                          playlistTap = false;
                        });
                      } else {
                        setState(() {
                          playlistTap = true;
                          chatlistTap = false;

                        });
                      }
                    },
                    icon: Icon(CupertinoIcons.line_horizontal_3,
                        color:
                        playlistTap == true ? themeClr : Colors.white)),

                IconButton(
                    onPressed: () {
                      if (chatlistTap == true) {
                        setState(() {

                          chatlistTap = false;
                        });
                      } else {
                        setState(() {
                          chatlistTap = true;
                          playlistTap = false;

                        });
                      }
                      // chatBottomSheet();
                    },
                    icon: Icon(Icons.chat,
                        color:
                        chatlistTap == true ? themeClr : Colors.white,
                        size: 20)),
              ],
            )): BannerAdsMusStr(),
          ),
        ),
        body: intialLoading == true
            ? Loading()
            : Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: playerBg),
          child: playlistTap == true
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Scrollbar(
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child:
                  Divider(color: Color(0xff404040), thickness: 1),
                ),
                shrinkWrap: true,
                itemCount: playList != null ? playList.length : 0,
                itemBuilder: (context, index) {
                  final item =
                  playList != null ? playList[index] : null;

                  return MusicList(item, index);
                },
              ),
            ),
          )
              : chatlistTap == true
              ? Column(
            children: [
              BannerAdsMusStr(),
              h(2),
              sessionChatList(code: widget.id,voiceNotePlayingListner: voiceNotePlayingListner,),
              h(5),
              chatlistTap==true?Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 2.0,bottom: 7.0),
                child: MessageBar(width: width,id: widget.id,videoController: player,),
              ):Container(),
            ],
          )
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        BannerAdsMusStr(),

                        SizedBox(height: 5),
                        Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Room #" + widget.id.toString(),
                                style: size14_600W),
                            // w(5),
                            //  CircleAvatar(
                            //   backgroundColor: grey,
                            //   child: Icon(Icons.copy, size: 10),
                            //   radius: 10,
                            // )
                          ],
                        ),
                        SizedBox(height: 5),
                        // Text("Game of Thrones", style: size14_600W),
                      ],
                    )),

                // h(ss.height * 0.03),
                AspectRatio(
                  aspectRatio: 1,
                  child: intialStart == 'false'
                      ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: widget.type == "JOIN"
                          ? Container(
                        child: Text(
                          "Creator havent start the stream!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10),
                        ),
                      )
                          : GestureDetector(
                        onTap: () {
                          updateTime();
                          player.play();
                          _handleEvent("play");
                          setState(() {
                            intialStart = "true";
                            musicPlaying = true;
                          });

                          databaseReference
                              .child('channel')
                              .child(widget.id)
                              .update({
                            'intialStart':
                            true.toString(),
                            //'controller': "play",
                          });
                        },
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .center,
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          children: [
                            Container(
                              alignment:
                              Alignment.center,
                              height: 40,
                              width: 180,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(
                                      30),
                                  color: themeClr),
                              child: const Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    10),
                                child: Text("Start",
                                    style:
                                    size12_200W),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Before starting the session \n make sure everyone has joined !",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12),
                              textAlign:
                              TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                      :Container(child:  loading==true?Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Container(decoration: BoxDecoration(
                      color: Colors.grey[200],

                      borderRadius:
                      BorderRadius.circular(
                          10),
                    ),),
                  ):Stack(
                    children: [
                      playList[currentIndex]['fileType'] ==
                          "AUDIO"
                          ?  LocalThumbnail(name: playList[currentIndex]['fileName']):Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image: DecorationImage(
                              image: NetworkImage(
                                  thumbnail),
                              fit: BoxFit.cover),
                          borderRadius:
                          BorderRadius.circular(
                              10),
                        ),
                      )
                      ,
                      Align(
                        child: widget.type == "JOIN"
                            ? Container(
                          alignment:
                          Alignment.topRight,

                          //    color: Colors.black54,
                          child: Padding(
                            padding: const EdgeInsets
                                .symmetric(
                                vertical: 10,
                                horizontal: 5),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    goLive();
                                  },
                                  child: Container(
                                    alignment:
                                    Alignment
                                        .center,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            10),
                                        color: (yourTime <
                                            (adminTime -
                                                5000) ||
                                            yourTime >
                                                (adminTime +
                                                    5000))
                                            ? Colors
                                            .orange
                                            : red),
                                    child: Padding(
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          10),
                                      child: Text(
                                          (yourTime < (adminTime - 5000) ||
                                              yourTime >
                                                  (adminTime + 5000))
                                              ? "Go Live"
                                              : "Live",
                                          style: size12_600W),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                            : Container(),
                        alignment: Alignment.topLeft,
                      ),
                    ],
                  ),),
                ),
                // h(ss.height * 0.05),
                intialStart == 'false'
                    ? Container()
                    : Container(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          name,
                          style: size14_600W,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                        ),
                        // Text("Ramin Djawadi", style: size14_500W),
                      ],
                    )),
                intialStart == "true"
                    ? Container(
                  padding: EdgeInsets.only(
                    top: ss.height * 0.01,
                    // left: 5,
                    // right: 5,
                    bottom: ss.height * 0.03,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.green[50],

                        // value:position.isNaN==true || position==null? 0 : model.playerBarValue,
                        value: position == null
                            ? 0.0
                            : double.parse(
                            position.toString()),
                        onChanged:loading==true?null: (double? value) {

                          print("seekrdy");
                          if (value!.round() > (duration)) {
                            print("velthh");
                            // next();

                            if(widget.type=="CREATE"){
                              if(autoPlayToggle==true){

                                next();

                              }else{
                                playNext(currentIndex, context);
                              }
                            }else{
                              // playNext(currentIndex, context);
                            }
                            return;
                          }
                          setState(() {
                            player
                                .seek(
                              Duration(
                                milliseconds:
                                value!.round(),
                              ),
                            )
                                .whenComplete(() {
                              position = value;


                              _handleEvent("seekTo");
                            });
                          });
                        },
                        max: duration == null
                            ? 0.0
                            : (double.parse(
                            (duration+2000).toString() )),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            VoiceDuration.getDuration(showLeftTime),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white),
                          ),
                          const Spacer(),
                          Text(
                            VoiceDuration.getDuration(showRightTime),
                            //  intToTimeLeft( showRightTime).toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Container(
                        // padding: EdgeInsets.only(top: ss.height * 0.03),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    padding:
                                    EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.repeat,
                                      color:widget.type=="CREATE" ?(autoPlayToggle == true? themeClr:Colors.white):Colors.grey,
                                      size: 22,
                                    ),

                                    onPressed: () {

                                      setState(() {

                                        if (autoPlayToggle == false) {

                                          autoPlayToggle=true;

                                        } else {
                                          autoPlayToggle=false;

                                        }
                                      });

                                    },
                                    splashColor:
                                    Colors.transparent,
                                  ),


                                  IconButton(
                                    padding:
                                    EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                      size: ss.width * 0.1,
                                    ),
                                    iconSize:
                                    ss.width * 0.056,
                                    onPressed: loading==true?null:() {
                                      previos();

                                      // if(widget.type=="CREATE"){
                                      //
                                      //
                                      //   player.stop();
                                      //  // player.dispose();
                                      //   // updateUrl(index);
                                      //   playNext((currentIndex-1),context);
                                      //   setControls("next");
                                      //
                                      // }
                                    },
                                    splashColor:
                                    Colors.transparent,
                                  ),


                                  loading==true?SizedBox(
                                    height:20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3
                                    ),
                                  ):IconButton(
                                    padding:
                                    EdgeInsets.zero,
                                    icon: player.playerState.playing==false?
                                    Icon(
                                      Icons
                                          .play_circle_fill,
                                      color: Colors
                                          .white,
                                      size: ss.width *
                                          0.15,
                                    )
                                        : Icon(
                                      Icons
                                          .pause_circle_filled,
                                      color: Colors
                                          .white,
                                      size: ss.width *
                                          0.15,
                                    ),
                                    iconSize:
                                    ss.width * 0.08,
                                    onPressed: () {
                                      //player.pause();

                                      if (musicPlaying ==
                                          true) {
                                        setState(() {
                                          player.pause();

                                          musicPlaying =
                                          false;
                                        });

                                        _handleEvent(
                                            "pause");
                                      } else {
                                        player.play();
                                        setState(() {
                                          musicPlaying =
                                          true;
                                        });
                                        _handleEvent(
                                            "play");
                                      }
                                    },
                                    splashColor:
                                    Colors.transparent,
                                  ),

                                  IconButton(
                                    padding:
                                    EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                      size: ss.width * 0.1,
                                    ),
                                    iconSize:
                                    ss.width * 0.056,
                                    onPressed:  loading==true?null:() {
                                      next();

                                      // if(widget.type=="CREATE"){
                                      //
                                      //   // updateUrl(index);
                                      //    player.stop();
                                      //   // player.dispose();
                                      //   playNext((currentIndex+1),context);
                                      //   setControls("next");
                                      //
                                      // }
                                      // _handleEvent("next");
                                    },
                                    splashColor:
                                    Colors.transparent,
                                  ),


                                  IconButton(
                                    padding:
                                    EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.repeat_one_outlined,
                                      color:widget.type=="CREATE" ?(autoPlayToggle == false? themeClr:Colors.white):Colors.grey,
                                      size: 22,
                                    ),

                                    onPressed: () {

                                      setState(() {

                                        if (autoPlayToggle == false) {

                                          autoPlayToggle=true;

                                        } else {
                                          autoPlayToggle=false;

                                        }
                                      });

                                    },
                                    splashColor:
                                    Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  MusicList(var item, int index) {
    return GestureDetector(
      onTap: widget.type == "JOIN"
          ? null
          : () {
        if (widget.type == "CREATE" && intialStart == 'false') {
          showToastSuccess("Session not yet started!");
          return;
        }

        setState(() {
          player.pause();

          loading = true;
          currentIndex = index;
        });

        // if(loading==false){



        playNext(index, context);

        //  }
      },
      child: Row(
        children: [
          Container(
            height: 33,
            child: currentIndex == index
                ?Image.asset("assets/svg/nowPlaying.gif")
                : Icon(Icons.music_note_rounded, color: Colors.pink),
            width: 33,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          w(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['fileName'].toString(), style: currentIndex == index?size14_500G:size14_500W),
                h(5),
                //Text(getFileSize(int.parse(item['fileSize'].toString()),1).toString(), style: size14_500Grey),
              ],
            ),
          )
        ],
      ),
    );
  }

  chhat(var item,int index) {


    print("itemmmm");
    print(auth.currentUser!.uid);
    return Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uid'].toString()?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:  Container(
                      height: 23,
                      color: Colors.black,
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 23,

                    ),
                  ),


                ],
              ),
            ),
            w(10),
            Text(auth.currentUser!.uid==item['uid']?"You":item['name'].toString(), style: size14_600W),
            w(8),
            Text("• " + item['time'].toString(), style: size12_400grey)
          ],
        ),
        h(10),
        Container(
          margin:  EdgeInsets.symmetric(horizontal: 25),
          child:  Padding(
            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
            child: Text(item['message'].toString(), style: size14_500W),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23), color: auth.currentUser!.uid==item['uid']?Colors.grey[100]:blueClr),
        )
      ],
    );
  }

  chatBottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        // isScrollControlled: true,
        builder: (context) => Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        const Text("Chatroom", style: size14_500W),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: Color(0xff363636),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                ),
                const Divider(color: Color(0xff404040), thickness: 1),
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      separatorBuilder: (context, index) => h(10),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        // final item = arrOrderDetail != null
                        //     ? arrOrderDetail[index]
                        //     : null;

                        return chat(index);
                      },
                    ),
                  ),
                ),
                h(5),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color(0xff333333),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            autofocus: false,
                            style: size14_600W,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: size14_500Grey,
                              hintText: "Type your message here",
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    w(9),
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: themeClr),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Send", style: size14_600W),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 10),
                ),
              ],
            ),
          ),
        ]));
  }

  joinBottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        // isScrollControlled: true,
        builder: (context) => Stack(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        const Text("Participants", style: size14_600W),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                ),
                const Divider(color: Color(0xff404040), thickness: 1),
                Expanded(
                  child: Scrollbar(
                    child: FirebaseAnimatedList(
                      query: _ref,
                      // reverse: true,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        // Object? contact = snapshot.value;
                        // contact['key'] = snapshot.key;
                        return participantsList( snapshot.value,index);
                      },
                    ),
                  ),
                ),
                h(5),
                BannerAdsMusStr()
              ],
            ),
          ),
        ]));
  }


  participantsList(var item,int index) {
    return widget.type=="CREATE"?GestureDetector(
      onTap: auth.currentUser!.uid==item['uid']?null:(){
        if(widget.type=="CREATE"){
          controlJoins(widget.id,item['uid'],item['status']);

        }else{
          showToastSuccess("You are not authorized to prfrom this action.");
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 30,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['img']),gaplessPlayback: true,),
                        width: 30,

                      ),
                    ),


                  ],
                ),
              ),
              w(15),
              Text(item['name'], style: size14_600White),
              Spacer(),
              item['status'].toString()=="false"?accepted("Accept"):   item['status'].toString()=="exit"?rejected("Exited"):auth.currentUser!.uid==item['uid']?Text("Creator", style: size14_600Gold): Text("Remove", style: size14_600Red)
            ],
          ),
          SizedBox(height: 10,)
        ],
      ),
    ):GestureDetector(
      onTap: auth.currentUser!.uid==item['uid']?null:(){
        if(widget.type=="CREATE"){
          controlJoins(widget.id,item['uid'],item['status']);

        }
      },
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 30,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['img']),gaplessPlayback: true,),
                        width: 30,

                      ),
                    ),


                  ],
                ),
              ),
              w(15),
              Text(item['name'], style: size14_500W),
              Spacer(),
              item['status'].toString()=="false"?accepted("Requested"):   item['status'].toString()=="exit"?rejected("Exited"):auth.currentUser!.uid==item['uid']?Text("Creator", style: size14_600Gold): Text("Joined", style: size14_600Red)
            ],
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }

  chat(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: grey,
              child: Icon(Icons.person, size: 20, color: liteBlack),
            ),
            w(10),
            const Text("You", style: size14_600W),
            w(8),
            const Text("• " + "06:25", style: size12_400grey)
          ],
        ),
        h(10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
            child: Text("Lorem Ipsum Dolar", style: size14_500W),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23), color: blueClr),
        )
      ],
    );
  }

  reqList(int index) {
    return Row(
      children: [
        const Icon(CupertinoIcons.person_alt_circle_fill,
            color: grey, size: 50),
        w(15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Name", style: size14_600W),
              Text("Email", style: size12_400grey)
            ],
          ),
        ),
        // accepted(),
        // rejected()
        IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.clear_thick_circled,
                color: red, size: 30)),
        IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.check_mark_circled_solid,
                color: Colors.green, size: 30)),
      ],
    );
  }

  Widget accepted(txt) {
    return Text(txt, style: size14_600G);
  }

  Widget rejected(txt) {
    return Text(txt, style: size14_600Red);
  }

  shareSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff4F4F4F),
        context: context,
        isScrollControlled: true,

        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return  Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children:  [
                          Text('Share', style: size15_600W),
                          Spacer(),
                          IconButton(
                              icon: const Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                      h(5),

                      Divider(
                        color: Color(0xff2F2E41),
                        thickness: 1,
                      ),
                      h(5),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedShare=0;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: const Icon(CupertinoIcons.link,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // border: Border.all(color: selectedSession==0?themeClr:grey),
                                  color: selectedShare==0?themeClr:grey),
                            ),
                          ),
                          w(15),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedShare=1;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: const Icon(CupertinoIcons.bubble_left_fill,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectedShare==1?themeClr:grey),
                            ),
                          ),
                        ],
                      ),
                      h(15),
                      GestureDetector(
                        onTap: selectedShare==3000?null:() {

                          if(selectedShare==0){
                            FlutterShare.share(
                              title: 'Hey , i have started a media session in Weei App, Come and join',
                              text: "Join in this "+widget.id +" ROOM ID",
                              linkUrl: 'https://flutter.dev/',
                              // chooserTitle: 'Example Chooser Title'
                            );

                          }else {
                            Navigator.pop(context);
                            friendBottomInvite( context,widget.id);
                          }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => addVideoToSession(type: selectedSession==0?"AUDIO":"VIDEO",private: private,)),
                          // );

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => SessionScreen()),
                          // );
                        },
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: themeClr),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.share,
                                    color: Colors.white),
                              ),
                              Text(selectedShare==0?"Share link":"Direct Share", style: size14_600W)
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 10),
                      ),
                    ],
                  ),
                );
              });
        });




  }
}
