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
import 'package:weei/Helper/MusicLoading.dart';
import 'package:weei/Helper/Noti.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/friendBottomInvite.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/musicPlayerTimeFormater.dart';
import 'package:weei/Helper/openSingleMusicVideoBottom.dart';
import 'package:weei/Helper/roomExitBox.dart';
import 'package:weei/Helper/setupbgaudio.dart';
import 'package:weei/Helper/streamMessageBar.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/BannerAdsMusStr.dart';
import 'package:weei/Screens/Admob/BannerAdsVidStr.dart';
import 'package:weei/Screens/Admob/InterstitialAd.dart';
import 'package:weei/Screens/Main_Screens/Chat/sessionChatList.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';
import 'package:weei/Screens/MusicPlayer/localThumbnai.dart';
import 'package:weei/Screens/MusicPlayer/widgets/buttons/loop_button.dart';
import 'package:weei/Screens/MusicPlayer/widgets/play_list_View.dart';
import 'package:weei/Screens/MusicPlayer/widgets/streamMusicPlayerWiget.dart';
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
import 'package:background_fetch/background_fetch.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:safe_url_check/safe_url_check.dart';
// void main() async {
//
//   await setupAudio();
//
//   runApp(
//       audioPlayerScreen()
//   );
//   // runApp(const MyApp());
// }
class audioPlayerScreen extends StatefulWidget {
  final id;
  final path;
  final type;
  final ConcatenatingAudioSource concatenatingAudioSource;


  audioPlayerScreen({this.id, this.path, this.type,required this.concatenatingAudioSource});

  @override
  _audioPlayerScreenState createState() => _audioPlayerScreenState();
}

class _audioPlayerScreenState extends State<audioPlayerScreen> with WidgetsBindingObserver{
  StreamSubscription? positionSubscription;
  StreamSubscription? durationSubscription;

  var duration;
  var position;
  var showLeftTime=0;
  var showRightTime=0;

  late Query _ref;

  var yourTime = 00000;
  final databaseReference = FirebaseDatabase.instance.reference();
  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();

  ///playerconf
  final player = AudioPlayer();

  ///playerconf

  var loading = true;
  var intialLoading = true;
  var listEnd = true;
  var playlistTap = false;
  var chatlistTap = false;
  var autoPlayToggle = true;
  var updateTimeLock = false;

  TextEditingController messageController = TextEditingController();

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
  var seekListener = TextEditingController();


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
  final _playlist = ConcatenatingAudioSource(children: []);
  ValueNotifier<bool> _notifier = ValueNotifier(false);


  var musicAddCount = 0;
  var restartPage = 0;
  var  musicAddStarted=false;
  var  pageExit=false;
  var  playerStateError=false;
  var  playlistBackuped=false;
  final _playlistBackup = ConcatenatingAudioSource(children: []);
  var diffIndexPlaying = TextEditingController();


  bool _isInForeground = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    // initPlatformState();
    showInterstitialAd();
    apologySheet();
    Noti.initialize(flutterLocalNotificationsPlugin);
    WidgetsBinding.instance.addObserver(this);

    voiceNotePlayingListner.addListener((){
   if(voiceNotePlayingListner.text=="true"){

        player.setVolume(0.1);
      }else{
        player.setVolume(1.0);


      }



    });

    seekListener.addListener((){
      if(widget.type=="CREATE"){
        setControls('seekTo');

      }



    });

    // diffIndexPlaying.addListener((){
    //
    //

    //   //diffrentIndexPlaying();
    //
    // });
    navigationListner.addListener((){
      //here you have the changes of your textfield
      print("value: ${navigationListner.text}");
      //use setState to rebuild the widget

      navigationControls(navigationListner.text);

    });
    this.getIntialData();
    this.listenDataFromFireBase();

    this.listenExit();
    this.listenError();
    if(widget.type=="CREATE"){
      this.listenIndex();

    }
   // backupPlaylist();
    this.updateTime();




    // _controller.addListener(_scrollListener);
    _ref = FirebaseDatabase.instance
        .reference()
        .child('channel')
        .child(widget.id.toString() + "/joins");
//    timer = Timer.periodic(Duration(seconds: 59), (Timer t) =>   refreshPlayList());

    if(widget.type=="JOIN"){
      timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) =>   getTime());

    }
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    print("apppstatusss");
    print(state);

    switch (state) {

      case AppLifecycleState.resumed:
        print("statussss");
        print("app in resumed");


        // checkActivity();

        //  print(timer1.cancel);
        break;
      case AppLifecycleState.inactive:
        print("statussss");
        Noti.showBigTextNotification(title: "Weei is in background", body: "Make sure to place the app foreground before locking the screen ,OS may kill the app and background process", fln: flutterLocalNotificationsPlugin);




        break;
      case AppLifecycleState.paused:
        print("app in paused");



        break;
      case AppLifecycleState.detached:
        print("app in detached");



        break;
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
          chatAlert=true;
          refreshState();

        break;


      case "CHATALERT_FALSE":
          chatAlert=false;
          refreshState();

          break;

      case "JOINALERT_TRUE":



          joinAlert=true;
          refreshState();

          break;


      case "JOINALERT_FALSE":

          joinAlert=false;
          refreshState();

          break;



      case "ADMINCONTROLS_TRUE":

          creatorControl=true;
          refreshState();

          break;


      case "ADMINCONTROLS_FALSE":
        refreshState();

        creatorControl=false;
          refreshState();

          break;


      case "JOINCONTROLS_TRUE":

          controlJoined=true;
          refreshState();

          break;


      case "JOINCONTROLS_FALSE":

          controlJoined=false;
          refreshState();

          break;


    ///chat alert single controls
    ///sound
      case "CHATSOUND_TRUE":

          chatSound=true;
          refreshState();

          break;


      case "CHATSOUND_FALSE":

          chatSound=false;
          refreshState();

          break;

    ///sound

    ///vibrate
      case "CHATVIBRATE_TRUE":

          chatVibrate=true;
          refreshState();

          break;


      case "CHATVIBRATE_FALSE":

          chatVibrate=false;
          refreshState();

          break;
    ///vibrate
    ///
    ///pop
      case "CHATPOPUP_TRUE":

          chatPopup=true;
          refreshState();

          break;


      case "CHATPOPUP_FALSE":

          chatPopup=false;
          refreshState();

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
            player.dispose();
            showToastSuccess("Creator removed you !");
            Navigator.pop(context);
          }

          break;
      }
    });
  }





  refreshState(){
    _notifier.value = !_notifier.value;
  }
  listenDataFromFireBase() {
    var db = FirebaseDatabase.instance.reference().child("channel");
    db.child(widget.id.toString()).onChildChanged.listen((data) {
      switch (data.snapshot.key.toString()) {


        case "private":
          var rsp = data.snapshot.value.toString();

            private=rsp.toString();
            refreshState();

            break;
        case "index":
        // do something

          var rsp = data.snapshot.value.toString();


            currentIndex = int.parse(rsp.toString());
            refreshState();
          //  loadNewAudioAdmin(currentIndex);

          //  loadNewAudioAdmin((currentIndex+1));


            // if(widget.type=="JOIN"){
            //  // var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());
            //
            //
            //   _playlist.insert(currentIndex, AudioSource.uri(
            //     Uri.parse(url),
            //     tag: MediaItem(
            //       // Specify a unique ID for each media item:
            //       id:currentIndex.toString(),
            //       // Metadata to display in the notification:
            //       album: "Weei Audio",
            //       title: playList[currentIndex]['fileName'].toString(),
            //       artUri: Uri.parse(playList[currentIndex]['fileThumb'].toString()),
            //       artist:  playList[currentIndex]['fileType'].toString(),
            //       // extras: {
            //       //   'fileName':  playList[i]['fileName'].toString(),
            //       //   'fileThumb':  playList[i]['fileThumb'].toString(),
            //       //   'fileUrl':  playList[i]['fileUrl'].toString(),
            //       //   'fileType':  playList[i]['fileType'].toString(),
            //       //
            //       // },
            //     ),
            //   ));
            //
            //   getControl("seekTo");
            //   Future.delayed(const Duration(seconds: 5), () {goLive(); });
            // }

            break;
        case "url":
          var rsp = data.snapshot.value.toString();

            url = rsp.toString();
            loadNewAudioAdmin(url);
          // if(widget.type=="JOIN"){
          //   // var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());
          //
          //
          //   _playlist.insert(currentIndex, AudioSource.uri(
          //     Uri.parse(url),
          //     tag: MediaItem(
          //       // Specify a unique ID for each media item:
          //       id:currentIndex.toString(),
          //       // Metadata to display in the notification:
          //       album: "Weei Audio",
          //       title: playList[currentIndex]['fileName'].toString(),
          //       artUri: Uri.parse(playList[currentIndex]['fileThumb'].toString()),
          //       artist:  playList[currentIndex]['fileType'].toString(),
          //       // extras: {
          //       //   'fileName':  playList[i]['fileName'].toString(),
          //       //   'fileThumb':  playList[i]['fileThumb'].toString(),
          //       //   'fileUrl':  playList[i]['fileUrl'].toString(),
          //       //   'fileType':  playList[i]['fileType'].toString(),
          //       //
          //       // },
          //     ),
          //   ));
          //
          //   getControl("seekTo");
          //   Future.delayed(const Duration(seconds: 5), () {goLive(); });
          // }
            refreshState();

            break;

        case "name":
          var rsp = data.snapshot.value.toString();

            name = rsp.toString();
            refreshState();

            break;
        case "videoType":
          var rsp = data.snapshot.value.toString();

            videoType = rsp.toString();
            refreshState();

            break;
         case "time":
        var rsp = data.snapshot.value.toString();
        if (this.mounted) {


          adminTime = int.parse(rsp.toString());
            refreshState();

          }
        break;

        case "exit":
          var rsp = data.snapshot.value.toString();
          if (rsp == "true") {
            Navigator.pop(context);
          }
          break;

        case "chat":
          var rsp = data.snapshot.value;



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

          refreshState();

          thumbnail = rsp;
            refreshState();


            break;
        case "controller":
          var rsp = data.snapshot.value.toString();
          print("controller");
          print(rsp);
          print("controller");

          refreshState();

          controller = rsp;
            refreshState();

            if(creatorControl==true){
            getControl(rsp);

          }
          break;

        case "joins":
          var rsp = data.snapshot.value;


            joinList = rsp;
            participantsBubble=true;

            refreshState();

            if(widget.type=="CREATE"){
            if(totalJoined !=joinList.length){

              if(joinAlert==true){
                // FlutterRingtonePlayer.playNotification();
                //
                // Vibrate.vibrate();
                // showToastSuccess("New Join!");
                Noti.showBigTextNotification(title: "Join alert ", body: "Someone requested to join the session".toString(), fln: flutterLocalNotificationsPlugin);

              }

                totalJoined=joinList.length;
                refreshState();

              }else{

                totalJoined=joinList.length;
                refreshState();

              }


            if(joinBottomShowed==false){
              joinBottomSheet();
            }

              joinBottomShowed=true;
              refreshState();

            }

          // print(totalJoined);
          break;

        case "intialStart":
          var rsp = data.snapshot.value.toString();
            setState(() {
              intialStart = rsp.toString();

            });
            refreshState();

            break;
      }
    });
  }

  void getIntialData() async {
    print("initiall get");
  await  databaseReference
        .child('channel')
        .child(widget.id.toString())
        .once()
        .then((snapshot) async {
      var time = snapshot.snapshot.child('time').value=="null"?000: snapshot.snapshot.child('time').value;

      adminTime = int.parse(time.toString());
      videoType = snapshot.snapshot.child('videoType').value;
      private=snapshot.snapshot.child('private').value;
      var  path1 = snapshot.snapshot.child('playlist').value;

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
      // setState(() {
      //   loading=false;
      // });
      print("initiall get end");
      print(path);
      print(path1);

    }).whenComplete(() {

    });

    getPlayList(path);
  }

  void getPlayList(_path) {
    print("initiall get pl");
    print(_path);

    databaseReference.child(_path).once().then((snapshot) async {
      var data = snapshot.snapshot.value;

      playList = data;

    }).whenComplete(() {
      // if (widget.type.toString() == "CREATE") {
      //   updateUrl(0);
      // } else {
      //   print("feethh");
      //   videoInitilize();
      // }
       if(widget.concatenatingAudioSource.length==0){
         addToPlaylist();
         print("throug playlist");
       }else{
         print("not playlist");

         _playlist.addAll(widget.concatenatingAudioSource.children).onError((error, stackTrace) => print("failllll "+error.toString()));
         setState(() {
           intialLoading=false;
         });
       }
       print("initiall pl end");

      //  setUpChannel("playList[0][0]['fileUrl']");
    });
  }
  addToPlaylist()async{
    // _audioPlayer.player.dispose();
    setState(() {
      musicAddStarted=true;
    });
    for (var i = 0; i < playList.length; i++) {
      var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());

      setState(() {
        musicAddCount = i;
      });

      // _audioPlayer.addToPlayList(_playlist, playList);
      _playlist.add( AudioSource.uri(
        Uri.parse(link),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id:i.toString(),
          // Metadata to display in the notification:
          album: "Weei Audio",
          title: playList[i]['fileName'].toString(),
          artUri: Uri.parse(playList[i]['fileThumb'].toString()),
          artist:  playList[i]['fileType'].toString(),

        ),
      ));
      print("nameeeee");
      print(playList[i]['fileName'].toString());
    }
    // _audioPlayer.playAudios(_playlist);

    //  _audioPlayer.player.setAudioSource(_playlist);
    setState(() {
      // player.seek(
      //   Duration(
      //     milliseconds: adminTime,
      //   ),
      // );
      musicAddStarted=false;
      intialLoading=false;
      goLive();
      Future.delayed(const Duration(seconds: 5), () {goLive(); });

      if(widget.type=="JOIN"){
        player.setLoopMode(LoopMode.one);
      }
      if(intialStart=="true"&&controller!="pause"){
        player.play();
      }
      //  _audioPlayer.play();

    });
  }

  listenIndex(){



      player.currentIndexStream.listen((index) {



        print("listenn indexx2");
          if(intialLoading==false){


            print("listenn indexx1");
               print(index);

           currentIndex =index;
           // loadNewAudioAdmin((index!+1));

           refreshState();
           updateUrl(index);

        }

      });




      player.playingStream.listen((value) {
        setControls(value==true?'play':'pause');
      });
      player.playerStateStream.listen((processingState) {

        if (processingState.processingState == ProcessingState.loading || processingState.processingState == ProcessingState.buffering) {
          setControls('pause');
        }else{
          setControls(player.playing==true?'play':'pause');
        }

      }
      );
  //  }

  }
  loadNewAudioAdmin(url)async{



    // player.currentIndexStream.listen((i) async{

      // if(playlistBackuped==true){
      //   print("backupp kayatunn");
      //   _playlist.clear();
      //  var sv = await  _playlist.addAll(_playlistBackup.children);
      //    playlistBackuped=false;
      //      refreshState();
      //     if(widget.type=="CREATE"){
      //        player.seek(Duration(seconds: 0),index: index);
      //     }else{
      //        goLive();
      //     }
      //   print("backupp erakkunnu");
      //
      // }

     // player.stop();
       //print("refreshing next item : "+i.toString());
      // var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());
      //
      //
      // _playlist.insert(i!, AudioSource.uri(
      //   Uri.parse(link),
      //   tag: MediaItem(
      //     // Specify a unique ID for each media item:
      //     id:i.toString(),
      //     // Metadata to display in the notification:
      //     album: "Weei Audio",
      //     title: playList[i]['fileName'].toString(),
      //     artUri: Uri.parse(playList[i]['fileThumb'].toString()),
      //     artist:  playList[i]['fileType'].toString(),
      //     // extras: {
      //     //   'fileName':  playList[i]['fileName'].toString(),
      //     //   'fileThumb':  playList[i]['fileThumb'].toString(),
      //     //   'fileUrl':  playList[i]['fileUrl'].toString(),
      //     //   'fileType':  playList[i]['fileType'].toString(),
      //     //
      //     // },
      //   ),
      // ));
      // _playlist.removeAt((i+1));

      // print("changingg"+ i.toString());
      // print(playList[i]['fileName'].toString());
      // if(widget.type=="CREATE"){
      //   player.seek(Duration(seconds: 0),index: i);
      //   Future.delayed(const Duration(seconds: 2), () {player.play();});
      // }else{
      //     getControl("seekTo");
      //     Future.delayed(const Duration(seconds: 6), () {goLive(); });
      // }

     //player.play();

    // });


    //  }

       if(widget.type=="JOIN"){
         var link;
         final exists = await safeUrlCheck(
           Uri.parse(url),
         //  userAgent: 'myexample/1.0.0 (+https://example.com)',
         );
         if (exists) {
           link = url;
           print('The url: https://google.com is NOT broken');
         }else{
           print('The url: https://google.com is  broken');

           link = await getSong(playList[currentIndex]['fileUrl'].toString(),playList[currentIndex]['fileType'].toString());

         }


         _playlist.insert(currentIndex, AudioSource.uri(
           Uri.parse(link),
           tag: MediaItem(
             // Specify a unique ID for each media item:
             id:currentIndex.toString(),
             // Metadata to display in the notification:
             album: "Weei Audio",
             title: playList[currentIndex]['fileName'].toString(),
             artUri: Uri.parse(playList[currentIndex]['fileThumb'].toString()),
             artist:  playList[currentIndex]['fileType'].toString(),
             // extras: {
             //   'fileName':  playList[i]['fileName'].toString(),
             //   'fileThumb':  playList[i]['fileThumb'].toString(),
             //   'fileUrl':  playList[i]['fileUrl'].toString(),
             //   'fileType':  playList[i]['fileType'].toString(),
             //
             // },
           ),
         ));

         getControl("seekTo");
         Future.delayed(const Duration(seconds: 5), () {goLive(); });
       }

  }
  void updateUrl(index) async {
    print("tyeeeeee");
    print(widget.type.toString());
    if(widget.type.toString() == "CREATE"){
      print("CREATEulil");

      var _url = await getSong(playList[index]['fileUrl'].toString(),
          playList[index]['fileType'].toString());
      databaseReference.child('channel').child(widget.id).update({
        'url': _url,
        'name': playList[index]['fileName'].toString(),
        'index': index.toString(),
        'thumbnail': playList[index]['fileThumb'].toString(),
      }).whenComplete(() {

        url = _url;
        name = playList[index]['fileName'].toString();
        currentIndex = index;
        thumbnail = playList[index]['fileThumb'].toString();
      });
      refreshState();
    }

  }

  // refreshPlayItem(i)async{
  //   if (widget.type == "JOIN") {
  //     player.stop();
  //     var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());
  //
  //
  //     _playlist.insert(i!, AudioSource.uri(
  //       Uri.parse(link),
  //       tag: MediaItem(
  //         // Specify a unique ID for each media item:
  //         id:i.toString(),
  //         // Metadata to display in the notification:
  //         album: "Weei Audio",
  //         title: playList[i]['fileName'].toString(),
  //         artUri: Uri.parse(playList[i]['fileThumb'].toString()),
  //         artist:  playList[i]['fileType'].toString(),
  //         // extras: {
  //         //   'fileName':  playList[i]['fileName'].toString(),
  //         //   'fileThumb':  playList[i]['fileThumb'].toString(),
  //         //   'fileUrl':  playList[i]['fileUrl'].toString(),
  //         //   'fileType':  playList[i]['fileType'].toString(),
  //         //
  //         // },
  //       ),
  //     ));
  //     _playlist.removeAt((i+1));
  //     print("changeeeeyy");
  //     print(playList[i]['fileName'].toString());
  //     player.seek(Duration(seconds: 0),index: i);
  //     Future.delayed(const Duration(seconds: 2), () {
  //
  //       player.play();
  //       getControl("seekTo");
  //     });
  //
  //     Future.delayed(const Duration(seconds: 5), () {goLive(); });
  //   }
  //
  // }

  refreshPlayList()async{
    if(intialStart=="true"&&pageExit==false){
   //   _playlistBackup.clear();
      print("backupp list refresh started"+currentIndex.toString());

      for (var i = 0; i < playList.length; i++) {


        if(currentIndex!=i){
          var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());


          _playlist.insert(i, AudioSource.uri(
            Uri.parse(link),
            tag: MediaItem(
              // Specify a unique ID for each media item:
              id:i.toString(),
              // Metadata to display in the notification:
              album: "Weei Audio",
              title: playList[i]['fileName'].toString(),
              artUri: Uri.parse(playList[i]['fileThumb'].toString()),
              artist:  playList[i]['fileType'].toString(),
              // extras: {
              //   'fileName':  playList[i]['fileName'].toString(),
              //   'fileThumb':  playList[i]['fileThumb'].toString(),
              //   'fileUrl':  playList[i]['fileUrl'].toString(),
              //   'fileType':  playList[i]['fileType'].toString(),
              //
              // },
            ),
          ));
          _playlist.removeAt((i+1));

          print("nameeeee");
          print(playList[i]['fileName'].toString());


        }
        playlistBackuped=true;
        refreshState();
        }

      print("backupp list refresh ended");
    }


  }

   // diffrentIndexPlaying(){
   // if(diffIndexPlaying.text.toString()!=playList[currentIndex]['fileName'].toString()){
   //   player.pause();
   //
   //   _playlist.insert(currentIndex, AudioSource.uri(
   //     Uri.parse(url),
   //     tag: MediaItem(
   //       // Specify a unique ID for each media item:
   //       id:currentIndex.toString(),
   //       // Metadata to display in the notification:
   //       album: "Weei Audio",
   //       title: playList[currentIndex]['fileName'].toString(),
   //       artUri: Uri.parse(playList[currentIndex]['fileThumb'].toString()),
   //       artist:  playList[currentIndex]['fileType'].toString(),
   //       // extras: {
   //       //   'fileName':  playList[i]['fileName'].toString(),
   //       //   'fileThumb':  playList[i]['fileThumb'].toString(),
   //       //   'fileUrl':  playList[i]['fileUrl'].toString(),
   //       //   'fileType':  playList[i]['fileType'].toString(),
   //       //
   //       // },
   //     ),
   //   ));
   //
   //   getControl("seekTo");
   //   Future.delayed(const Duration(seconds: 5), () {goLive(); });
   //    if(controller=='play'){
   //      player.play();
   //
   //    }
   // }
   //
   //
   //
   // }
  void listenError() async{
    player.playerStateStream.listen((processingState) {

      if (processingState.processingState == ProcessingState.loading || processingState.processingState == ProcessingState.buffering) {
        playerStateError=true;
        refreshState();
        _stopWatchTimer.onStartTimer();
        _stopWatchTimer.secondTime.listen((value) {
          if(value>15){

            restartAlert();

            // showToastSuccess("Unexpected error occurred, restarting the player");
            //   player.stop();
            //     setState(() {
            //
            //     });
            // player.pause();
            //     _playlist.insert(currentIndex, AudioSource.uri(
            //   Uri.parse(url),
            //   tag: MediaItem(
            //     // Specify a unique ID for each media item:
            //     id:currentIndex.toString(),
            //     // Metadata to display in the notification:
            //     album: "Weei Audio",
            //     title: playList[currentIndex]['fileName'].toString(),
            //     artUri: Uri.parse(playList[currentIndex]['fileThumb'].toString()),
            //     artist:  playList[currentIndex]['fileType'].toString(),
            //     // extras: {
            //     //   'fileName':  playList[i]['fileName'].toString(),
            //     //   'fileThumb':  playList[i]['fileThumb'].toString(),
            //     //   'fileUrl':  playList[i]['fileUrl'].toString(),
            //     //   'fileType':  playList[i]['fileType'].toString(),
            //     //
            //     // },
            //   ),
            // ));
            //       if(widget.type=="JOIN"){
            //         // getControl("seekTo");
            //         // Future.delayed(const Duration(seconds: 5), () {goLive(); });
            //         // Future.delayed(const Duration(seconds: 7), () { player.play();});
            //         Future.delayed(const Duration(seconds: 2), () { player.seek(Duration(seconds: 0) ,index:  currentIndex);});
            //         Future.delayed(const Duration(seconds: 5), () { player.play();});
            //       }else{
            //         Future.delayed(const Duration(seconds: 2), () { player.seek(Duration(seconds: 0) ,index:  currentIndex);});
            //         Future.delayed(const Duration(seconds: 5), () { player.play();});
            //       }
            //
            // // showToastSuccess("Unexpected error occurred, restarting the player");
            // // restartPage=DateTime.now().millisecondsSinceEpoch;

          }


        });

        //refreshState();
      }else{
         playerStateError=false;
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.onResetTimer();
        refreshState();

      }

     // if (processingState.processingState == ProcessingState.completed) {
     //    if(playlistBackuped==true){
     //      print("backupp kayatunn");
     //      _playlist.addAll(_playlistBackup.children);
     //      playlistBackuped=false;
     //      refreshState();
     //      print("backupp erakkunnu");
     //
     //    }

        // Some Stuff
   //   }

    });



  }

  void updateTime() {

    player.positionStream.listen((time) {

      if(intialLoading==false){
        yourTime =  time.inMilliseconds;
        print("yourTime");
        print(yourTime);
        refreshState();


        if (widget.type.toString() == "CREATE") {

          databaseReference.child('time').child(widget.id).update({
            'time': time.inMilliseconds.toString(),
          });
          // sendTimeToDb();
        }
      }


    });

  }



  getTime()async{
    if(widget.type=="JOIN"){

      if(controller!="pause"&&pageExit==false&&intialLoading==false&&intialStart=='true'){


        if((yourTime<(adminTime-1500) ||yourTime>(adminTime+2000))==false ){
          print("live-------");

          print("live aayi");

          var set = adminTime +500;
          adminTime=set;
          fetchTimeBg=true;

          refreshState();
        }else {
          print("live-------");
          print("alaaa");
          if(fetchTimeBg==true){
            databaseReference.child('time').child(widget.id).once().then((
                snapshot) async {
              var rsp = snapshot.snapshot
                  .child('time')
                  .value;

              adminTime = int.parse(rsp.toString());

              fetchTimeBg = false;


              refreshState();
              if(player.playing==true&&playerStateError==false){
                goLive();
              }
            });
          }
        }




      }


    }



  }
  getCurrentTime()async{


      var rsp = await  databaseReference.child('time').child(widget.id).once().then(( snapshot) async {
      var rsp = snapshot.snapshot.child('time').value;

        adminTime=int.parse(rsp.toString());
     //   player.seek(Duration(milliseconds: adminTime),index: currentIndex);

    });
  }
  void getControl(control) {
    // print("seekaneey");
    if (widget.type == "JOIN") {

      if (control == "play") {



        player.play();



        getCurrentTime();
      }
      if (control == "pause") {

          player.pause();
          musicPlaying = false;
          refreshState();


          getCurrentTime();
      }
      if (control == "next") {
        // player.dispose();
        player.pause();



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
     if(widget.type=="CREATE"){

       if(controlJoined==false){

         return;
       }

       if (event == "seekTo") {
         print("seekaney");
         databaseReference.child('channel').child(widget.id).update({
           'controller': event.toString(),
           'time': yourTime.toString(),
           'index': currentIndex.toString(),

         }).whenComplete((){
           databaseReference.child('channel').child(widget.id).update({
             'controller': player.playing==true?'play':'pause',
             'time': yourTime.toString(),
           });




         });


       }
       if (event == "play") {
         databaseReference.child('channel').child(widget.id).update({
           'controller': event.toString(),
           'time': yourTime.toString(),
         });

       }
       if (event == "pause") {
         databaseReference.child('channel').child(widget.id).update({
           'controller': event.toString(),
           'time': yourTime.toString(),
         });

       }
       if (event == "next") {
         databaseReference.child('channel').child(widget.id).update({
           'controller': event.toString(),
           'time': yourTime.toString(),
         });

       }

       if (event == "exit") {
         databaseReference.child('channel').child(widget.id).update({
           'controller': event.toString(),

         });

         // Navigator.pop(context);
       }

     }

  }

  void goLive() async{

   // player.pause();
    var liv= await   getCurrentTime();

    player.seek(Duration(milliseconds: (int.parse(adminTime.toString())+500)),index: currentIndex);
    // if (player.playing == true) {
    //   player.play();
    // }

    // _betterPlayerController.play();
    // _betterPlayerController.play();
  }

  void seekTo()async {
    var liv= await   getCurrentTime();
    //
    player.seek(Duration(milliseconds: (int.parse(adminTime.toString())+500)));

    // _betterPlayerController.play();
    // _betterPlayerController.play();
  }







  @override
  void dispose() {
    showInterstitialAd();
    setState(() {
      pageExit=true;
      timer.cancel();

    });
    player.stop();
    player.dispose();
    _subscription.cancel();


    super.dispose();
  }

  void _handleEvent(event) {
    if (widget.type.toString() == "CREATE") {
      setControls(event);
    }

  }
  Future<bool> _onBackPressed() async {
    bool goBack = false;

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
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        endDrawer: VideoDrawerWidget(type: widget.type,id: widget.id,uid: auth.currentUser!.uid,controller: navigationListner,private: private,disableComment:chatAlert,disableJoinAlert:joinAlert,disableAdminControls:creatorControl,controlJoins:controlJoined,chatPopup: chatPopup,chatSound: chatSound,chatVibrate: chatVibrate,context:context),


        resizeToAvoidBottomInset: true,
        appBar:

        AppBar(

          elevation: 0,
          actions: [
            ValueListenableBuilder(
              valueListenable: _notifier,
              builder: (BuildContext context, bool value, Widget? child) {
                return Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Stack(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {

                            participantsBubble=false;

                            refreshState();



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
                );
              },

            )
            ,
            ( widget.type == "JOIN"&&intialStart=="true"&&intialLoading==false)
                ? ValueListenableBuilder(
              valueListenable: _notifier,
              builder: (BuildContext context, bool value, Widget? child) {
                return Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment:
                  Alignment.topRight,

                  //    color: Colors.black54,
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
                              color: (yourTime < (adminTime - 1500) || yourTime > (adminTime + 2000))
                                  ? Colors
                                  .orange
                                  : red),
                          child: Padding(
                            padding: EdgeInsets
                                .symmetric(
                                horizontal:
                                10),
                            child: Text(
                                (yourTime < (adminTime - 1500) || yourTime > (adminTime + 2000))
                                    ? "Go Live"
                                    : "Live",
                                style: size12_600W),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },

            )


                : Container(),
            Builder(builder: (context) => // Ensure Scaffold is in context

                ValueListenableBuilder(
                  valueListenable: _notifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return   IconButton(
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
                        ));
                  },

                )

            ),
          ],

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
        bottomNavigationBar:  ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (BuildContext context, bool value, Widget? child) {
            return Container(
              color: liteBlack,
              height: chatlistTap == true?7:50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: (Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed:(widget.type=="JOIN"&&intialStart=="false")?null: () {
                          playlistBottomSheet(height);

                          _notifier.value = !_notifier.value;
                        },
                        icon: Icon(CupertinoIcons.line_horizontal_3,
                            color:
                            playlistTap == true ? themeClr : Colors.white)),
                    BannerAdsMusStr(),
                    IconButton(
                        onPressed: () {
                          chatBottomSheet(width);
                          _notifier.value = !_notifier.value;
                          // chatBottomSheet();
                        },
                        icon: Icon(Icons.chat,
                            color:
                            chatlistTap == true ? themeClr : Colors.white,
                            size: 20)),
                  ],
                )),
              ),
            );
          },

        ),

        body:
        intialLoading==true?   ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (BuildContext context, bool value, Widget? child) {
            return  Container(
              color: Color(0xff2B2B2B),
              child: Column(
                children: [
                  musicAddStarted==true? Container(
                    height: 25,
                    decoration: BoxDecoration(

                        color: themeClr),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [

                        Text("Fetching playlist " + musicAddCount.toString()+" / "+playList.length.toString(), style: size13_600W)
                      ],
                    ),
                  ):Container(),
                  MusicLoading(height: (ss.height),),
                ],
              ),
            );
          },

        )

            :( intialStart == 'false' ?  ValueListenableBuilder(
          valueListenable: _notifier,
          builder: (BuildContext context, bool value, Widget? child) {
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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

                    // w(5),
                    //  CircleAvatar(
                    //   backgroundColor: grey,
                    //   child: Icon(Icons.copy, size: 10),
                    //   radius: 10,
                    // )
                  ],
                ),
                SizedBox(height: 5),

                // h(ss.height * 0.03),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: AspectRatio(
                      aspectRatio: 1,
                      child:  Container(
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
                              // player.play();
                              // _handleEvent("play");
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





                  ),
                ),

                // h(ss.height * 0.05),

              ],
            );
          },

        )
       :
        Column(
        //  key: Key('builder ${restartPage.toString()}'), //
          children: [
            audioPlayerStreamWidget(audioPlayer:player,playlist:_playlist,autoPlay: false,id:widget.id,seekListener:seekListener,diffIndexPlaying:diffIndexPlaying, type: widget.type,),

          ],
        )
        //)

      ),
    ));
  }

  // MusicList(var item, int index) {
  //   return GestureDetector(
  //     onTap: widget.type == "JOIN"
  //         ? null
  //         : () {
  //       if (widget.type == "CREATE" && intialStart == 'false') {
  //         showToastSuccess("Session not yet started!");
  //         return;
  //       }
  //
  //       setState(() {
  //         player.pause();
  //
  //         loading = true;
  //         currentIndex = index;
  //       });
  //
  //       // if(loading==false){
  //
  //
  //
  //       playNext(index, context);
  //
  //       //  }
  //     },
  //     child: Row(
  //       children: [
  //         Container(
  //           height: 33,
  //           child: currentIndex == index
  //               ?Image.asset("assets/svg/nowPlaying.gif")
  //               : Icon(Icons.music_note_rounded, color: Colors.pink),
  //           width: 33,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[200],
  //             borderRadius: BorderRadius.circular(5),
  //           ),
  //         ),
  //         w(10),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(item['fileName'].toString(), style: currentIndex == index?size14_500G:size14_500W),
  //               h(5),
  //               //Text(getFileSize(int.parse(item['fileSize'].toString()),1).toString(), style: size14_500Grey),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // chhat(var item,int index) {
  //
  //
  //   print("itemmmm");
  //   print(auth.currentUser!.uid);
  //   return Column(
  //     crossAxisAlignment: auth.currentUser!.uid==item['uid'].toString()?CrossAxisAlignment.end:CrossAxisAlignment.start,
  //     children: [
  //       Row(
  //         children: [
  //           CircleAvatar(
  //             radius: 12,
  //             child: Stack(
  //               clipBehavior: Clip.none,
  //               fit: StackFit.expand,
  //               children: [
  //                 ClipOval(
  //                   child:  Container(
  //                     height: 23,
  //                     color: Colors.black,
  //                     child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
  //                     width: 23,
  //
  //                   ),
  //                 ),
  //
  //
  //               ],
  //             ),
  //           ),
  //           w(10),
  //           Text(auth.currentUser!.uid==item['uid']?"You":item['name'].toString(), style: size14_600W),
  //           w(8),
  //           Text("• " + item['time'].toString(), style: size12_400grey)
  //         ],
  //       ),
  //       h(10),
  //       Container(
  //         margin:  EdgeInsets.symmetric(horizontal: 25),
  //         child:  Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
  //           child: Text(item['message'].toString(), style: size14_500W),
  //         ),
  //         decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(23), color: auth.currentUser!.uid==item['uid']?Colors.grey[100]:blueClr),
  //       )
  //     ],
  //   );
  // }



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

  playlistBottomSheet(height) {

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff1e1e1e),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 7,right: 5,top:15),
                    child: Row(
                      children:  [
                        Text('Playlist ('+_playlistBackup.length.toString()+' Songs)', style: size14_600W),
                        Spacer(),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(CupertinoIcons.xmark_circle_fill,
                              color: grey, size: 25),
                        )
                      ],
                    ),
                  ),
                  h(5),

                  Divider(
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  h(10),
                  PlaylistView(player: player, playlist: widget.type=="JOIN"?_playlistBackup:_playlist,height: height,type: widget.type,),
                  BannerAdsVidStr(),
                  //musicPlayList(playList:playList, player:_audioPlayer,title:index)
                ],
              ),
            );
          });
        });




    //future.then((void value) => _closeModal(value));
  }


  chatBottomSheet(width) {
  showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          height: 60,
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,right: 10),
                            child: Row(
                              children: [

                                 Spacer(),
                                IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.fullscreen_exit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                        ),
                        BannerAdsVidStr(),
                      //  const Divider(color: Color(0xff404040), thickness: 1),
                        sessionChatList(code: widget.id,voiceNotePlayingListner: voiceNotePlayingListner,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MessageBar(width: width,id: widget.id,videoController: player,),
                        )
                      ],
                    ),
                  ),
                ]);
              });
        });


  }

  void restartAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgClr,
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: const Text('Player Error!',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'mon',
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Unexpected error occurred, Restart player?",
                      style: size14_600W)
                ],
              );
            }),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No", style: size14_600White)),
          TextButton(
              onPressed: () async {
                restart();
              },
              child: const Text("Yes", style: size14_600White))
        ],
      ),
    );
  }

  restart(){
    player.stop();
    setState(() {

    });
    Navigator.pop(context);
  }
  apologySheet()async {

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: liteBlack,
        context: context,
        // enableDrag:mandatory=='true'? false:true,
        // isDismissible:mandatory=='true'? false:true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Container(
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20), color: liteBlack),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children:  [
                        Text("*LEAVE APP IN FORGROUND WHILE LOCKING THE SCREEN !*", style: size14_600W),
                        Spacer(),

                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),
                    Text("While streaming music make sure to place the app on screen before locking the screen.\n Placing the app in background and locking the screen may exit the app , OS will kill the app.", style: size14_500Grey),
                    h(25),
                    Row(
                      children: [
                        Expanded(
                          child: buttons("Done", themeClr, ()async {

                            Navigator.pop(context);
                            // if (Platform.isAndroid) {
                            //   // Android-specific code
                            //   // final Uri _url = Uri.parse(ANDROIDURL);
                            //   //
                            //   // if (!await launchUrl(_url)) {
                            //   //   throw Exception('Could not launch $_url');
                            //   // }
                            //
                            //
                            // } else if (Platform.isIOS) {
                            //   // iOS-specific code
                            //   final Uri _url = Uri.parse(IOSURL);
                            //
                            //   if (!await launchUrl(_url)) {
                            //     throw Exception('Could not launch $_url');
                            //   }
                            // }

                          }

                          ),
                        ),




                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  buttons(String txt, Color clr, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: clr),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(txt, style: size14_600W),
        ),
      ),
    );
  }
}
