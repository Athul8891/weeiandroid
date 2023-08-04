import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:just_audio/just_audio.dart';


class playVoiceNote extends StatefulWidget {
  final item;


  playVoiceNote({this.item});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<playVoiceNote> {
  final player = AudioPlayer();

  var musicPlaying=false;
  var musicDLoading=false; ///--->for intializing load
  var musicDownload=false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;


  @override
  void initState() {

  }
  void playUrl() async {

    setState(() {
    //  musicDLoading=true;
    });
    final setup = await player.setUrl(widget.item['url']);


    setState(() {
      duration = Duration(seconds: setup!.inMilliseconds);
      player.play();
      musicDLoading=false;
      musicDownload=true;
      musicPlaying=true;
    });}
  String format_Time(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }
  @override
  Widget build(BuildContext context) {
    return widget.item['message']=="false"?Container(
      child:  Row(
        children: [
          SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3
            ),
          ),

          Slider(

            min: 0, activeColor: Colors.white,
            inactiveColor: Colors.green[50],

            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged:null ,
          ),
          // Slider(
          //   activeColor: Colors.white,
          //   inactiveColor: Colors.green[50],
          //
          //   // value:position.isNaN==true || position==null? 0 : model.playerBarValue,
          //   value: position == null
          //       ? 0.0
          //       : double.parse(
          //       position.toString()),
          //   onChanged: (double? value) {
          //
          //     final position = Duration(seconds: value!.toInt());
          //
          //     print("seekrdy");
          //     if ( Duration(seconds: value!.toInt()) > (duration)) {
          //       print("velthh");
          //
          //       return;
          //     }
          //     player.seek(position);
          //   },
          //   max: duration == null
          //       ? 0.0
          //       : (double.parse(
          //       duration.toString()) +
          //       10.0),
          // ),
          SizedBox(width: 10,),
          Text("", style: size14_500W)
        ],
      ),
    ):Container(
      child:  Row(
        children: [
          musicDownload==true?IconButton(
            padding:
            EdgeInsets.zero,
            icon: musicPlaying ==
                false
                ? Icon(
              Icons
                  .play_circle_fill,
              color: Colors
                  .white,
              size: 15,
            )
                : Icon(
              Icons
                  .pause_circle_filled,
              color: Colors
                  .white,
              size: 15,
            ),
            iconSize:
            15,
            onPressed: () {
              //player.pause();

              if (musicPlaying ==
                  true) {
                setState(() {
                  player.pause();

                  musicPlaying =
                  false;
                });


              } else {
                player.play();
                setState(() {
                  musicPlaying =
                  true;
                });

              }
            },
            splashColor:
            Colors.transparent,
          ):Container(child: musicDLoading==false?IconButton(
            padding:
            EdgeInsets.zero,
            icon: Icon(
              Icons
                  .play_circle_fill,
              color: Colors
                  .white,
              size: 15,
            )  ,
            iconSize:
            15,
            onPressed: () {

              setState(() {
                musicDLoading=true;
              });

              playUrl();
              //player.pause();

            },
            splashColor:
            Colors.transparent,
          ):SizedBox(
    height: 15,
    width: 15,
    child: CircularProgressIndicator(
    color: Colors.white,
    strokeWidth: 3
    ),
    ),),

          Slider(

            min: 0, activeColor: Colors.white,
            inactiveColor: Colors.green[50],

            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (double? value) {


              final position = Duration(seconds: value!.toInt());

              print("seekrdy");
              if ( Duration(seconds: value!.toInt()) > (duration)) {
                print("velthh");

                return;
              }
              player.seek(position);

              player.play();
            },
          ),
          // Slider(
          //   activeColor: Colors.white,
          //   inactiveColor: Colors.green[50],
          //
          //   // value:position.isNaN==true || position==null? 0 : model.playerBarValue,
          //   value: position == null
          //       ? 0.0
          //       : double.parse(
          //       position.toString()),
          //   onChanged: (double? value) {
          //
          //     final position = Duration(seconds: value!.toInt());
          //
          //     print("seekrdy");
          //     if ( Duration(seconds: value!.toInt()) > (duration)) {
          //       print("velthh");
          //
          //       return;
          //     }
          //     player.seek(position);
          //   },
          //   max: duration == null
          //       ? 0.0
          //       : (double.parse(
          //       duration.toString()) +
          //       10.0),
          // ),
          SizedBox(width: 10,),
          Text(musicPlaying==true?format_Time(position.inSeconds).toString():widget.item['sec'].toString(), style: size14_500W)
        ],
      ),
    );
  }


}
