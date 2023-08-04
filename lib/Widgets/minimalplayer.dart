import 'package:easy_audio_player/flutter_audio_player.dart';
import 'package:easy_audio_player/widgets/buttons/play_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MinimalAudioPlayer1 extends StatefulWidget {
  const MinimalAudioPlayer1(
      {Key? key, required this.audioPlayer, required this.playlist, this.autoPlay = true, this.child})
      : super(key: key);
  final AudioPlayerService audioPlayer;
  final ConcatenatingAudioSource playlist;
  final bool autoPlay;
  final Widget? child;

  @override
  State<MinimalAudioPlayer1> createState() => _MinimalAudioPlayerState();
}

class _MinimalAudioPlayerState extends State<MinimalAudioPlayer1> {
  @override
  Widget build(BuildContext context) {

    widget.audioPlayer.playAudios(widget.playlist);
    if (widget.autoPlay == false && widget.child == null) return PlayButton(player: widget.audioPlayer.player);
    return widget.child ?? const SizedBox();
  }
}
