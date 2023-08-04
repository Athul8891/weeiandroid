import 'package:easy_audio_player/helpers/init_just_audio_background.dart';
import 'package:easy_audio_player/models/models.dart';
import 'package:easy_audio_player/widgets/players/basic_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:weei/Widgets/audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
final _playlist = ConcatenatingAudioSource(children: []);

void main() async {
  // init the background service to display notifications while playing
  await initJustAudioBackground(NotificationSettings(androidNotificationChannelId: 'com.example.example'));
  runApp(MaterialApp(
    home: HomeScreen(playlist: _playlist),
  ));
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key,required this.playlist}) : super(key: key);
  static const routeName = '/';
  final ConcatenatingAudioSource playlist;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var loading = true;


  @override
  void initState() {

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: FullAudioPlayer(playlist: widget.playlist,listPlay: true,),
                ))));
  }
}

// Column(
//   children: [
//     Expanded(
//       child: StreamBuilder<SequenceState?>(
//         stream: _audioPlayer.sequenceStateStream,
//         builder: (context, snapshot) {
//           final state = snapshot.data;
//           if (state?.sequence.isEmpty ?? true) return const SizedBox();
//           final metadata = state!.currentSource!.tag as MediaItem;
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Center(
//                     child: ClipRRect(
//                         borderRadius: BorderRadius.circular(25.0),
//                         child: Image.network(metadata.artUri.toString()))),
//               ),
//               //? title and album
//               Text(metadata.title, style: Theme.of(context).textTheme.headline6),
//               Text(metadata.album ?? ''),
//             ],
//           );
//         },
//       ),
//     ),
//     ControlButtons(_audioPlayer),
//  AudioPlayerSeekBar(audioPlayer: _audioPlayer),
//     const SizedBox(height: 8.0),
//     Row(
//       children: [
//         LoopButton(player: _audioPlayer),
//         Expanded(
//           child: Text(
//             "Playlist",
//             style: Theme.of(context).textTheme.headline6,
//             textAlign: TextAlign.center,
//           ),
//         ),
//         ShuffleButton(player: _audioPlayer)
//       ],
//     ),
//     PlaylistView(player: _audioPlayer, playlist: _playlist)
//   ],
// ),