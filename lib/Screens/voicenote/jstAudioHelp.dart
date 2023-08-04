import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';


class jsHlp extends StatefulWidget {


  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<jsHlp> {
  final player = AudioPlayer();


  getDuration(path,index)async{


    final setup = await player.setAudioSource(
      AudioSource.uri(
        Uri.parse("asset:///"+path),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id:index.toString(),
          // Metadata to display in the notification:
          album: "Weei Audio",
          title: "name",
         // artUri: Uri.parse(thumbnail),
        ),
      ),
    );

    print("setuuuuup");
    print(setup!.inMilliseconds);
    // pr


    //  return dur;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgClr,

      child: Center(child: CircularProgressIndicator(color: themeClr,))
      ,
    );
  }


}
