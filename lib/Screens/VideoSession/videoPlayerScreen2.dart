// ignore_for_file: sort_child_properties_last, prefer_const_constructors
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'dart:convert';
import 'dart:io';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weei/Helper/Const.dart';
import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:better_player/better_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Noti.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/checkUrl.dart';
import 'package:weei/Helper/friendBottomInvite.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/gmtTime.dart';
import 'package:weei/Helper/playVoiceNote.dart';
import 'package:weei/Helper/playVoiceNote2.dart';
import 'package:weei/Helper/roomExitBox.dart';
import 'package:weei/Helper/streamMessageBar.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/BannerAdsVidStr.dart';
import 'package:weei/Screens/Admob/InterstitialAd.dart';
import 'package:weei/Screens/Main_Screens/Chat/sessionChatList.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';
import 'package:weei/Screens/Session/Session_Screen.dart';
import 'package:weei/Screens/VideoSession/Data/acceptOrDeclne.dart';
import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';
import 'package:weei/Screens/VideoSession/VideoCrontrolDrawer.dart';
import 'package:weei/Testing/constants.dart';
import 'Data/sendMessageInSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:screen_state/screen_state.dart';

class VideoPlayerScreen2 extends StatefulWidget {

  final id;
  final path;
  final type;

  VideoPlayerScreen2({this.id,this.path,this.type}) ;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Query _ref;
  late Query _chat;
  var totalJoined =0;
  var selectedShare =0;
  var yourTime= 00000;
  final databaseReference = FirebaseDatabase.instance.reference();
  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();
  late BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();

  List<BetterPlayerEvent> events = [];
  StreamController<DateTime> _eventStreamController = StreamController.broadcast();
  var loading=true;
  var listEnd=true;
  var intialStart="false";
  var playlistTap=false;
  var playlingStatus="pause";
  var _autoPlay=false;
  var autoPlayToggle=true;
  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var private;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //Stopwatch stopwatch =  Stopwatch()..start();
  var adminTime= 00000;
  var LiveTime= 00000;
  var gmTime= 00000;
  var bufferTime= 0000;
  var videoType;
  var playList;
  var chatList;
  var joinList;
  var chatReversedList;

  var path;

  var controller;
  var playing;
  var adminId;
  var url;
  var currentIndex;
  var name;
  var exit;
  var joins;

  bool seesionJoins =false;
  bool itemLoading =false;
  bool joinAlert =true;
  bool creatorControl =true;
  bool controlJoined =true;
  bool participantsBubble =false;

  ///for cht noti

  bool videoFulscreen =false;
  bool chatAlert =true;
  bool chatFullScreen =true;


  var chatSound = true;
  var chatPopup = true;
  var chatVibrate = true;
  var timeUpdate = true;
  var joinBottomShowed = false;
  var fetchTimeBg = true;

  var navigationListner = TextEditingController();
  var voiceNotePlayingListner = TextEditingController();
  var navigationExitListner = TextEditingController();

  late Screen _screen;
  late StreamSubscription<ScreenStateEvent> _subscription;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  late Timer timer;

  @override
  void initState() {
    showInterstitialAd();
    Noti.initialize(flutterLocalNotificationsPlugin);

    Wakelock.enable();
    navigationExitListner.addListener((){
      //here you have the changes of your textfield
      print("value: ${navigationListner.text}");
      //use setState to rebuild the widget
      Navigator.pop(context);
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
        _betterPlayerController.setVolume(0.1);
      }else{
        _betterPlayerController.setVolume(1.0);
        //  print("kooott");

      }
      //  navigationControls(navigationListner.text);


    });




    print("widget.id");
    print(widget.id);


    this.getIntialData();
    this.listenDataFromFireBase();
    this.listenExit();
    this.startListening();
    this.listenError();

    // if(widget.type=="JOIN"){
    //   this.countDown();
    //
    // }

    _ref = FirebaseDatabase.instance
        .reference()
        .child('channel').child(widget.id.toString()+"/joins");


    // _controller.addListener(_scrollListener);


    if(widget.type=="JOIN"){
      timer = Timer.periodic(Duration(milliseconds: 500), (Timer t) =>   getTime());

    }
    super.initState();
  }
  listenError(){
    Future.delayed(const Duration(seconds: 59), () {

// Here you can write your code

      if(loading==true){
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
        playlistTap=true;
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

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }



  listenExit() {

    var db = FirebaseDatabase.instance.reference();
    db.child('channel').child(widget.id.toString()+"/joins").child(auth.currentUser!.uid).onChildChanged.listen((data) {




      switch (data.snapshot.key.toString()) {
        case "status":
        // do something

          var rsp = data.snapshot.value.toString();


          if(rsp=="exit"){
            showToastSuccess("Creator removed you !");
            Navigator.pop(context);
          }

          break;





      }


    });


  }
  listenDataFromFireBase() {
    print("listeningggg");

    var db = FirebaseDatabase.instance.reference().child("channel");
    db.child(widget.id.toString()).onChildChanged.listen((data) {
      //  openFullscreen  , hideFullscreen


      print("listen");
      print(data.snapshot.children.toString());
      switch (data.snapshot.key.toString()) {
        case "index":
        // do something

          var rsp = data.snapshot.value.toString();
          print("currentttttt");
          print(currentIndex);
          setState(() {
            currentIndex=int.parse(rsp.toString());
          });
          break;
        case "url":
          var rsp = data.snapshot.value.toString();
          setState(() {
            url=rsp.toString();
          });
          break;
        case "videoType":
          var rsp = data.snapshot.value.toString();
          setState(() {
            videoType=rsp.toString();
          });
          break;

        case "private":
          var rsp = data.snapshot.value.toString();
          setState(() {
            private=rsp.toString();
          });
          break;
      // case "time":
      //   var rsp = data.snapshot.value.toString();
      //   setState(() {
      //     adminTime=int.parse(rsp.toString());
      //   });
      //   break;

        case "gmt":
          var rsp = data.snapshot.value.toString();
          setState(() {
            gmTime=int.parse(rsp.toString());
          });
          break;
        case "intialStart":
          var rsp = data.snapshot.value.toString();
          setState(() {
            intialStart=rsp.toString();
          });
          break;

        case "exit":
          var rsp = data.snapshot.value.toString();
          if(rsp=="true"){
            Navigator.pop(context);
          }
          break;


        case "chat":
          var rsp = data.snapshot.value;



          //   _scrollDown();
          setState(() {

            //chatList=rsp;

            if((videoFulscreen==true&&chatAlert==true)||(playlistTap==true&&chatAlert==true)
            // || (chatAlert==true&&chatFullScreen==false)
            ){

              ///play notification
              if(rsp.toString().split("||").last!=auth.currentUser!.uid){
                FlutterRingtonePlayer.playNotification();
                Vibrate.vibrate();
                Noti.showBigTextNotification(title: "New Message", body: rsp.toString().split("||").first.toString(), fln: flutterLocalNotificationsPlugin);

              }

            }
          });
          //  _scrollDown();

          // if(listEnd==true){
          // }
          ///write code here
          print("chatList");
          print(chatList);
          break;
        case "controller":
          var rsp = data.snapshot.value.toString();
          print("controller");
          print(rsp);
          print("controller");

          setState(() {
            controller=rsp;
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
                FlutterRingtonePlayer.playNotification();

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


      }


    });


  }
  void getIntialData(){


    databaseReference.child('channel').child(widget.id.toString()).once().then(( snapshot) async {


      var  time = snapshot.snapshot.child('time').value;
      var  gmt = snapshot.snapshot.child('gmt').value;
      adminTime= int.parse(time.toString());
      videoType= snapshot.snapshot.child('videoType').value;

      path=snapshot.snapshot.child('playlist').value;
      private=snapshot.snapshot.child('private').value;
      gmTime =int.parse(gmt.toString());
      controller=snapshot.snapshot.child('controller').value;
      playing=snapshot.snapshot.child('playing').value;
      adminId=snapshot.snapshot.child('adminId').value;
      url=snapshot.snapshot.child('url').value;
      currentIndex=snapshot.snapshot.child('index').value;
      name=snapshot.snapshot.child('name').value;
      exit=snapshot.snapshot.child('exit').value;
      intialStart=snapshot.snapshot.child('intialStart').value.toString();

      print("time1");
      print(controller);

      if(controller=="play"){
        setState(() {
          _autoPlay=true;
          playlingStatus="play";

        });
      }



    }).whenComplete((){
      getPlayList(path);
    });
  }
  void getPlayList(_path){
    databaseReference.child(_path).once().then(( snapshot) async {
      var data = snapshot.snapshot.value;
      print("playList");
      print(data);
      playList=data;



    }).whenComplete((){

      if(widget.type.toString()=="CREATE"){
        updateUrl(0);

      }else{
        getCurrentTime();
        videoInitilize();

      }

      //  setUpChannel("playList[0][0]['fileUrl']");
    });
  }

  void updateUrl(index)async{

    var _url = await getSong(playList[index]['fileUrl'].toString(),playList[index]['fileType'].toString());


    databaseReference.child('channel').child(widget.id).update({
      'url': _url,
      'index': index.toString(),
    }).whenComplete((){
      setState(() {
        url=_url;
        currentIndex=index;
      });
      videoInitilize();
    });

  }

  void playNext(index,ctx)async{


    var _url = await getSong(playList[index]['fileUrl'].toString(),playList[index]['fileType'].toString());
    databaseReference.child('channel').child(widget.id).update({
      'url': _url,


    }).whenComplete((){
      databaseReference.child('channel').child(widget.id).update({

        'index': index.toString(),

      }).whenComplete(()async{

        databaseReference.child('channel').child(widget.id).update({

          'controller': "next".toString(),
          'time': "000000",
          'gmt': await gmtCurrentTime(),
        }).whenComplete((){

          setState(() {
            print("nexttt");
            print("nexttt1");
            _autoPlay=true;
            url=_url;
            currentIndex=index;
            _betterPlayerController.dispose();
            // _betterPlayerController. pause();
            videoInitilize();

          });

        });

      });


    });


    // if(playList.length==1&&index!=0){
    //
    //   print("relodd");
    //   //+(bufferTime)
    //   _betterPlayerController.seekTo(Duration(milliseconds: 0000)).whenComplete(() {
    //     setState(() {
    //       if(playlingStatus=="play"){
    //         _betterPlayerController. videoPlayerController?.play();
    //       }
    //
    //
    //
    //     });
    //
    //   });
    // }else{
    //
    //
    //
    // }


  }
  void videoInitilize(){



    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: _autoPlay,

        controlsConfiguration:BetterPlayerControlsConfiguration(enableOverflowMenu: false,enableFullscreen: false,enableMute: false,)

    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network, url,

    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.addEventsListener(_handleEvent);

    setState(() {
      loading=false;
      itemLoading=false;
      _autoPlay=false;
    });


  }

  void updateTime(time){



    if(_betterPlayerController.videoPlayerController!.value.isPlaying==true){


// Here you can write your code
      print("timee");
      print(time);
      databaseReference.child('time').child(widget.id).update({
        'time': time.toString(),
      });




    }


    if(controller=="play"){
      if(_betterPlayerController.videoPlayerController!.value.isPlaying==false){
        setControls("pause");
      }
    }




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
      }else{

        print("live-------");
        print("alaaa");
        if(fetchTimeBg==true){
          print("ulinn edknd");

          databaseReference.child('time').child(widget.id).once().then(( snapshot) async {
            var rsp = snapshot.snapshot.child('time').value;
            setState(() {
              adminTime=int.parse(rsp.toString());
              fetchTimeBg=false;
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
    databaseReference.child('time').child(widget.id).once().then(( snapshot) async {
      var rsp = snapshot.snapshot.child('time').value;
      setState(() {
        adminTime=int.parse(rsp.toString());
      });
    });
  }

  void getControl(control){

    if(widget.type=="JOIN"){
      if(control=="play"){
        print("cpntroool play cheyyyy");
        setState(() {
          playlingStatus ="play";
          _betterPlayerController.play();
        });
        getCurrentTime();
      }
      if(control=="pause"){
        setState(() {
          playlingStatus ="pause";
          _betterPlayerController. videoPlayerController?.pause();
        });
        getCurrentTime();
      }
      if(control=="next"){
        _betterPlayerController. videoPlayerController?.dispose();
        videoInitilize();
        getCurrentTime();
      }
      if(control=="seekTo"){
        print("pphaaaaaaaaaa");
        // _betterPlayerController. videoPlayerController?.dispose();
        // videoInitilize();
        Future.delayed(const Duration(seconds: 1), () {

// Here you can write your code

          goLive();

        });

        // goLive();
      }
    }
  }

  void setControls(event)async{
    print("eventttt");
    print(event);



    if(controlJoined==false){

      return;
    }
    if(event=="seekTo"){
      print("seekaney");
      print(_betterPlayerController.isPlaying());


      databaseReference.child('channel').child(widget.id).update({
        'controller': event.toString(),
        'time': _betterPlayerController.videoPlayerController?.value.position.inMilliseconds.toString(),
        'gmt': await gmtCurrentTime(),


      });
      databaseReference.child('channel').child(widget.id).update({
        'controller': _betterPlayerController.isPlaying()==true?"play":"pause",
        'time': yourTime.toString(),
        'gmt': await gmtCurrentTime(),

      });

    }
    if(event=="play"){

      databaseReference.child('channel').child(widget.id).update({
        'controller':_betterPlayerController.isPlaying()==true?"play":"pause",
        'time': yourTime.toString(),
        'gmt': await gmtCurrentTime(),

      });

      // setState(() {
      //   playlingStatus ="play";
      // });
    }
    if(event=="pause"){
      databaseReference.child('channel').child(widget.id).update({
        'controller': _betterPlayerController.isPlaying()==true?"play":"pause",
        'time': yourTime.toString(),
        'gmt': await gmtCurrentTime(),

      });
      // setState(() {
      //   playlingStatus ="pause";
      // });
    }



    if(controller=="exit"){
      // databaseReference.child('channel').child(widget.id).update({
      //   'controller': event.toString(),
      // });

      Navigator.pop(context);
    }
    //    ,

    if(event=="openFullscreen"){
      // databaseReference.child('channel').child(widget.id).update({
      //   'controller': event.toString(),
      // });
      setState(() {
        videoFulscreen=true;
      });
    }
    if(event=="hideFullscreen"){
      // databaseReference.child('channel').child(widget.id).update({
      //   'controller': event.toString(),
      // });

      setState(() {
        videoFulscreen=false;
      });
    }




  }

  void goLive()async{

    print("adminnnn");
    print(adminTime);

    _betterPlayerController. videoPlayerController?.pause();
    var liv= await   getCurrentTime();
    //+(bufferTime)
    //  _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(adminTime.toString())))).whenComplete(() {
    _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(adminTime.toString()))+500)).whenComplete(() {
      setState(() {
        if(playlingStatus=="play"){
          _betterPlayerController. videoPlayerController?.play();
        }
        //  Stopwatch stopwatch =  Stopwatch()..start();
        //
        //  stopwatch.stop();
        // bufferTime=stopwatch.elapsed.inMilliseconds;
        // print('doSomething() executed in ${}');
        // stopwatch.reset();

      });

    });




    // _betterPlayerController.play();
    // _betterPlayerController.play();

  }


  void autoPlay(current){

    if(current==_betterPlayerController.videoPlayerController?.value.duration?.inMilliseconds&&_autoPlay==false){
      print("autoooo");
      print(_autoPlay);

      if((int.parse(currentIndex.toString())+1)!=playList.length){
        setState(() {
          _autoPlay=true;
        });
        playNext(int.parse(currentIndex.toString())+1,context);



      }



    }
  }
  @override
  void dispose() {
    setState(() {
      timer.cancel();
      _stopWatchTimer.onResetTimer();
      _stopWatchTimer.onStopTimer();
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _eventStreamController.close();
    _betterPlayerController.removeEventsListener(_handleEvent);
    Wakelock.disable();
    showInterstitialAd();

    _eventStreamController.close();
    _betterPlayerController.removeEventsListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent(BetterPlayerEvent event) {

    var current =_betterPlayerController.videoPlayerController?.value.position.inMilliseconds;
    setState(() {
      yourTime = current!;
    });

    if(widget.type.toString()=="CREATE"){

      updateTime(_betterPlayerController.videoPlayerController?.value.position.inMilliseconds);
      setControls(event.betterPlayerEventType.name.toString());

      if(autoPlayToggle==true){
        autoPlay(current);

      }


    }




    // if(current!<=yourTime){
    //  // _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(time.toString()))));
    // }
    if(event.betterPlayerEventType.name=="bufferingStart"||event.betterPlayerEventType.name=="bufferingUpdate"||event.betterPlayerEventType.name=="bufferingEnd"){
      print("eventttttttt");

      print(event.betterPlayerEventType.name);
    }


    // event.betterPlayerEventType == BetterPlayerEventType.progress &&
    //     event.parameters != null &&
    //     event.parameters!['progress'] != null &&
    //     event.parameters!['duration'] != null;
    // events.insert(0, event);
    // print(event.betterPlayerEventType.name);
    // print( _betterPlayerController.videoPlayerController?.value.position);
    //
    // ///Used to refresh only list of events
    // _eventStreamController.add(DateTime.now());


  }

  PopupMenuItem _buildPopupMenuItem(String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child:  Row(
        children: [

          Text(title),
          Spacer(flex: 5,),
          Icon(iconData, color: Colors.black,size: 20,),
        ],
      ),
    );
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,


      child: Scaffold(
        backgroundColor: (videoFulscreen==true)?Colors.black:Color(0xff1e1e1e),
        //bottomNavigationBar: BannerAds(),
        endDrawer: VideoDrawerWidget(type: widget.type,id: widget.id,uid: auth.currentUser!.uid,controller: navigationListner,private: private,disableComment:chatAlert,disableJoinAlert:joinAlert,disableAdminControls:creatorControl,controlJoins:controlJoined,chatPopup: chatPopup,chatSound: chatSound,chatVibrate: chatVibrate,context: context,),
        appBar:  (videoFulscreen==true)?PreferredSize(
            preferredSize: Size.fromHeight(0.0), child: AppBar()):AppBar(
          key: _scaffoldKey,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                _onBackPressed();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18,
              )),
          centerTitle: false,
          title: GestureDetector(
            onTap: (){
              // gmtDiffrenceTime(yourTime);
              friendBottomInvite( context,widget.id);
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("#" +widget.id.toString(), style: size14_500W),
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
                  color: const Color(0xff333333)),
            ),
          ),
          actions: [

            // IconButton(
            //     onPressed: () {
            //       // requestBottomSheet();
            //       goLive();
            //     },
            //     icon: const Icon(
            //       Icons.live_tv,
            //     )),



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
            IconButton(
                onPressed: () {
                  // requestBottomSheet();

                  if(playlistTap==true){
                    //_betterPlayerController.disablePictureInPicture();
                    setState(() {
                      playlistTap=false;
                    });
                  }else{
                    //  _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
                    //chatBottomSheet(width);
                    setState(() {
                      playlistTap=true;
                    });
                  }

                  // readData();
                },
                icon:  Icon(
                  playlistTap==false? Icons.menu:CupertinoIcons.bubble_left_bubble_right ,  size:  playlistTap==false?22:22,
                )),

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



            // PopupMenuButton(
            //   onSelected: (value) {
            //     // _onMenuItemSelected(value as int);
            //     print("value");
            //     print(value);
            //     if(value==0){
            //
            //     }else{
            //
            //     }
            //   },
            //   itemBuilder: (ctx) => [
            //     _buildPopupMenuItem(' Disable Admin\n Controls', Icons.settings, 0),
            //     _buildPopupMenuItem(' Leave Session', Icons.login, 1),
            //     // _buildPopupMenuItem('Copy', Icons.copy, 2),
            //     // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
            //   ],
            // ),
          ],
        ),



        body:loading==true?Loading(): seesionJoins==true?SessionScreen(path: widget.id,):Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [

              //  h(1),
              intialStart=='false'?Container(     color: Colors.black,child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Center(  child:  widget.type=="JOIN"?Container(child: Text("Creator havent start the stream!",style: TextStyle(color: Colors.white,fontSize: 10),),):GestureDetector(onTap: (){

                  setState(() {
                    intialStart="true";
                  });

                  _betterPlayerController.play();
                  databaseReference.child('channel').child(widget.id).update({
                    'intialStart': true.toString(),
                  });
                },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,

                        height: 40,
                        width: 180,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30), color: themeClr),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Start", style: size12_200W),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Before starting the session make sure everyone has joined !",style: TextStyle(color: Colors.white,fontSize: 10),)
                    ],
                  ),
                ) ,),
              ),):Stack(

                children: [
                  // Container(
                  //   color: Colors.grey,
                  //
                  //   child:  BetterPlayer(controller: _betterPlayerController),
                  // ),

                  Container(
                    height:  videoFulscreen==false?(height/4):(height-5),
                    width: width,
                    //  aspectRatio: videoFulscreen==false ?16 / 9:16 / 7.5,
                    // aspectRatio: _betterPlayerController.videoPlayerController?.value.aspectRatio,
                    // aspectRatio:  _betterPlayerController.videoPlayerController?.value.initialized==true?videoAspectRatitio:14 / 9,


                    child:  Align(child: BetterPlayer(controller: _betterPlayerController),alignment:Alignment.bottomCenter ,),
                  ),

                  ///
                  ///
                  // videoFulscreen==true?AspectRatio(
                  //
                  //   aspectRatio: videoFulscreen==false ?16 / 9:16 / 7.8,
                  //   // aspectRatio: _betterPlayerController.videoPlayerController?.value.aspectRatio,
                  //   // aspectRatio:  _betterPlayerController.videoPlayerController?.value.initialized==true?videoAspectRatitio:14 / 9,
                  //
                  //
                  //   child:   Stack(
                  //     children: <Widget>[
                  //       Positioned(
                  //           bottom: 0.0,
                  //           right: 0.0,
                  //           left: 0.0,
                  //           top: 15.0,
                  //           child:   Align(
                  //             child: Container(
                  //
                  //               alignment: Alignment.bottomCenter,
                  //               //    color: Colors.black54,
                  //               child:Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   BannerAds(),
                  //                   w(2),
                  //                   BannerAds(),
                  //                 ],
                  //               ),
                  //             ),
                  //             alignment: Alignment.bottomCenter,
                  //           ),
                  //       ),
                  //     ],
                  //   ),
                  // ):Container(),
                  videoFulscreen == true?Align(
                    child:Container(

                      alignment: Alignment.bottomCenter,
                      //    color: Colors.black54,
                      child: BannerAdsVidStr(),
                    ),
                    alignment: Alignment.bottomCenter,
                  ):Container(),
                  ///-> banner
                  ///
                  Align(
                    child:Container(

                      alignment: Alignment.bottomLeft,
                      //    color: Colors.black54,
                      child:  Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.symmetric(
                                vertical: 1, horizontal: 1),
                            child:               IconButton(
                                onPressed: () {
                                  if (videoFulscreen == true) {

                                    setState(() {
                                      videoFulscreen=false;
                                    });
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.landscapeRight,
                                      DeviceOrientation.landscapeLeft,
                                      DeviceOrientation.portraitUp,
                                      DeviceOrientation.portraitDown,
                                    ]);
                                    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

                                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                                  } else {
                                    setState(() {
                                      videoFulscreen=true;
                                    });
                                    SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.landscapeRight,
                                      DeviceOrientation.landscapeLeft,
                                    ]);

                                    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
                                    //   SystemUiOverlay.bottom
                                    // ]);

                                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
                                  }
                                },
                                icon: Icon(videoFulscreen == true?CupertinoIcons.fullscreen_exit:CupertinoIcons.fullscreen,
                                    size: 20,
                                    color:
                                    Colors.white)),
                          ),
                          // Padding(
                          //   padding:  EdgeInsets.symmetric(
                          //       vertical: 1, horizontal: 1),
                          //   child:               IconButton(
                          //       onPressed: () {
                          //
                          //       },
                          //       icon: Icon(CupertinoIcons.zoom_in,
                          //           size: 20,
                          //           color:
                          //           Colors.white)),
                          // ),
                        ],
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                  ),
                  ///
                  Align(
                    child: widget.type=="JOIN"?Container(
                      alignment: Alignment.bottomLeft,
                      //    color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                goLive();
                              },
                              child:Container(
                                alignment: Alignment.center,
                                height: 20,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10), color: (yourTime<(adminTime-3000) ||yourTime>(adminTime+2000))?Colors.orange:red),
                                child:  Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text((yourTime<(adminTime-3000) ||yourTime>(adminTime+2000))?"Go Live":"Live", style: size12_600W),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ):Container(

                      alignment: Alignment.bottomLeft,
                      //    color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Switch(
                              value: autoPlayToggle,
                              activeColor: Colors.white,
                              inactiveThumbColor: Colors.white,
                              onChanged: (bool value1) {
                                setState(() {
                                  autoPlayToggle= value1;
                                  if(autoPlayToggle==true){
                                    showToastSuccess("Auto play enabled");
                                  }else{
                                    showToastSuccess("Auto play disabled");
                                  }
                                });
                              },
                            )

                          ],
                        ),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                  ),
                ],
              ),
              (videoFulscreen==true)?Container(): BannerAdsVidStr(),
              (videoFulscreen==true)?Container():  (  playlistTap==true?div():


              Row(


                children: [


                  SizedBox(
                    height: 20,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            //   playlistTap=true;
                            chatFullScreen=true;
                          });
                          chatBottomSheet(width);
                          print("full scree");
                        },
                        icon:  Icon(
                          CupertinoIcons.fullscreen,
                          size: 20,
                          color: Colors.white,
                        )),
                  ),
                  Spacer()


                ],)),
              (videoFulscreen==true)?Container():  ( playlistTap==true? Expanded(
                child: Scrollbar(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),

                    shrinkWrap: true,
                    itemCount: playList != null ? playList.length : 0,
                    itemBuilder: (context, index) {
                      final item = playList != null ? playList[index] : null;

                      return videoList(item,index,context);
                    },
                  ),
                ),
              ):sessionChatList(code: widget.id,voiceNotePlayingListner: voiceNotePlayingListner)),

              (videoFulscreen==true)?Container(): ( playlistTap==true?Container():MessageBar(width: width,id: widget.id,videoController: _betterPlayerController,)),
              // playlistTap==true?Container():Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //             color: const Color(0xff333333),
              //             borderRadius: BorderRadius.circular(10)),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 20),
              //           child: TextFormField(
              //             controller: messageController,
              //             cursorColor: Colors.white,
              //             autofocus: false,
              //             style: size14_600W,
              //             decoration: const InputDecoration(
              //               border: InputBorder.none,
              //               hintStyle: size14_500Grey,
              //               hintText: "Type your message here",
              //               focusedBorder: InputBorder.none,
              //               enabledBorder: InputBorder.none,
              //               errorBorder: InputBorder.none,
              //               disabledBorder: InputBorder.none,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     w(9),
              //
              //     GestureDetector(
              //       onTap: ()async{
              //         print("lengthh");
              //         print(chatList);
              //       //  FocusManager.instance.primaryFocus?.unfocus();
              //
              //        sendMessageInSesssion(widget.id,messageController.text,"TEXT");
              //         setState(() {
              //
              //
              //           messageController.clear();
              //
              //         });
              //       },
              //       child: Container(
              //         alignment: Alignment.center,
              //         height: 40,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10), color: themeClr),
              //         child: const Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 20),
              //           child: Text("Send", style: size14_600W),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              //  VoiceNote(width: width,),
              h(3)
            ],
          ),
        ),
      ),
    );
  }
  chhat(var item,int index) {


    print("itemmmm");
    print(auth.currentUser!.uid);
    return item['type']=="VOICENOTE"?Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uId']?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        h(10),
        Row(
          mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [

            Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
            w(8),
            Text(" • " + item['time'].toString(), style: size10_400grey)
          ],
        ),
        h(10),

        Row(
          mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            auth.currentUser!.uid!=item['uId'] ? CircleAvatar(
              radius: 12,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:  Container(
                      height: 15,
                      color: Colors.black,
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 15,

                    ),
                  ),


                ],
              ),
            ) :Container(),
            w(5),
            playVoiceNote2(item:item,uid: auth.currentUser!.uid,index: index,voiceNotePlayingListner:voiceNotePlayingListner),
            w(5),
            auth.currentUser!.uid==item['uId'] ?  CircleAvatar(
              radius: 12,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:  Container(
                      height: 15,
                      color: Colors.black,
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 15,

                    ),
                  ),


                ],
              ),
            ):Container(),



          ],
        ),
      ],
    ): Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uId'].toString()?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        h(10),
        Row(
          mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [

            Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
            w(8),
            Text(" • " + item['time'].toString(), style: size10_400grey)
          ],
        ),
        // Row(
        //   crossAxisAlignment: auth.currentUser!.uid==item['uId'].toString()?CrossAxisAlignment.end:CrossAxisAlignment.start,
        //
        //   mainAxisAlignment: auth.currentUser!.uid==item['uId'].toString()?MainAxisAlignment.end:MainAxisAlignment.start,
        //
        //   children: [
        //
        //
        //     Row(
        //       mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
        //       //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
        //       children: [
        //
        //         Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
        //         w(8),
        //         Text(" • " + item['time'].toString(), style: size10_400grey)
        //       ],
        //     ),
        //     // CircleAvatar(
        //     //   radius: 12,
        //     //   child: Stack(
        //     //     clipBehavior: Clip.none,
        //     //     fit: StackFit.expand,
        //     //     children: [
        //     //       ClipOval(
        //     //         child:  Container(
        //     //           height: 23,
        //     //           color: Colors.black,
        //     //           child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
        //     //           width: 23,
        //     //
        //     //         ),
        //     //       ),
        //     //
        //     //
        //     //     ],
        //     //   ),
        //     // ),
        //     // w(10),
        //     // Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size14_600W),
        //     // w(8),
        //     // Text("• " + item['time'].toString(), style: size12_400grey)
        //   ],
        // ),

        h(10),

        Row(
          mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [

            auth.currentUser!.uid!=item['uId'] ? CircleAvatar(
              radius: 12,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:  Container(
                      height: 15,
                      color: Colors.black,
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 15,

                    ),
                  ),


                ],
              ),
            ) :Container(),
            item['message'].toString().length>12? Expanded(
              child: Container(
                margin:  EdgeInsets.only(right: 5,left: 5),
                child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                  child: Text(item['message'].toString(), style:auth.currentUser!.uid!=item['uId']?size14_500B: size14_500W),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft:
                      auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                      bottomRight:
                      auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),



                    color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
              ),
            ):Container(
              margin:  EdgeInsets.only(right: 5,left: 5),
              child:  Padding(
                padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                child: Text(item['message'].toString(), style:auth.currentUser!.uid!=item['uId']?size14_500B: size14_500W),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft:
                    auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                    bottomRight:
                    auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),



                  color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
            ),
            auth.currentUser!.uid==item['uId'] ?  CircleAvatar(
              radius: 12,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  ClipOval(
                    child:  Container(
                      height: 15,
                      color: Colors.black,
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 15,

                    ),
                  ),


                ],
              ),
            ):Container(),





          ],
        ),


      ],
    );
  }
  div() {
    return const Divider(color: Color(0xff404040), thickness: 1);
  }

  chat(var item,int index) {


    print("item");
    print(item);
    return item['type']=="VOICENOTE"?Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uId']?CrossAxisAlignment.start:CrossAxisAlignment.end,
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
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 30,

                    ),
                  ),


                ],
              ),
            ),
            w(10),
            Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size14_600W),
            w(8),
            Text(" • " + item['time'].toString(), style: size12_400grey)
          ],
        ),
        h(10),

        playVoiceNote(item:item),
      ],
    ):Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uId']?CrossAxisAlignment.end:CrossAxisAlignment.start,
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
                      child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                      width: 30,

                    ),
                  ),


                ],
              ),
            ),
            w(10),
            Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size14_600W),
            w(8),
            Text(" • " + item['time'].toString(), style: size12_400grey)
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
              borderRadius: BorderRadius.circular(23), color: auth.currentUser!.uid==item['uId']?Colors.grey[100]:blueClr),
        )
      ],
    );
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
                BannerAdsVidStr()
                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //         height: 40,
                //         decoration: BoxDecoration(
                //             color: const Color(0xff333333),
                //             borderRadius: BorderRadius.circular(10)),
                //         child: Padding(
                //           padding:
                //           const EdgeInsets.symmetric(horizontal: 20),
                //           child: TextFormField(
                //             cursorColor: Colors.white,
                //             autofocus: false,
                //             style: size14_600W,
                //             decoration: const InputDecoration(
                //               border: InputBorder.none,
                //               hintStyle: size14_500Grey,
                //               hintText: "Type your message here",
                //               focusedBorder: InputBorder.none,
                //               enabledBorder: InputBorder.none,
                //               errorBorder: InputBorder.none,
                //               disabledBorder: InputBorder.none,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //     w(9),
                //     Container(
                //       alignment: Alignment.center,
                //       height: 40,
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10),
                //           color: themeClr),
                //       child: const Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 20),
                //         child: Text("Send", style: size14_600W),
                //       ),
                //     )
                //   ],
                // ),
                // Padding(
                //   padding: EdgeInsets.only(
                //       bottom: MediaQuery.of(context).viewInsets.bottom,
                //       top: 10),
                // ),
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
    return  Text(txt, style: size14_600G);
  }

  Widget rejected(txt) {
    return  Text(txt, style: size14_600Red);
  }



  videoList(var item,int index,ctx) {
    return GestureDetector(
      onTap: _betterPlayerController.videoPlayerController!.value.initialized==false?null:(){

        if(widget.type=="CREATE"&&intialStart=='false'){

          showToastSuccess("Session not yet started!");
          return;
        }

        if(widget.type=="CREATE"&&itemLoading==false){

          // updateUrl(index);

          setState(() {
            _betterPlayerController.pause();
            currentIndex=index;
            itemLoading=true;
          });
          setControls("next");
          playNext(index,ctx);
        }
      },
      child: Container(
        color: currentIndex==index?grey:Color(0xff1e1e1e),
        child: Row(
          children: [
            Stack(
              children: [
                Container(

                  height: 69,
                  child:(item['fileType']=="VIDEO")? Image.memory( dataFromBase64String(item['fileThumb']),gaplessPlayback: true,):Image.network(item['fileThumb']),
                  width: 101,

                  decoration: BoxDecoration(

                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),

                  ),
                ),

                Align(
                  child:(currentIndex==index&&itemLoading==true) ?Container(
                      height: 69,
                      width: 101,
                      alignment: Alignment.center,
                      child: SpinKitRing(
                        color: themeClr,
                        size: 25,
                        lineWidth: 3,
                      )):Container(),
                  alignment: Alignment.center,
                )
              ],
            ),
            w(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['fileName'].toString(),
                      style: size14_500W,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  h(5),

                  //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
                ],
              ),
            ),
            w(10),

          ],
        ),
      ),
    );
  }
  shareBottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        isScrollControlled: true,
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
                        Text("Share", style: size14_600W),
                        Spacer(),
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
                h(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset("assets/svg/whatsapp-logo.svg"),
                    SvgPicture.asset("assets/svg/messenger-logo.svg"),
                    SvgPicture.asset("assets/svg/instagram-logo.svg"),
                    SvgPicture.asset("assets/svg/sms-logo.svg"),
                  ],
                ),
                h(10),
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

  emptyPlaylist() {
    var ss = MediaQuery.of(context).size;

    return Column(
      children: [
        h(ss.height * 0.3),
        const Text("You have not added any videos", style: size14_500Grey),
        h(ss.height * 0.03),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: themeClr),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("Add Video", style: size14_600W),
            ),
          ),
        ),
        h(ss.height * 0.3),
      ],
    );
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

  chatBottomSheet1() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        isScrollControlled: true,
        builder: (context) =>

            Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(

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

                            const Spacer(),
                            IconButton(
                                icon: const Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  color: Colors.black26,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff404040), thickness: 1),
                    sessionChatList(code: widget.id,voiceNotePlayingListner: voiceNotePlayingListner,),
                    h(5),
                    MessageBar(width: "width",id: widget.id,videoController: _betterPlayerController,)
                  ],
                ),
              ),
            ])

    );
  }

  chatBottomSheet(width) {
    Future<void> future = showModalBottomSheet(
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
                          margin: EdgeInsets.only(top: 30),
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

                                const Spacer(),
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
                        const Divider(color: Color(0xff404040), thickness: 1),
                        sessionChatList(code: widget.id,voiceNotePlayingListner: voiceNotePlayingListner,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MessageBar(width: width,id: widget.id,videoController: _betterPlayerController,),
                        )
                      ],
                    ),
                  ),
                ]);
              });
        });

    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {


    setState(() {
      chatFullScreen=false;
      playlistTap=false;
    });

  }
}
