

import 'package:audioplayers/audioplayers.dart';




getDuration(path)async{
  var dur;
  final  audioPlayer = AudioPlayer();

   var ply =await audioPlayer.play(path,isLocal: true);
 var st = await  audioPlayer.onDurationChanged.listen((d) {
    dur= d.inMilliseconds;
    print("setuuuuup"); print(d.inMilliseconds);print("setuuuuup");

     return dur;
  } );
  // final player = AudioPlayer();
  //
  // final setup = await player.setAudioSource(
  //   AudioSource.uri(
  //     Uri.parse("asset:///"+path),
  //     tag: MediaItem(
  //       // Specify a unique ID for each media item:
  //       id:index.toString(),
  //       // Metadata to display in the notification:
  //       album: "Weei Audio",
  //       title: "name",
  //      // artUri: Uri.parse(thumbnail),
  //     ),
  //   ),
  // );
  //
  // print("setuuuuup");
  // print(setup!.inMilliseconds);
  // // pr

  print("setuuuuup1"); print(dur);print("setuuuuup1");
 //  return dur;
}