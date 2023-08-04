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



import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';





class audioPlayerStreamWidget extends StatefulWidget {

  final audioPlayer;
  final playlist;
  final autoPlay;
  final id;
  final seekListener;
  final diffIndexPlaying;
  final type;


  audioPlayerStreamWidget({this.audioPlayer,this.playlist,this.autoPlay ,this.id,this.seekListener,this.diffIndexPlaying,this.type,  });

  @override
  _audioPlayerScreenState createState() => _audioPlayerScreenState();
}

class _audioPlayerScreenState extends State<audioPlayerStreamWidget> {



  @override
  void initState() {






    super.initState();
  }








  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return   MinimalAudioPlayer(

        audioPlayer: widget.audioPlayer,
        autoPlay: widget.autoPlay,
        playlist: widget.playlist,
        child:      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25 ),

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
                      Text("Room #" + widget.id.toString(),
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
                  stream:widget.audioPlayer.sequenceStateStream,
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

                        Visibility(visible:false,child: PlaylistView(player:widget.audioPlayer, playlist: widget.playlist))
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
                stream:widget.audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) return const SizedBox();
                  final metadata = state!.currentSource!.tag as MediaItem;
                 // widget.diffIndexPlaying.text=metadata.title;
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
              AudioPlayerSeekBar(audioPlayer:widget.audioPlayer,seekListener:widget.seekListener),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.type=="JOIN"?Container(): Container(
                    margin: EdgeInsets.only(top: 15),
                      child: LoopButton(player: widget.audioPlayer)),
                   Spacer(),
                  ControlButtons(widget.audioPlayer,widget.autoPlay,widget.seekListener),
                  Spacer(),
                  widget.type=="JOIN"?Container():Container(
                      margin: EdgeInsets.only(top: 12),

                      child: ShuffleButton(player:widget.audioPlayer))
                ],
              ),



              const SizedBox(height: 8.0),

              //  Visibility(visible:false,child: SizedBox(height:1,child: PlaylistView(player: _audioPlayer, playlist: _playlist)))
            ],
          ),
        )
    )


     ;
  }





}