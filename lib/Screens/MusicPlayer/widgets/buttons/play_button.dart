
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({
    Key? key,
    required this.player,
     this.autoplay,
    required this.seekListener,
  }) : super(key: key);

  final AudioPlayer player;
  final  autoplay;
  final TextEditingController seekListener;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  void initState() {
    print("trueee");
    print(widget.autoplay);

  }

  play(){
    widget.player.play();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: widget.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 50.0,
            height: 50.0,

            child: const CircularProgressIndicator(color: Colors.white,),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_circle_fill,color: Colors.white,),
            iconSize: 64.0,
            onPressed: widget.player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause_circle_filled,color: Colors.white,),
            iconSize: 64.0,
            onPressed: widget.player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 64.0,
            onPressed: () { widget.seekListener.text=DateTime.now().millisecondsSinceEpoch.toString();widget.player.seek(Duration.zero, index: widget.player.effectiveIndices!.first);},
          );
        }
      },
    );
  }


}