import 'dart:convert';
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
import '../../Helper/cofirmExitAlert.dart';

import 'package:flutter/material.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/checkUrl.dart';
import 'package:weei/Helper/friendBottomInvite.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/roomExitBox.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/BannerAdsVid.dart';
import 'package:weei/Screens/Main_Screens/Chat/addLocalForSession.dart';
import 'package:weei/Screens/Main_Screens/Chat/addYTForSession.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';
import 'package:weei/Screens/Session/Session_Screen.dart';
import 'package:weei/Screens/VideoSession/Data/acceptOrDeclne.dart';
import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';
import 'package:weei/Screens/VideoSession/VideoCrontrolDrawer.dart';
import 'package:weei/Testing/constants.dart';

import 'Data/sendMessageInSession.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoPlayerLocal extends StatefulWidget {

  final id;
  final path;
  final type;
  final data;
  final index;




  final playingType;
  final isPlaylist;
  final url;

  VideoPlayerLocal({this.id,this.path,this.type,this.data,this.index, this.playingType,this.isPlaylist,this.url  }) ;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerLocal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Query _ref;
  late Query _chat;
  var totalJoined =0;
  var selectedShare =0;
  var yourTime= 00000;
  final databaseReference = FirebaseDatabase.instance.reference();
  GlobalKey<FormState> _abcKey = GlobalKey<FormState>();
  late BetterPlayerController _betterPlayerController;
  List<BetterPlayerEvent> events = [];
  StreamController<DateTime> _eventStreamController = StreamController.broadcast();
  var loading=true;
  var listEnd=true;
  var intialStart="true";
  var playlistTap=true;
  var playlingStatus="pause";
  var _autoPlay=true;
  var autoPlayToggle=true;
  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  var private;

  // Stopwatch stopwatch =  Stopwatch()..start();
  var adminTime= 00000;
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
  bool itemLoading =true;
  bool joinAlert =true;
  bool creatorControl =true;
  bool controlJoined =true;

  ///for cht noti

  bool videoFulscreen =false;
  bool chatAlert =true;




  var navigationListner = TextEditingController();
  var videoAspectRatitio;
  @override
  void initState() {
    // navigationListner.addListener((){
    //   //here you have the changes of your textfield
    //   print("value: ${navigationListner.text}");
    //   //use setState to rebuild the widget
    //
    //   navigationControls(navigationListner.text);
    //
    // });
    print("widget.id");
    print(widget.id);



   getPlayList(widget.path);
    // this.listenDataFromFireBase();
    // this.listenExit();
    //
    // _ref = FirebaseDatabase.instance
    //     .reference()
    //     .child('channel').child(widget.id.toString()+"/joins");
    // _chat = FirebaseDatabase.instance
    //     .reference()
    //     .child('channel').child(widget.id.toString()+"/chat");

   // _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    _eventStreamController.close();
    _betterPlayerController.removeEventsListener(_handleEvent);

    super.dispose();
  }

  void getPlayList(_path)async{
      print("widget.data");
      print(widget.data);
        if(_path==null){
            setState(() {
              playList=widget.data;
            });

            updateUrl(widget.index!=null?widget.index:0);

        }else{
    databaseReference.child(_path).once().then(( snapshot) async {
            var data = snapshot.snapshot.value;
             setState(() {
               playList=data;

             });



          }).whenComplete((){


      updateUrl(widget.index!=null?widget.index:0);



           //  setUpChannel("playList[0][0]['fileUrl']");
         });
        }

  }

  void updateUrl(index)async{
    var _url = await getSong(playList[index]['fileUrl'].toString(),playList[index]['fileType'].toString());


    setState(() {
      url=_url;
      currentIndex=index;
    });
    videoInitilize();

  }

  void playNext(index,ctx)async{


    var _url = await getSong(playList[index]['fileUrl'].toString(),playList[index]['fileType'].toString());

    setState(() {
      _autoPlay=true;
      url=_url;
      currentIndex=index;
      _betterPlayerController.dispose();

   //   _betterPlayerController. pause();
      videoInitilize();

    });


  }
  void videoInitilize(){
    setState(() {
      itemLoading=true;
      print("itemLoading");
      print(itemLoading);
    });
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: _autoPlay,

        controlsConfiguration:BetterPlayerControlsConfiguration(enableOverflowMenu: false,enableFullscreen: false)

    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network, url,

    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.addEventsListener(_handleEvent);
    // _betterPlayerController.pause();
   // _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);

    setState(() {
      loading=false;
    //  videoAspectRatitio =_betterPlayerController.videoPlayerController?.value.aspectRatio;
      itemLoading=false;
      _autoPlay=false;
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
      }
      if(control=="pause"){
        setState(() {
           playlingStatus ="pause";
          _betterPlayerController. videoPlayerController?.pause();
        });

      }
      if(control=="next"){
        _betterPlayerController. videoPlayerController?.dispose();
        videoInitilize();
      }
      if(control=="seekTo"){
        print("pphaaaaaaaaaa");
        // _betterPlayerController. videoPlayerController?.dispose();
        // videoInitilize();
        goLive();
      }
    }
  }

  void setControls(event){
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
      });
      databaseReference.child('channel').child(widget.id).update({
        'controller': _betterPlayerController.isPlaying()==true?"play":"pause",
      });

    }
    if(event=="play"){

      databaseReference.child('channel').child(widget.id).update({
        'controller':_betterPlayerController.isPlaying()==true?"play":"pause",
      });

      // setState(() {
      //   playlingStatus ="play";
      // });
    }
    if(event=="pause"){
      databaseReference.child('channel').child(widget.id).update({
        'controller': _betterPlayerController.isPlaying()==true?"play":"pause",
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

  void goLive(){

          print("adminnnn");
          print(adminTime);

        _betterPlayerController. videoPlayerController?.pause();
      //+(bufferTime)
        _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(adminTime.toString())))).whenComplete(() {
        setState(() {
          if(playlingStatus=="play"){
            _betterPlayerController. videoPlayerController?.play();
          }

          // stopwatch.stop();
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

  void _handleEvent(BetterPlayerEvent event) {
    var current =_betterPlayerController.videoPlayerController?.value.position.inMilliseconds;
    setState(() {
      yourTime = current!;
    });

    if(widget.type.toString()=="CREATE"){

      // updateTime(_betterPlayerController.videoPlayerController?.value.position.inMilliseconds);
      // setControls(event.betterPlayerEventType.name.toString());

      if(autoPlayToggle==true){
        autoPlay(current);

      }


    }
    print("finshhh");
    print(_betterPlayerController.videoPlayerController?.value.duration?.inMilliseconds);
    print(current);



   // if(current!<=yourTime){
   //  // _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(time.toString()))));
   // }
    print("eventttttttt");
    print(event.betterPlayerEventType.name);
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

    exitSheet();
    // if(widget.type=="JOIN"){
    //   roomExitJoinAlert( context,widget.id,uid);
    // }else{
    //   roomExitAlert(context,widget.id,uid);
    //
    // }

    Navigator.pop(context);
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
      bottomNavigationBar: (videoFulscreen==true)?SizedBox(height: 0.1,):BannerAdsVid(),
  //    bottomNavigationBar: BannerAds(),
      //  endDrawer: VideoDrawerWidget(type: widget.type,id: widget.id,uid: auth.currentUser!.uid,controller: navigationListner,private: private,disableComment:chatAlert,disableJoinAlert:joinAlert,disableAdminControls:creatorControl,controlJoins:controlJoined,),
        appBar:   (videoFulscreen==true)?PreferredSize(
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
              // shareSheet();
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Expanded(child: Text(loading==false?playList[currentIndex]['fileName']:"", style: size14_500W)),
                    // w(5),
                    // const CircleAvatar(
                    //   backgroundColor: grey,
                    //   child: Icon(Icons.share, size: 10),
                    //   radius: 10,
                    // )
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

           //
           // IconButton(
           //      onPressed: () {
           //
           //        // if(seesionJoins==true){
           //        //   setState(() {
           //        //     seesionJoins=false;
           //        //   });
           //        // }else{
           //        //   setState(() {
           //        //     seesionJoins=true;
           //        //   });
           //        // }
           //
           //
           //       joinBottomSheet();
           //      },
           //      icon: const Icon(CupertinoIcons.person_3, color: Colors.white)),
           //  IconButton(
           //      onPressed: () {
           //     // requestBottomSheet();
           //
           //        if(playlistTap==true){
           //          setState(() {
           //            playlistTap=false;
           //          });
           //        }else{
           //          setState(() {
           //            playlistTap=true;
           //          });
           //        }
           //
           //       // readData();
           //      },
           //      icon:  Icon(
           //        playlistTap==false? Icons.menu:CupertinoIcons.bubble_left_bubble_right ,  size:  playlistTap==false?22:22,
           //      )),

            Builder(builder: (context) => // Ensure Scaffold is in context
            PopupMenuButton(
              onSelected: (value) {
                // _onMenuItemSelected(value as int);
                print("value");
                print(value);
                if(value==0){

                  _betterPlayerController.dispose();

                  if( widget.playingType=="YTVIDEO"){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addYTToSession(
                            type: widget.playingType,
                            private: true,
                            isPlaylist: widget.isPlaylist,
                            url: widget.url,
                          )),
                    );
                  }else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addLocalToSession(
                            type: widget.playingType,
                            private: true,
                            isPlaylist: widget.isPlaylist,
                            url: widget.url,
                            path:widget.path,
                            data: widget.data,
                          )),
                    );


                  }
                }else{
                  setState(() {

                  });
                }
              },
              itemBuilder: (ctx) => [
                _buildPopupMenuItem(' Open in room', Icons.arrow_forward, 0),

                // _buildPopupMenuItem('Copy', Icons.copy, 2),
                // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
              ],
            ),


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
            // crossAxisAlignment:   (videoFulscreen==true)?CrossAxisAlignment.center:CrossAxisAlignment.start,
            // mainAxisAlignment:  (videoFulscreen==true)?MainAxisAlignment.center: MainAxisAlignment.start,
            children: [

              Stack(

                children: [
                  // Container(
                  //   color: Colors.grey,
                  //
                  //   child:  BetterPlayer(controller: _betterPlayerController),
                  // ),

                  Container(

                    //aspectRatio: videoFulscreen==false ?16 / 9:16 / 7.5,
                     height:  videoFulscreen==false?(height/4):(height-5),
                      width: width,
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
                      child: BannerAdsVid(),
                    ),
                    alignment: Alignment.bottomCenter,
                  ):Container(),
                  ///-> banner
                  Align(
                    child:Container(

                      alignment: Alignment.bottomLeft,
                      //    color: Colors.black54,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
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

                                SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
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

                                SystemChrome.setEnabledSystemUIOverlays([]);
                              }
                            },
                            icon: Icon(videoFulscreen == true?CupertinoIcons.fullscreen_exit:CupertinoIcons.fullscreen,
                                size: 20,
                                color:
                                Colors.white)),
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


              (videoFulscreen==true)?Container():div(),

              playlistTap==true? (videoFulscreen==true)?Container():Expanded(
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
              ): (videoFulscreen==true)?Container():Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Scrollbar(
                    // child: ListView.separated(
                    //   scrollDirection: Axis.vertical,
                    //   separatorBuilder: (context, index) => h(10),
                    //   shrinkWrap: true,
                    //   itemCount: 50,
                    //   itemBuilder: (context, index) {
                    //     // final item = arrOrderDetail != null
                    //     //     ? arrOrderDetail[index]
                    //     //     : null;
                    //
                    //     return participantsList(index);
                    //   },
                    // ),
                    child: FirebaseAnimatedList(

                      query: _chat,
                      controller: _controller,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        // Object? contact = snapshot.value;
                        // contact['key'] = snapshot.key;
                        return chhat( snapshot.value,index);
                      },
                    ),
                  ),
                ),
              ),
              (videoFulscreen==true)?Container():h(5),
              playlistTap==true?Container(): (videoFulscreen==true)?Container():Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xff333333),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: messageController,
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
                  GestureDetector(
                    onTap: ()async{
                      print("lengthh");
                      print(chatList);
                    //  FocusManager.instance.primaryFocus?.unfocus();

                     // sendMessageInSesssion(widget.id,messageController.text,"TEXT");
                      setState(() {


                        messageController.clear();

                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: themeClr),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Send", style: size14_600W),
                      ),
                    ),
                  )
                ],
              ),
              (videoFulscreen==true)?Container(): h(10)
            ],
          ),
        ),
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
  div() {
    return const Divider(color: Color(0xff404040), thickness: 1);
  }

  chat(var item,int index) {


    print("item");
    print(item);
    return Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.end:CrossAxisAlignment.start,
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
                        const Text("Participants", style: size14_500W),
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
              Text(item['name'], style: size14_500W),
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
     //setControls("next");
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
                  child:(item['fileType']=="VIDEO")?Image.memory( dataFromBase64String(item['fileThumb']),gaplessPlayback: true,):Image.network(item['fileThumb'])   ,
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
                        color: Colors.white,
                        size: 25,
                        lineWidth: 2,
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
                            const Text("Share", style: size14_500W),
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
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: const [
                          Text('Share', style: size14_600W),
                          Spacer(),
                          Icon(CupertinoIcons.xmark_circle_fill,
                              color: grey, size: 25)
                        ],
                      ),
                      h(5),

                      Divider(
                        color: Color(0xff2F2E41),
                        thickness: 1,
                      ),
                      h(10),
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
                                child: Icon(Icons.add_to_photos_outlined,
                                    color: Colors.white),
                              ),
                              Text(selectedShare==0?"Share link":"Direct Share", style: size16_600W)
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

  exitSheet()async {

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
                        Text("Exiting?", style: size14_600W),
                        Spacer(),

                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),
                    Text("Do you really want to exit the media?", style: size14_500Grey),
                    h(25),
                    Row(
                      children: [
                        Expanded(
                          child: buttons("Exit", themeClr, ()async {

                            Navigator.pop(context);
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
                        SizedBox(width: 5,),
                        Expanded(
                          child: buttons("Cancel", grey, ()async {

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
