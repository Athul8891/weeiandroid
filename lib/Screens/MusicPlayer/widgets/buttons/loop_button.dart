import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:weei/Helper/Const.dart';

class LoopButton extends StatefulWidget {
  const LoopButton({Key? key, required this.player}) : super(key: key);
  final AudioPlayer player;

  @override
  State<LoopButton> createState() => _LoopButtonState();
}

class _LoopButtonState extends State<LoopButton> {

  @override
  void dispose() {

    widget.player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoopMode>(
      stream: widget.player.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        final icons = [
          const Icon(Icons.repeat, color: Colors.grey),
          Icon(Icons.repeat, color: themeClr),
          Icon(Icons.repeat_one, color: themeClr),
        ];
        const cycleModes = [
          LoopMode.off,
          LoopMode.all,
          LoopMode.one,
        ];
        final index = cycleModes.indexOf(loopMode);
        return IconButton(
          icon: icons[index],
          onPressed: () {
            widget.player.setLoopMode(cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
          },
        );
      },
    );
  }
}
