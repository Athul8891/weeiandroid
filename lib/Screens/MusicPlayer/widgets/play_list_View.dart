import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({Key? key, required this.player, required this.playlist,this.height,this.type}) : super(key: key);
  final AudioPlayer player;
  final ConcatenatingAudioSource playlist;
  final  height;
  final  type;

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:widget.height==null? 240.0:widget.height* 0.6,
      child: StreamBuilder<SequenceState?>(
        stream: widget.player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];
          return ListView(
            // onReorder: (int oldIndex, int newIndex) {
            //   if (oldIndex < newIndex) newIndex--;
            //   widget.playlist.move(oldIndex, newIndex);
            // },
            children: [
              for (var i = 0; i < sequence.length; i++)
                Material(
                  color: i == state!.currentIndex ? Colors.grey.shade300 : null,
                  child: ListTile(
                    title: Text(sequence[i].tag.title as String,style: TextStyle(color: i != state!.currentIndex ?Colors.white:Colors.black),),
                    onTap: widget.type=="JOIN"?null:() {
                      widget.player.seek(Duration.zero, index: i);
                    },
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
