import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:weei/Helper/Const.dart';
import 'Auth/EnterNumberScreen.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';
import 'package:weei/Helper/Texts.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => EnterNumber()));
  }

  @override
  void initState() {
   getFirebaseUser(context);
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
    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        animationDuration: 3,
        dotsFlex: 5,
        globalBackgroundColor: bgClr,
        dotsDecorator: DotsDecorator(
            size: const Size.square(5.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: themeClr,
            color: const Color(0xff408056),
            spacing: const EdgeInsets.symmetric(horizontal: 5.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        pages: [
          PageViewModel(
            titleWidget: const Opacity(opacity: 0),
            bodyWidget: Column(
              children: [
                Container(child: SvgPicture.asset("assets/svg/logo.svg")),
                h(160),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text(
                    "Want to chat with your friends while watching your favorite shows or \nmovies?",
                    textAlign: TextAlign.left,
                    style: size16_600W,
                  ),
                ),
                h(34),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Row(
                    children: [
                      const Spacer(),
                      RichText(
                        text: const TextSpan(
                            text: '',
                            style: size16_600W,
                            children: [
                              TextSpan(text: 'No worries ', style: size16_600W),
                              TextSpan(text: 'Weei ', style: size16_600G),
                              TextSpan(text: 'got you', style: size16_600W)
                            ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            decoration: pageDecoration,
            bodyWidget: Column(
              children: [
                Container(child: SvgPicture.asset("assets/svg/logo.svg")),
                h(70),
                Container(child: SvgPicture.asset("assets/svg/intro1.svg")),
              ],
            ),
            titleWidget: const Opacity(opacity: 0),
          ),
          PageViewModel(
            decoration: pageDecoration,
            bodyWidget: Column(
              children: [
                Container(child: SvgPicture.asset("assets/svg/logo.svg")),
                h(160),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36),
                  child: Text("Let’s get started", style: size25_600W),
                ),
                h(34),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: RichText(
                    text:
                        const TextSpan(text: '', style: size16_600W, children: [
                      TextSpan(text: 'Now ', style: size16_600W),
                      TextSpan(text: 'Weei ', style: size16_600G),
                      TextSpan(text: 'can watch together', style: size16_600W)
                    ]),
                  ),
                ),
              ],
            ),
            titleWidget: const Opacity(opacity: 0),
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: false,
        isProgressTap: true,
        nextFlex: 0,
        isProgress: true,
        next: const Opacity(opacity: 0),
        done: Container(
          width: 110,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text('Get Started',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white)),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 13,
                )
              ],
            ),
          ),
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      ),
    );
  }
}
