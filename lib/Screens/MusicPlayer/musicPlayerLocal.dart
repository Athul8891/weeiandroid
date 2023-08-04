import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/MusicLoading.dart';

import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/setupbgaudio.dart';

import 'package:weei/Screens/Admob/BannerAdsMus.dart';
import 'package:weei/Screens/Admob/BannerAdsVidStr.dart';

import 'package:weei/Screens/Main_Screens/Chat/addLocalForSession.dart';
import 'package:weei/Screens/Main_Screens/Chat/addYTForSession.dart';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:weei/Screens/MusicPlayer/localThumbnai.dart';
import 'package:weei/Screens/MusicPlayer/widgets/buttons/control_buttons.dart';
import 'package:weei/Screens/MusicPlayer/widgets/buttons/loop_button.dart';
import 'package:weei/Screens/MusicPlayer/widgets/buttons/shuffle_button.dart';
import 'package:weei/Screens/MusicPlayer/widgets/play_list_View.dart';
import 'package:weei/Screens/MusicPlayer/widgets/players/minimal_audio_player.dart';
import 'package:weei/Screens/MusicPlayer/widgets/playlist.dart';
import 'package:weei/Screens/MusicPlayer/widgets/seekbar.dart';
import 'package:weei/Widgets/minimalplayer.dart';
import 'package:weei/Widgets/miplay.dart';
import 'package:safe_url_check/safe_url_check.dart';


import '../../Helper/Const.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../Helper/checkUrl.dart';
import '../../Helper/cofirmExitAlert.dart';


void main() async {

  await setupAudio();

  runApp(
      audioPlayerLocal()
  );
  // runApp(const MyApp());
}
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
  var seekListener = TextEditingController();

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
  final _audioPlayer = AudioPlayer();


  ///playerconf
  final _playlist = ConcatenatingAudioSource(children: []);
  final _playlistBackup = ConcatenatingAudioSource(children: []);

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
  var musicAddCount = 0;
  var  musicAddStarted=false;
  var  pageExit=false;
  final yt = YoutubeExplode();
  late Timer timer;


  @override
  void initState() {


    print("widget.id");
    print(widget.id);

    getPlayList(widget.path);
    // timer = Timer.periodic(Duration(minutes: 1), (Timer t) =>   refreshPlayList());
    super.initState();
  }

  void getPlayList(_path)async{
    // await setupAudio();
    if(_path==null){
      setState(() {
        playList=widget.data;
      });

      fetchUrl();

    }else{
      databaseReference.child(_path).once().then(( snapshot) async {
        var data = snapshot.snapshot.value;
        setState(() {
          playList=data;

        });



      }).whenComplete((){


        fetchUrl();



        //  setUpChannel("playList[0][0]['fileUrl']");
      });
    }

  }
  fetchUrl()async{
    // _audioPlayer.player.dispose();
    setState(() {
      musicAddStarted=true;
    });
    for (var i = 0; i < playList.length; i++) {
      var link;

      link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());
      final exists = await safeUrlCheck(
        Uri.parse(link),
        //  userAgent: 'myexample/1.0.0 (+https://example.com)',
      );
      if (exists) {
        link = link;
        print('The url: https://google.com is NOT broken');
      }else{
        print('The url: https://google.com is  broken');

        link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());

      }
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
          // extras: {
          //   'fileName':  playList[i]['fileName'].toString(),
          //   'fileThumb':  playList[i]['fileThumb'].toString(),
          //   'fileUrl':  playList[i]['fileUrl'].toString(),
          //   'fileType':  playList[i]['fileType'].toString(),
          //
          // },
        ),
      ));
      print("nameeeee");
      print(playList[i]['fileName'].toString());
    }
    // _audioPlayer.playAudios(_playlist);

    //  _audioPlayer.player.setAudioSource(_playlist);
    setState(() {
      musicAddStarted=false;
      intialLoading=false;
      listenAudio();
      //  _audioPlayer.play();

    });
  }
  listenAudio(){

    _audioPlayer.currentIndexStream.listen((index) {

      print("currentIndxx");
      print(index);
      print("currentIndxx");
      // setState(() {
      //   currentIndex =index;
      // });
      // updateUrl(index);

    });


  }

  refreshPlayList()async{
    print("list refresh started");
    if(intialLoading==false&&pageExit==false){
      for (var i = 0; i < playList.length; i++) {
        var link = await getSong(playList[i]['fileUrl'].toString(),playList[i]['fileType'].toString());



        // _audioPlayer.addToPlayList(_playlist, playList);
        _playlistBackup.add( AudioSource.uri(
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
        print("nameeeee");
        print(playList[i]['fileName'].toString());
      }
      _playlist.addAll(_playlistBackup.children).onError((error, stackTrace) => print("failllll "+error.toString()));

      for (var i = 0; i < playList.length; i++) {
        _playlist.removeAt((playList.length+i));
        print("removeee - " + (playList.length+i).toString());
      }
    }

    print("list refresh ended");

  }




  @override
  void dispose() {
    setState(() {
      pageExit=true;
      timer.cancel();


    });
    // _audioPlayer.player.dispose();
    super.dispose();
  }


  Future<bool> _onBackPressed() async {
    bool goBack = false;


    print("exitt");
    exitSheet();
    //   if(chatlistTap==true){
    //     setState(() {
    //       chatlistTap=false;
    //     });
    //
    //     return goBack;
    //   }
    //
    //
    //   if(playlistTap==true){
    //     setState(() {
    //       playlistTap=false;
    //     });
    //
    //     return goBack;
    //   }
    //   Navigator.pop(context);
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

    return   WillPopScope(

      onWillPop: _onBackPressed,
      child: Scaffold(
        // endDrawer: VideoDrawerWidget(type: widget.type,id: widget.id,uid: auth.currentUser!.uid,controller: navigationListner,private: private,disableComment:chatAlert,disableJoinAlert:joinAlert,disableAdminControls:creatorControl,controlJoins:controlJoined,),
        // backgroundColor: bgClr,

        resizeToAvoidBottomInset: false,
        appBar: AppBar(

          elevation: 0,
          actions: [

            intialLoading==true?Container() :IconButton(
                onPressed: () {
                  playlistBottomSheet(ss.height);
                },
                icon: Icon(CupertinoIcons.line_horizontal_3,
                    color:
                    playlistTap == true ? themeClr : Colors.white)),

            Builder(builder: (context) => // Ensure Scaffold is in context
            intialLoading==true?Container() :PopupMenuButton(
              onSelected: (value) {
                // _onMenuItemSelected(value as int);
                print("value");
                print(value);
                if(value==0){
                  //   _audioPlayer. player.dispose();


                  if( widget.playingType=="YTAUDIO"){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => addYTToSession(
                            type: widget.playingType,
                            private: true,
                            isPlaylist: widget.isPlaylist,
                            url: widget.url,
                            ConcatenatingAudioSource: _playlist,
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
                            ConcatenatingAudioSource: _playlist,
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
          // backgroundColor: const Color(0xff7D98A8),
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
          color: bgClr,
          //  height: 50,
          child:  BannerAdsMus(),
        ),
        body:  intialLoading==true?Container(
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
              MusicLoading(height: (ss.height),),
            ],
          ),
        ): MinimalAudioPlayer(

            audioPlayer: _audioPlayer,
            autoPlay: true,
            playlist: _playlist,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),

              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: null,
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(height: 2),
                          Text("Playing from", style: size14_500W),
                          Text("Music Player",
                              style: size14_600W),


                          SizedBox(height: 10),
                          // Text("Game of Thrones", style: size14_600W),
                        ],
                      )),
                  ///
                  SizedBox(height: 10,),
                  AspectRatio(
                    aspectRatio: 1/1,
                    child: StreamBuilder<SequenceState?>(
                      stream:_audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) {
                        final state = snapshot.data;
                        if (state?.sequence.isEmpty ?? true) return const SizedBox();
                        final metadata = state!.currentSource!.tag as MediaItem;
                        return Stack(
                          children: [
                            metadata.artist ==
                                "AUDIO"
                                ? LocalThumbnail():Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                image: DecorationImage(
                                    image: NetworkImage(
                                        metadata.artUri.toString()),
                                    fit: BoxFit.cover),
                                borderRadius:
                                BorderRadius.circular(
                                    10),
                              ),
                            ),

                            Visibility(visible:false,child: PlaylistView(player:_audioPlayer, playlist: _playlist))
                            // ,
                            // Container(
                            //     child: Column(
                            //       children: [
                            //         SizedBox(height: 10),
                            //         Text(
                            //           metadata.title,
                            //           style: size14_600W,
                            //           textAlign: TextAlign.left,
                            //           maxLines: 1,
                            //         ),
                            //         // Text("Ramin Djawadi", style: size14_500W),
                            //       ],
                            //     ))
                          ],
                        );
                      },
                    ),
                  ),
                  ///
                  StreamBuilder<SequenceState?>(
                    stream:_audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      if (state?.sequence.isEmpty ?? true) return const SizedBox();
                      final metadata = state!.currentSource!.tag as MediaItem;

                      return Container(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                metadata.title,
                                style: size14_600W,
                                textAlign: TextAlign.left,
                                maxLines: 1,
                              ),
                              // Text("Ramin Djawadi", style: size14_500W),
                            ],
                          ));
                    },
                  ),
                  ///
                  h(15),
                  AudioPlayerSeekBar(audioPlayer:_audioPlayer,seekListener:seekListener),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 15),
                          child: LoopButton(player:_audioPlayer)),
                      Spacer(),
                      ControlButtons(_audioPlayer,true,seekListener),
                      Spacer(),
                      Container(
                          margin: EdgeInsets.only(top: 12),

                          child: ShuffleButton(player:_audioPlayer))
                    ],
                  ),



                  const SizedBox(height: 8.0),

                  //  Visibility(visible:false,child: SizedBox(height:1,child: PlaylistView(player: _audioPlayer, playlist: _playlist)))
                ],
              ),
            )
        ),
      ),
    );
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
                        Text('Playlist ('+_playlist.length.toString()+' Songs)', style: size14_600W),
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
                  PlaylistView(player: _audioPlayer, playlist: _playlist,height: height,type: widget.type,),
                  BannerAdsVidStr(),
                  //musicPlayList(playList:playList, player:_audioPlayer,title:index)
                ],
              ),
            );
          });
        });




    //future.then((void value) => _closeModal(value));
  }

  // void _closeModal(void value) {
  //
  //
  //   setState(() {
  //
  //     playlistTap=false;
  //   });
  //
  // }
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
                          child: buttonss("Exit", themeClr, ()async {

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
                          child: buttonss("Cancel", grey, ()async {

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
  buttonss(String txt, Color clr, GestureTapCallback onTap) {
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