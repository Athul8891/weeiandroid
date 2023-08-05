

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:weei/Screens/MusicPlayer/widgets/buttons/play_button.dart';

class MinimalAudioPlayer extends StatefulWidget {
  const MinimalAudioPlayer(
      {Key? key, required this.audioPlayer, required this.playlist, this.autoPlay = true, this.child})
      : super(key: key);
  final AudioPlayer audioPlayer;
  final ConcatenatingAudioSource playlist;
  final bool autoPlay;
  final Widget? child;

  @override
  State<MinimalAudioPlayer> createState() => _MinimalAudioPlayerState();
}

class _MinimalAudioPlayerState extends State<MinimalAudioPlayer> {
  var seekListener = TextEditingController();

  @override
  void initState() {


    widget.audioPlayer.setAudioSource(widget.playlist);




    super.initState();
  }

  @override
  void dispose() {

   // widget.audioPlayer.player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
  print("autoooooo");
  print(widget.autoPlay);
    if (widget.autoPlay == false && widget.child == null) return PlayButton(player: widget.audioPlayer,autoplay: widget.autoPlay,seekListener:seekListener);
    return widget.child ?? const SizedBox();
  }
}
