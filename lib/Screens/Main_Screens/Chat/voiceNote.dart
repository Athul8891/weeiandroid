import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:weei/Screens/voicenote/voicenote_loading.dart';
import 'package:weei/Screens/voicenote/voicenote_session.dart';

class voiceNote extends StatefulWidget {
  final item;
  final uid;
  final index;
  final voiceNotePlayingListner;


  voiceNote({this.item,this.uid,this.index,this.voiceNotePlayingListner});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<voiceNote> {



  @override
  void initState() {

  }
  TextEditingController playingIndexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.item['url']=="false"?VoiceMessageLoading(

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
    ):VoiceMessageSession(

      audioSrc: widget.item['url'],

      time: "0",
      playingController: widget.voiceNotePlayingListner,
      urlLauched: widget.item['url'],

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
