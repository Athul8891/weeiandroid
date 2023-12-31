import 'package:flutter/material.dart';
import 'package:easy_audio_player/widgets/players/minimal_audio_player.dart';
import 'package:easy_audio_player/services/audio_player_service.dart';
import 'package:easy_audio_player/widgets/buttons/control_buttons.dart';
import 'package:easy_audio_player/widgets/seekbar.dart';
import 'package:just_audio/just_audio.dart';

class BasicAudioPlayer extends StatefulWidget {
  const BasicAudioPlayer({Key? key, required this.playlist, this.autoPlay = true}) : super(key: key);
  final ConcatenatingAudioSource playlist;
  final bool autoPlay;

  @override
  State<BasicAudioPlayer> createState() => _BasicAudioPlayerState();
}

class _BasicAudioPlayerState extends State<BasicAudioPlayer> {
  @override
  Widget build(BuildContext context) {
    final _audioPlayer = AudioPlayerService();
    return MinimalAudioPlayer(
      audioPlayer: _audioPlayer,
      autoPlay: widget.autoPlay,
      playlist: widget.playlist,
      child: Column(
        children: [
          ControlButtons(_audioPlayer.player),
          AudioPlayerSeekBar(audioPlayer: _audioPlayer),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
