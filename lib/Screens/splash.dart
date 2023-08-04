import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Admob/InterstitialAd.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';

import 'package:weei/Screens/IntoScreen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
class splashScreen extends StatefulWidget {
  const splashScreen({Key? key}) : super(key: key);

  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    createInterstitialAd();
    super.initState();
    this._loadWidget();

  }

  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Align(
          child: SvgPicture.asset(
            "assets/svg/weei.svg",
            width: ss.width * 0.4,
          ),
          alignment: Alignment.center,
        ),
        Positioned(
          bottom: ss.height * 0.18,
          left: ss.width * 0.4,
          right: ss.width * 0.4,
          child: SpinKitThreeBounce(
            color: themeClr,
            size: 20,
          ),
        )
      ]),
    );
  }

  _loadWidget() async {
    return Timer(const Duration(seconds: 3), navigationLogin);
  }

  void navigationLogin() async{

    var rmv1=await rmvSharedPrefrence(CURRENTLYINCHAT);
    var rmv2=await rmvSharedPrefrence(CURRENTCHATNME);
    // if (Platform.isAndroid) {
    //
    //   getInitainlData('android');
    // } else if (Platform.isIOS) {
    //   getInitainlData('ios');
    //
    // }

    getFirebaseUser(context);
    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (BuildContext context) => const IntroScreen()));
  }
}
