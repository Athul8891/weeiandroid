import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:weei/Helper/Const.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerScreen.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen2.dart';
import 'package:just_audio/just_audio.dart';

class WaitingScreen extends StatefulWidget {
  final id;
  final type;
  final channelType;
  WaitingScreen({this.id,this.type,this.channelType});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<WaitingScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (_) => EnterNumber()));
  }

  @override
  void initState() {

    Future.delayed(const Duration(seconds: 1), () {

// Here you can write your code
      listenDataFromFireBase();
      setState(() {
        // Here you can write your code for open new view
      });

    });

  }

  Future<bool> _onBackPressed() async {
    bool goBack = false;
    HapticFeedback.mediumImpact();
    roomExitJoinAlert( context,widget.id,auth.currentUser!.uid);
    return goBack;
  }
  listenDataFromFireBase() {

    var db = FirebaseDatabase.instance.reference();
    db.child('channel').child(widget.id.toString()+"/joins").child(auth.currentUser!.uid).onChildChanged.listen((data) {




      switch (data.snapshot.key.toString()) {
        case "status":
        // do something

          var rsp = data.snapshot.value.toString();

           if(rsp=="true"){
             if(widget.channelType=="VIDEO"){
               NavigatePageRelace(context, VideoPlayerScreen2(id: widget.id,type: "JOIN"));
                    return;
             }

             if(widget.channelType=="AUDIO"){
               NavigatePageRelace(context, audioPlayerScreen(id:  widget.id,type: "JOIN",concatenatingAudioSource:ConcatenatingAudioSource(children: [])));
               return;

             }

             if(widget.channelType=="YTVIDEO"){
               NavigatePageRelace(context, VideoPlayerScreen2(id:  widget.id,type: "JOIN"));
               return;

             }
             if(widget.channelType=="YTAUDIO"){
               NavigatePageRelace(context, audioPlayerScreen(id:  widget.id,type: "JOIN",concatenatingAudioSource:ConcatenatingAudioSource(children: [])));
               return;

             }
           }
          if(rsp=="exit"){
            showToastSuccess("Creator declined your request!");
            Navigator.pop(context);
          }

          break;





      }


    });


  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );
    const pageDecoration = PageDecoration(
      bodyAlignment: Alignment.center,
      contentMargin: EdgeInsets.zero,
      bodyFlex: 0,
      bodyPadding: EdgeInsets.all(0),
      pageColor: bgClr,
      imageAlignment: Alignment.center,
    );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: GestureDetector(
          onTap: (){
            roomExitJoinAlert( context,widget.id,auth.currentUser!.uid);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: themeClr),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  SizedBox(width: 15,),
                  Icon(Icons.arrow_back_ios, color: Colors.white ,size: 15,),
                  SizedBox(width: 15,),
                  Text("Exit Room", style: size14_600W),
                  Spacer(),

                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(child: SvgPicture.asset("assets/svg/logo.svg")),
            h(160),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                "Waiting for the session creator approval !",
                textAlign: TextAlign.left,
                style: size16_600W,
              ),
            ),
            h(34),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 36),
            //   child: Row(
            //     children: [
            //       const Spacer(),
            //       RichText(
            //         text: const TextSpan(
            //             text: '',
            //             style: size16_600W,
            //             children: [
            //               TextSpan(text: 'No worries ', style: size16_600W),
            //               TextSpan(text: 'Weei ', style: size16_600G),
            //               TextSpan(text: 'got you', style: size16_600W)
            //             ]),
            //       ),
            //     ],
            //   ),
            // ),
            h(30),
            SpinKitRing(
              color: themeClr,
              size: 20.0,
              lineWidth: 2.0,
            ),
            h(5),


            BannerAds(),
          ],
        ),
      ),
    );
  }
}
