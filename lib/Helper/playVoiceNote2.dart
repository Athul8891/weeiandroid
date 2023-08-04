import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:weei/Screens/voicenote/voicenote_loading.dart';
import 'package:weei/Screens/voicenote/voicenote_session.dart';
import 'package:audio_service/audio_service.dart';

class playVoiceNote2 extends StatefulWidget {
  final item;
  final uid;
  final index;
  final voiceNotePlayingListner;
  final voiceNoteReloadListner;


  playVoiceNote2({this.item,this.uid,this.index,this.voiceNotePlayingListner,this.voiceNoteReloadListner});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<playVoiceNote2> {
  TextEditingController playingIndexController = TextEditingController();
  final player = AudioPlayer();
  var duration;

  @override
  void initState() {

  }



  @override
  Widget build(BuildContext context) {


    return widget.item['message']=="false"?(widget.item['uId']==widget.uid?Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        VoiceMessageLoading(
          // key: widget.voiceNoteReloadListner.text==widget.index.toString()? Key('builder ${DateTime.fromMillisecondsSinceEpoch.toString()}'):Key('builder ${DateTime.fromMillisecondsSinceEpoch.toString()}'),
          audioSrc:"",
          time:"0",
          urlLauched: widget.item['message'],
          played: false, // To show played badge or not.
          meBgColor: blueClr,
          meFgColor: Colors.grey.shade100,

          mePlayIconColor: blueClr,
          contactBgColor: Colors.grey.shade100,
          contactFgColor: blueClr,
          contactPlayIconColor: Colors.grey.shade100,
          me:  widget.uid==widget.item['uId']?true:false,   // Set message side.
          onPlay: () {
            print("plaaaaaaaaay");
          }, // Do something when voice played.
        ),
        Text("Sending...", style: size12_400wht)
      ],
    ):Text("Recording...", style: size12_400wht)):VoiceMessageSession(
      //key: widget.voiceNoteReloadListner.text==widget.index.toString()? Key('builder ${DateTime.fromMillisecondsSinceEpoch.toString()}'):Key('builder ${DateTime.fromMillisecondsSinceEpoch.toString()}'),

      audioSrc: widget.item['url'],

      time: widget.item['sec'],
      playingController: widget.voiceNotePlayingListner,
      urlLauched: widget.item['message'],

      //played: playingIndexController.text==widget.index.toString()?true:false,
      played: true,

      index: widget.index,
      // To show played badge or not.
      meBgColor: blueClr,
      meFgColor: Colors.grey.shade100,

      mePlayIconColor: blueClr,
      contactBgColor: Colors.grey.shade100,
      contactFgColor: blueClr,
      contactPlayIconColor: Colors.grey.shade100,
      me:  widget.uid==widget.item['uId']?true:false,  // Set message side.
      onPlay: () {
        print("plaaaaaaaaay");
        // playingIndexController.text=widget.index.toString();
      }, // Do something when voice played.
    );
  }


}
