import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:weei/Helper/Const.dart';

class ShuffleButton extends StatefulWidget {
  const ShuffleButton({Key? key, required this.player}) : super(key: key);
  final AudioPlayer player;

  @override
  State<ShuffleButton> createState() => _ShuffleButtonState();
}

class _ShuffleButtonState extends State<ShuffleButton> {
  @override
  void dispose() {

    widget.player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.player.shuffleModeEnabledStream,
      builder: (context, snapshot) {
        final shuffleModeEnabled = snapshot.data ?? false;
        return IconButton(
          icon: shuffleModeEnabled
              ? const Icon(Icons.shuffle, color: themeClr)
              : const Icon(Icons.shuffle, color: Colors.grey),
          onPressed: () async {
            final enable = !shuffleModeEnabled;
            if (enable) {
              await widget.player.shuffle();
            }
            await widget.player.setShuffleModeEnabled(enable);
          },
        );
      },
    );
  }
}
