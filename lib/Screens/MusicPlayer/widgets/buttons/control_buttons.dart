import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:weei/Screens/MusicPlayer/widgets/buttons/play_button.dart';

import '../../../../Widgets/comm.dart';

class ControlButtons extends StatefulWidget {
  final AudioPlayer player;
  final bool autoPlay;

  final TextEditingController seekListener;

  const ControlButtons(this.player, this.autoPlay, this.seekListener, {Key? key}) : super(key: key);

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {

  @override
  void dispose() {

    widget.player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // IconButton(
        //   icon: const Icon(Icons.volume_up),
        //   onPressed: () {
        //     showSliderDialog(
        //       context: context,
        //       title: "Adjust volume",
        //       divisions: 10,
        //       min: 0.0,
        //       max: 1.0,
        //       stream: widget.player.volumeStream,
        //       onChanged: widget.player.setVolume,
        //     );
        //   },
        // ),
        StreamBuilder<SequenceState?>(
          stream: widget.player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous,color: Colors.white,size: 45,),
            onPressed: widget.player.hasPrevious ? widget.player.seekToPrevious : null,
          ),
        ),
        SizedBox(width: 10,),
        PlayButton(player: widget.player,autoplay: widget.autoPlay,seekListener:widget.seekListener),
        SizedBox(width: 10,),

        StreamBuilder<SequenceState?>(
          stream: widget.player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next,color: Colors.white,size: 45),

            onPressed: widget.player.hasNext ? widget.player.seekToNext : null,
          ),
        ),
        // StreamBuilder<double>(
        //   stream: widget.player.speedStream,
        //   builder: (context, snapshot) => IconButton(
        //     icon: Text("${snapshot.data?.toStringAsFixed(1)}x", style: const TextStyle(fontWeight: FontWeight.bold)),
        //     onPressed: () {
        //       showSliderDialog(
        //         context: context,
        //         title: "Adjust speed",
        //         divisions: 10,
        //         min: 0.5,
        //         max: 1.5,
        //         stream: widget.player.speedStream,
        //         onChanged: widget.player.setSpeed,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }
}
