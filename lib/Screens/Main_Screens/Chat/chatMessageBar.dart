import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shimmer/shimmer.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendNotificationApi.dart';

import 'package:weei/Screens/VideoSession/Data/sendMessageInSession.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ChatMessageBar extends StatefulWidget {
  final width;
  final chatPath;
  final friendUid;
  final friendData;
  final startTime;

  ChatMessageBar({this.width,this.chatPath,this.friendUid,this.friendData,this.startTime});


  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<ChatMessageBar> {

  final player = AudioPlayer();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  var  showMic = false;
  var  isRecording = false;
  var  deleteHighlight = false;
  var audioPath;
  var stopWatchTime =0;
  final record = Record();
  var keyBoardLength =0;

  TextEditingController messageController = TextEditingController();

  stopAndPlayNote()async{
    await Record().stop();
    ///play audio
    // AudioPlayer audioPlayer = AudioPlayer(
    //   mode: PlayerMode.MEDIA_PLAYER,
    // );
    // int result = await audioPlayer.play(audioPath,
    //  isLocal: true, stayAwake: true);
    print('doSomething() executed in ${stopWatchTime}');
    // Stop timer.
    _stopWatchTimer.onStopTimer();


// Reset timer
    _stopWatchTimer.onResetTimer();
    print("audioPathhh");
    print(audioPath);
    // final setup = await player.setUrl("https://firebasestorage.googleapis.com/v0/b/weei-a1903.appspot.com/o/voicenotes%2F2023-02-23T15%3A12%3A48.469074EZypBJHwk4MtztMyuvMjCxwNWIh1?alt=media&token=8116a9ec-5028-48da-8dcc-347da5135c2f");
    // player.play();
    sendMeassageToFriend(
        widget.chatPath,
        "Voice message 🎤",
        VOICENOTE,
        widget.friendUid,
        widget.friendData,audioPath,widget.startTime);

    if(widget.friendData['fcmToken'].toString()!="null"&&widget.friendData['sendNoti'].toString()!="false"){
      var name= await getSharedPrefrence(UNAME);
      sendPushMessage( "Voice message 🎤",  name,  widget.friendData['fcmToken'].toString());
    }
    setState(() {
      showMic = false;
      isRecording = false;
      stopWatchTime=0;
    });



  }

  @override
  Widget build(BuildContext context) {
    return    Container(
      margin: EdgeInsets.only(bottom: 7,left: 3,right: 3),
      child: Row(
        children: [
          showMic==false?Expanded(
            child: Container(
              height: 40,

              decoration: BoxDecoration(
                  color: const Color(0xff333333),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: messageController,
                  onChanged: (val){
                    setState(() {
                      keyBoardLength= val.length;
                    });
                  },
                  cursorColor: Colors.white,
                  autofocus: false,
                  style: size14_600W,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintStyle: size14_500Grey,
                    hintText: "Type your message here",
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ):Expanded(
            child: Row(children: [

           Icon(
                     Icons.delete,
                    size: deleteHighlight==false?27:37,
                    color: deleteHighlight==false?Colors.white:Colors.red,
                  ),


               SizedBox(width: 10,),


        Container(
                  height: 40,
                  // width: (widget.width -100),

                  // decoration: BoxDecoration(
                  //     color: const Color(0xff333333),
                  //     borderRadius: BorderRadius.circular(10)),

                    child: Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Recording 00:'+stopWatchTime.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic,
                            // fontWeight:
                            // FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                ),


            ],),
          ),
          w(9),

          keyBoardLength==0?Container(
            height: 40,
            width: 50,
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10), color: themeClr),
            //width: 50,
           padding: EdgeInsets.only(top: 0, bottom: 0, left: 5, right: 0),
            child: LongPressDraggable(

              child:  RawMaterialButton(
                onPressed:() {},
                elevation: 2.0,
                fillColor:themeClr,
                child: Icon(Icons.mic, color: Colors.white ,),
               // padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
              onDragStarted: () async {
               // widget.videoController.setVolume(0.5);
                print("staaaaaaaaaaaart");


                setState(() {
                  showMic = true;
                  isRecording = true;

                });
                bool result = await Record().hasPermission();
                if (result) {
                  Directory tempDir = await getTemporaryDirectory();
                  File filePath = File('${tempDir.path}/audio.wav');
                  audioPath = filePath.path;

                  _stopWatchTimer.onStartTimer();



                    _stopWatchTimer.secondTime.listen((value) {

                      if(showMic==true){
                        print('okk kanik $value');
                        setState(() {

                          if(value<10){

                            var plus = "0"+value.toString();
                            stopWatchTime =int.parse(plus.toString());
                          }else{
                            stopWatchTime=value;

                          }

                        });

                        if(value>60){
                          showToastSuccess("Limit reached!");
                          stopAndPlayNote();
                        }
                      }else{
//                         _stopWatchTimer.onStopTimer();
//
//
// // Reset timer

                      }


                    });





                  await Record().start(
                    path: filePath.path,
                   // required:
                     encoder: AudioEncoder.aacHe, // by default
                    // bitRate: 128000, // by default
                    // samplingRate: 44100, // by default

                    bitRate: 128000, // by default
                    samplingRate: 182000, //
                  );


                }
              },
              onDragUpdate: (a){
                // print("stooop1");
                // print(a.delta.dx);
                // print(a.globalPosition.dx);
                // print(a.localPosition.dx);
                // print(a.primaryDelta);
                if(a.globalPosition.dx<widget.width-widget.width/5||a.globalPosition.dx<0){
                  setState(() {

                    deleteHighlight = true;
                  });
                    print("kathikooo");
                 // showToastSuccess("Record removed!");

                }else{
                  setState(() {
                    print("offaakk");

                    deleteHighlight = false;
                  });
                }
              },
              onDragEnd: (a) async {



                print("stooop2");
                print(widget.width-widget.width/5);
                print(a.offset.dx);


                if(a.offset.dx<widget.width-widget.width/5||a.offset.dx<0){
                  setState(() {
                    showMic = false;
                    isRecording = false;
                    deleteHighlight = false;
                    stopWatchTime=0;
                  });
                  _stopWatchTimer.onStopTimer();


// Reset timer
                  _stopWatchTimer.onResetTimer();
                  showToastSuccess("Record removed!");

                }else{
                  stopAndPlayNote();
                }

                // if(a.offset.dx<widget.width-widget.width/5){
                //   await Record().stop();
                //   ///play audio
                //   // AudioPlayer audioPlayer = AudioPlayer(
                //   //   mode: PlayerMode.MEDIA_PLAYER,
                //   // );
                //   // int result = await audioPlayer.play(audioPath,
                //   //  isLocal: true, stayAwake: true);
                //   print('doSomething() executed in ${stopWatchTime}');
                //   print("audioPathhh");
                //   print(audioPath);
                //   final setup = await player.setFilePath(audioPath);
                //   player.play();
                //   stopwatch.stop();
                //   stopwatch.reset();
                //   setState(() {
                //     showMic = false;
                //     isRecording = false;
                //   });
                //
                // }else{
                //   setState(() {
                //     showMic = false;
                //     isRecording = false;
                //   });
                //
                //   showToastSuccess("Record removed!");
                //
                // }

              },
              feedback: Icon(
                Icons.record_voice_over,
                size: 30,
                color: Colors.white,
              ),
            ),
          ):GestureDetector(
            onTap: ()async{

              //  FocusManager.instance.primaryFocus?.unfocus();

              sendMeassageToFriend(
                  widget. chatPath,
                  messageController.text.trim(),
                  "TEXT",
                  widget.friendUid,
                  widget.friendData,"",widget.startTime);

              if(widget.friendData['fcmToken'].toString()!="null"&&widget.friendData['sendNoti'].toString()!="false"){
                var name= await getSharedPrefrence(UNAME);
                sendPushMessage( messageController.text.trim(),  name,  widget.friendData['fcmToken'].toString());
              }
              setState(() {


                messageController.clear();
                setState(() {
                  keyBoardLength=0;
                });

              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: themeClr),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("Send", style: size14_600W),
              ),
            ),
          )
        ],
      ),
    );

        Container(
      height: 70,
      width: widget.width,
      padding: EdgeInsets.only(top: 0, bottom: 12, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment:CrossAxisAlignment.end,
        children: [
          LongPressDraggable(

            child: Icon(
              Icons.mic,
              size: 30,
              color: Colors.black54,
            ),
            onDragStarted: () async {

             print("staaaaaaaaaaaart");



              setState(() {
                showMic = true;
              });
              isRecording = true;
              bool result = await Record().hasPermission();
              if (result) {
                Directory tempDir = await getTemporaryDirectory();
                File filePath = File('${tempDir.path}/audio.wav');
                 audioPath = filePath.path;
            //    stopwatch.start();



                //stopWatchTime=stopwatch.elapsed.inSeconds;
                print('doSomething() executed in ${stopWatchTime}');
                await Record().start(
                  path: filePath.path, // required
                 // encoder: AudioEncoder.wav, // by default
                  bitRate: 128000, // by default
                  samplingRate: 44100, // by default
                );
              }
            },
            onDragEnd: (a) async {

              print("stooop");
              print(widget.width-widget.width/5);
              print(a.offset.dx);


              if(a.offset.dx<widget.width-widget.width/5||a.offset.dx<0){
                setState(() {
                  showMic = false;
                  isRecording = false;
                });

                showToastSuccess("Record removed!");
              }else{
                await Record().stop();
                ///play audio
                // AudioPlayer audioPlayer = AudioPlayer(
                //   mode: PlayerMode.MEDIA_PLAYER,
                // );
                // int result = await audioPlayer.play(audioPath,
                //  isLocal: true, stayAwake: true);
                print('doSomething() executed in ${stopWatchTime}');
                print("audioPathhh");
                print(audioPath);
                final setup = await player.setFilePath(audioPath);
                player.play();
                // stopwatch.stop();
                // stopwatch.reset();
                setState(() {
                  showMic = false;
                  isRecording = false;
                });

              }

              // if(a.offset.dx<widget.width-widget.width/5){
              //   await Record().stop();
              //   ///play audio
              //   // AudioPlayer audioPlayer = AudioPlayer(
              //   //   mode: PlayerMode.MEDIA_PLAYER,
              //   // );
              //   // int result = await audioPlayer.play(audioPath,
              //   //  isLocal: true, stayAwake: true);
              //   print('doSomething() executed in ${stopWatchTime}');
              //   print("audioPathhh");
              //   print(audioPath);
              //   final setup = await player.setFilePath(audioPath);
              //   player.play();
              //   stopwatch.stop();
              //   stopwatch.reset();
              //   setState(() {
              //     showMic = false;
              //     isRecording = false;
              //   });
              //
              // }else{
              //   setState(() {
              //     showMic = false;
              //     isRecording = false;
              //   });
              //
              //   showToastSuccess("Record removed!");
              //
              // }

            },
            feedback: Icon(
              Icons.delete,
              size: 30,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }


}
