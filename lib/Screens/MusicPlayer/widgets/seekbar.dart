import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_audio_player/flutter_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:weei/Helper/Const.dart';
class AudioPlayerSeekBar extends StatefulWidget {
  const AudioPlayerSeekBar({Key? key, required this.audioPlayer,required this.seekListener}) : super(key: key);
  final AudioPlayer audioPlayer;
  final  TextEditingController seekListener;

  @override
  State<AudioPlayerSeekBar> createState() => _AudioPlayerSeekBarState();
}

class _AudioPlayerSeekBarState extends State<AudioPlayerSeekBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.audioPlayer.positionStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          var position = snapshot.data as Duration;
          return ProgressBar(

              onDragEnd: (){
             if(widget.seekListener!=null){
               widget.seekListener.text=position.toString();
             }
            },
              progressBarColor: Colors.white,
              bufferedBarColor: Colors.green.shade300,
              baseBarColor: Colors.green[50],
              thumbColor:  Colors.green[50],
              thumbGlowColor: Colors.white,
              progress: position,

              timeLabelTextStyle:  TextStyle(
                  fontSize: 14,
                  color: Colors.white),
              buffered: widget.audioPlayer.playbackEvent.bufferedPosition,
              total: widget.audioPlayer.playbackEvent.duration ?? Duration.zero,
              onSeek: widget.audioPlayer.seek);
        });
  }
}
