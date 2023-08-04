import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_share/flutter_share.dart';

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
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/BannerAdsMus.dart';
import 'package:weei/Screens/Admob/BannerAdsVid.dart';
import 'package:weei/Screens/Main_Screens/Chat/addLocalForSession.dart';
import 'package:weei/Screens/Main_Screens/Chat/addYTForSession.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';
import 'package:weei/Screens/MusicPlayer/localThumbnai.dart';
import 'package:weei/Screens/VideoSession/Data/acceptOrDeclne.dart';
import 'package:weei/Screens/VideoSession/Data/sendMessageInSession.dart';
import 'package:weei/Screens/VideoSession/VideoCrontrolDrawer.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Helper/Const.dart';
import '../../Helper/checkUrl.dart';
import 'package:weei/Screens/voicenote/duration.dart';



class audioPlayerLocal extends StatefulWidget {
  final id;
  final path;
  final type;
  final data;
  final index;




  final playingType;
  final isPlaylist;
  final url;

  audioPlayerLocal({this.id,this.path,this.type,this.data,this.index, this.playingType,this.isPlaylist,this.url  });

  @override
  _audioPlayerScreenState createState() => _audioPlayerScreenState();
}

class _audioPlayerScreenState extends State<audioPlayerLocal> {
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
  final _playlist = ConcatenatingAudioSource(children: []);

  // late BetterPlayerController _betterPlayerController;
  // List<BetterPlayerEvent> events = [];
  // StreamController<DateTime> _eventStreamController = StreamController.broadcast();
  var loading = true;
  var intialLoading = true;
  var listEnd = true;
  var playlistTap = false;
  var chatlistTap = false;
  var autoPlayToggle = true;

  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FirebaseAuth auth = FirebaseAuth.instance;

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
  var intialStart = "true";
  var selectedShare = 0;



  bool itemLoading =false;
  bool joinAlert =true;
  bool creatorControl =true;

  ///for cht noti

  bool videoFulscreen =false;
  bool chatAlert =true;

  bool controlJoined =true;

  late DateTime currentBackPressTime;

  var navigationListner = TextEditingController();
  var musicAddStarted = false;
  var musicAddCount = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {


    print("widget.id");
    print(widget.id);
    // navigationListner.addListener((){
    //   //here you have the changes of your textfield
    //   print("value: ${navigationListner.text}");
    //   //use setState to rebuild the widget
    //
    //   navigationControls(navigationListner.text);
    //
    // });
    getPlayList(widget.path);
    // this.listenDataFromFireBase();
    // this.listenExit();

    // _ref = FirebaseDatabase.instance
    //     .reference()
    //     .child('channel').child(widget.id.toString()+"/joins");
    // _chat = FirebaseDatabase.instance
    //     .reference()
    //     .child('channel')
    //     .child(widget.id.toString() + "/chat");
    //
    // // _controller.addListener(_scrollListener);
    // _ref = FirebaseDatabase.instance
    //     .reference()
    //     .child('channel')
    //     .child(widget.id.toString() + "/joins");
  //  listenError();
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
  void getPlayList(_path)async{

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
       musicAddStarted=true;
     });
    for (var i = 0; i < playList.length; i++) {
      var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());

      setState(() {
        musicAddCount = i;
      });
      _playlist.add( AudioSource.uri(
        Uri.parse(link),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id:i.toString(),
          // Metadata to display in the notification:
          album: "Weei Audio",
          title: playList[i]['fileName'].toString(),
          artUri: Uri.parse(playList[i]['fileThumb'].toString()),
        ),
      ));

    }

    setState(() {
      url = _url;
      currentIndex = index;
      name = playList[index]['fileName'].toString();
      thumbnail = playList[index]['fileThumb'].toString();
      musicAddStarted=false;
    });
    videoInitilizeAdmin(false);
    // videoInitilize();

  }












  void videoInitilizeAdmin(next) async {
    //final setup = await player.setUrl(url);

    print("plaaaaaay");
    print(url);
    // print(playList[index]['fileType']);
    final setup = await player.setAudioSource(
     _playlist,
    );


    // if (next == true) {
    //   _handleEvent("next");
    // }
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


      player.play();

      // _handleEvent("next");
      // _handleEvent("play");


      setState(() {
        loading = false;
        intialLoading = false;
      });
    }
  }

  void updateTime() {
    player.positionStream.listen((time) {
      setState(() {
        showLeftTime = time.inSeconds;
        position = time.inMilliseconds;
        yourTime = position;
        duration = player.duration!.inMilliseconds;
        showRightTime = player.duration!.inSeconds;
      });

      if (widget.type.toString() == "CREATE") {
        if (position >= duration) {
          autoPlay();
        }

        // databaseReference.child('channel').child(widget.id).update({
        //   'time': position.toString(),
        // });
      }
    });


  }

  void seekTo() {
    //
    player
        .seek(Duration(milliseconds: (int.parse(adminTime.toString()))))
        .whenComplete(() {
      print("liveeee");
      setState(() {});
    });

    // _betterPlayerController.play();
    // _betterPlayerController.play();
  }

  void next()  {
    // if(loading==true){
    //   return;
    // }
    if (widget.type == "CREATE") {
      // player.pause();
      //
      // setState(() {
      //   loading = true;
      // });

      if ((player.currentIndex! + 1) != playList.length) {
        //player.pause();


        // player.dispose();
        // updateUrl(index);

      //  playNext((currentIndex + 1), context);
        player.seekToNext().onError((error, stackTrace){


        });
        updateTime();
        // setControls("next");
        // return;
      } else {
        // print("nextttt");
        // print(autoPlayToggle);
        // setControls("next");
        // playNext(currentIndex, context);
        //  setControls("next");


        ///new
        if((player.currentIndex! + 1) == playList.length){
         // player.pause();
          // player.dispose();
          // updateUrl(index);
        //  playNext(0, context);
          player.seek(Duration(seconds: 0),index: 0).onError((error, stackTrace){


          });
          updateTime();
          ///new
        }else{
          ///old
          print("laaaaast");
          print(autoPlayToggle);
          //setControls("next");
        //  playNext(currentIndex, context);

          player.seek(Duration(seconds: 0),index: player.currentIndex).onError((error, stackTrace){


          });
          updateTime();
          //  setControls("next");
          ///old

        }
      }
    }

  }

  void autoPlay() {
    print("autoo");
   // player.seekToNext();

    if (widget.type == "CREATE") {


      if ((player.currentIndex! + 1) != playList.length && autoPlayToggle == true) {
        // player.pause();
        // // player.dispose();
        // // updateUrl(index);
        // playNext((currentIndex + 1), context);

        player.seekToNext();
        updateTime();


        // setControls("next");
        // setControls("next");

      } else {



        ///new
        if((player.currentIndex! + 1) == playList.length){
         // player.pause();
          // player.dispose();
          // updateUrl(index);
        //  playNext(0, context);

          player.seek(Duration(seconds: 0),index: 0);
          updateTime();
          ///new
        }else{
          ///old
          print("nextttt");
          print(autoPlayToggle);
          //setControls("next");
        //  playNext(currentIndex, context);
          //  setControls("next");
          ///old
          player.seek(Duration(seconds: 0),index: player.currentIndex);
          updateTime();
        }

      }
    }
  }

  void previos() {
    if (widget.type == "CREATE") {
      // player.pause();
      //
      // setState(() {
      //   loading = true;
      // });

      // if (currentIndex != 0) {
      //   player.pause();
      //   // player.dispose();
      //   // updateUrl(index);
      //   playNext((currentIndex - 1), context);
      //
      // }else{
      //   player.pause();
      //   // player.dispose();
      //   // updateUrl(index);
      //   playNext((playList.length - 1), context);
      //
      // }

      player.seekToPrevious();
      updateTime();
    }
  }

  @override
  void dispose() {
   player.dispose();

    super.dispose();
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
    Navigator.pop(context);
    return goBack;
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

  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // title: 'Weei',
      theme: ThemeData(
        canvasColor: Color(0xff1e1e1e),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff1e1e1e)),
        fontFamily: 'mon',
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: WillPopScope(

          onWillPop: _onBackPressed,
          child: Scaffold(
            // endDrawer: VideoDrawerWidget(type: widget.type,id: widget.id,uid: auth.currentUser!.uid,controller: navigationListner,private: private,disableComment:chatAlert,disableJoinAlert:joinAlert,disableAdminControls:creatorControl,controlJoins:controlJoined,),
            backgroundColor: bgClr,

            resizeToAvoidBottomInset: false,
            appBar: AppBar(

              elevation: 0,
              actions: [

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

                Builder(builder: (context) => // Ensure Scaffold is in context
                PopupMenuButton(
                  onSelected: (value) {
                    // _onMenuItemSelected(value as int);
                    print("value");
                    print(value);
                    if(value==0){
                      player.dispose();


                      if( widget.playingType=="YTAUDIO"){
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
              // title: GestureDetector(
              //   onTap: () {
              //     // goLive();
              //     shareSheet();
              //   },
              //   child: Container(
              //     child: Padding(
              //       padding: const EdgeInsets.all(5.0),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Text("#" + widget.id.toString(), style: size14_500W),
              //           w(5),
              //           const CircleAvatar(
              //             backgroundColor: grey,
              //             child: Icon(Icons.share, size: 10),
              //             radius: 10,
              //           )
              //         ],
              //       ),
              //     ),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(100),
              //         color: const Color(0xff2B2B2B)),
              //   ),
              // ),
            ),

            bottomNavigationBar: Container(
              color: liteBlack,
              height: 50,
              child: Column(
                children: [
                  BannerAdsMus(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // IconButton(
                        //     onPressed: () {
                        //       if (playlistTap == true) {
                        //         setState(() {
                        //           playlistTap = false;
                        //         });
                        //       } else {
                        //         setState(() {
                        //           playlistTap = true;
                        //           chatlistTap = false;
                        //
                        //         });
                        //       }
                        //     },
                        //     icon: Icon(CupertinoIcons.line_horizontal_3,
                        //         color:
                        //             playlistTap == true ? themeClr : Colors.white)),



                        // IconButton(
                        //     onPressed: () {
                        //       if (chatlistTap == true) {
                        //         setState(() {
                        //
                        //           chatlistTap = false;
                        //         });
                        //       } else {
                        //         setState(() {
                        //           chatlistTap = true;
                        //           playlistTap = false;
                        //
                        //         });
                        //       }
                        //       // chatBottomSheet();
                        //     },
                        //     icon: Icon(Icons.chat,
                        //         color:
                        //             chatlistTap == true ? themeClr : Colors.white,
                        //         size: 20)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: intialLoading == true
                ? Container(
              color: bgClr,
              child: Column(
                children: [
                  musicAddStarted==true? Container(
                    height: 25,
                    decoration: BoxDecoration(

                        color: themeClr),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [

                        Text("Fetching music " + musicAddCount.toString()+" / "+playList.length.toString(), style: size13_600W)
                      ],
                    ),
                  ):Container(),
                  MusicLoading(height: (ss.height-200),),
                ],
              ),
            )
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
                            Text("Playing from", style: size14_500W),
                            SizedBox(height: 5),
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Music Player",
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
                      child: Stack(
                        children: [
                          playList[player.currentIndex!]['fileType'] ==
                              "AUDIO"
                              ? LocalThumbnail(name: playList[player.currentIndex!]['fileName']):Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image: DecorationImage(
                                  image: NetworkImage(
                                      playList[player.currentIndex]['fileThumb']),
                                  fit: BoxFit.cover),
                              borderRadius:
                              BorderRadius.circular(
                                  10),
                            ),
                          )
                          ,

                        ],
                      ),
                    ),
                    // h(ss.height * 0.05),
                    intialStart == 'false'
                        ? Container()
                        : Container(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              playList[player.currentIndex]['fileName'].toString(),
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
                            onChanged: (double? value) {
                              print("seekrdy");
                              if (value!.round() > (duration)) {

                                print("velthh");
                                if(autoPlayToggle==true){

                                  next();

                                }else{
                                  // playNext(currentIndex, context);

                                  player.seek(Duration(seconds: 0),index: player.currentIndex);
                                  updateTime();
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


                                });
                              });
                            },
                            max: duration == null
                                ? 0.0
                                : double.parse((duration+2000).toString()),
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
                                          color:autoPlayToggle == true? themeClr:Colors.white,
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
                                        onPressed:loading==true?null: () {
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
                                      ): IconButton(
                                        padding:
                                        EdgeInsets.zero,
                                        icon: player.playing==false
                                            ? Icon(
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


                                          } else {
                                            player.play();
                                            setState(() {
                                              musicPlaying =
                                              true;
                                            });

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
                                        onPressed:loading==true?null: () {
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
                                          color: autoPlayToggle == false? themeClr:Colors.white,
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
        ),
      ),
    );
  }

  MusicList(var item, int index) {
    return GestureDetector(
      onTap: loading==true?null:() {



        if (widget.type == "CREATE" && intialStart == 'false') {
          showToastSuccess("Session not yet started!");
          return;
        }

        // setState(() {
        //   loading = true;
        //   currentIndex = index;
        // });

        // if(loading==false){
     //  playNext(index, context);
          player.seek(Duration(seconds: 0),index: index);
        updateTime();
        //  }
      },
      child: Row(
        children: [
          Container(
            height: 33,
            child: player.currentIndex == index
                ? Image.asset("assets/svg/nowPlaying.gif")
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
                Text(item['fileName']!=null?item['fileName'].toString():"", style: player.currentIndex == index?size14_500G:size14_500W),

                h(5),
                //Text(getFileSize(int.parse(item['fileSize'].toString()),1).toString(), style: size14_500Grey),
              ],
            ),
          )
        ],
      ),
    );
  }


}