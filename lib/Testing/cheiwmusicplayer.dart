// import 'dart:io';
//
// import 'package:chewie_audio/chewie_audio.dart';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:video_player/video_player.dart';
//
// class ChewieAudioDemo extends StatefulWidget {
//   const ChewieAudioDemo({
//     Key? key,
//     this.title = 'Chewie Audio Demo',
//   }) : super(key: key);
//
//   final String title;
//
//   @override
//   State<StatefulWidget> createState() {
//     return _ChewieAudioDemoState();
//   }
// }
//
// class _ChewieAudioDemoState extends State<ChewieAudioDemo> {
//   TargetPlatform? _platform;
//   late VideoPlayerController _videoPlayerController1;
//   late VideoPlayerController _videoPlayerController2;
//   ChewieAudioController? _chewieController;
//   int? bufferDelay;
//
//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController1.dispose();
//     _videoPlayerController2.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   List<String> srcs = [
//     "https://www.w3schools.com/html/horse.mp3",
//     "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
//     "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
//     "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4",
//   ];
//
//   Future<void> initializePlayer() async {
//     _videoPlayerController1 =
//         VideoPlayerController.network(srcs[currPlayIndex]);
//     _videoPlayerController2 =
//         VideoPlayerController.network(srcs[currPlayIndex]);
//     await Future.wait([
//       _videoPlayerController1.initialize(),
//       _videoPlayerController2.initialize()
//     ]);
//     _createChewieController();
//     setState(() {});
//   }
//
//   void _createChewieController() {
//     _chewieController = ChewieAudioController(
//       videoPlayerController: _videoPlayerController1,
//       autoPlay: true,
//       looping: true,
//       progressIndicatorDelay:
//       bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
//
//       // Try playing around with some of these other options:
//
//       // showControls: false,
//       // looping: true,
//       // materialProgressColors: ChewieProgressColors(
//       //   playedColor: Colors.red,
//       //   handleColor: Colors.blue,
//       //   backgroundColor: Colors.grey,
//       //   bufferedColor: Colors.lightGreen,
//       // ),
//       // autoInitialize: true,
//     );
//   }
//
//   int currPlayIndex = 0;
//
//   Future<void> toggleVideo() async {
//     await _videoPlayerController1.pause();
//     currPlayIndex += 1;
//     if (currPlayIndex >= srcs.length) {
//       currPlayIndex = 0;
//     }
//     await initializePlayer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: widget.title,
//       theme: AppTheme.light.copyWith(
//         platform: _platform ?? Theme.of(context).platform,
//       ),
//       darkTheme: AppTheme.dark.copyWith(
//         platform: _platform ?? Theme.of(context).platform,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             _chewieController != null
//                 ? ChewieAudio(
//               controller: _chewieController!,
//             )
//                 :  Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 20),
//                 Text('Loading'),
//               ],
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _platform = TargetPlatform.android;
//                       });
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text("Android controls"),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _platform = TargetPlatform.iOS;
//                       });
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text("iOS controls"),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         _platform = TargetPlatform.windows;
//                       });
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text("Desktop controls"),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (!kIsWeb && Platform.isAndroid)
//               ListTile(
//                 title: const Text("Delay"),
//                 subtitle: DelaySlider(
//                   delay:
//                   _chewieController?.progressIndicatorDelay?.inMilliseconds,
//                   onSave: (delay) async {
//                     if (delay != null) {
//                       bufferDelay = delay == 0 ? null : delay;
//                       await initializePlayer();
//                     }
//                   },
//                 ),
//               ),
//              Expanded(child: Column()),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class DelaySlider extends StatefulWidget {
//   const DelaySlider({Key? key, required this.delay, required this.onSave})
//       : super(key: key);
//
//   final int? delay;
//   final void Function(int?) onSave;
//   @override
//   State<DelaySlider> createState() => _DelaySliderState();
// }
//
// class _DelaySliderState extends State<DelaySlider> {
//   int? delay;
//   bool saved = false;
//
//   @override
//   void initState() {
//     super.initState();
//     delay = widget.delay;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const int max = 1000;
//     return ListTile(
//       title: Text(
//         "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
//       ),
//       subtitle: Slider(
//         value: delay != null ? (delay! / max) : 0,
//         onChanged: (value) async {
//           delay = (value * max).toInt();
//           setState(() {
//             saved = false;
//           });
//         },
//       ),
//       trailing: IconButton(
//         icon: const Icon(Icons.save),
//         onPressed: saved
//             ? null
//             : () {
//           widget.onSave(delay);
//           setState(() {
//             saved = true;
//           });
//         },
//       ),
//     );
//   }
// }
//
//
// class AppTheme {
//   static final light = ThemeData(
//     brightness: Brightness.light,
//     useMaterial3: true,
//     colorScheme: const ColorScheme.light(secondary: Colors.red),
//     disabledColor: Colors.grey.shade400,
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//   );
//
//   static final dark = ThemeData(
//     brightness: Brightness.dark,
//     colorScheme: const ColorScheme.dark(secondary: Colors.red),
//     disabledColor: Colors.grey.shade400,
//     useMaterial3: true,
//     visualDensity: VisualDensity.adaptivePlatformDensity,
//   );
// }