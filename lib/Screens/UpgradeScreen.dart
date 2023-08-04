import 'package:flutter/material.dart';
import 'package:flutter_balloon_slider/flutter_balloon_slider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({Key? key}) : super(key: key);

  @override
  _UpgradeScreenState createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  void add() {
    setState(() {
      _n++;
    });
  }

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  int _n = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            )),
        centerTitle: true,
        title: const Text("Upgrade", style: size16_600W),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            circleIndicator(),
            h(MediaQuery.of(context).size.height * 0.1),
            incDecrement(),
            slider()
          ],
        ),
      ),
      bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: buttons(rs + "699", grey, () {}),
              ),
              w(10),
              Expanded(
                child: buttons("Upgrade", themeClr, () {}),
              )
            ],
          )),
    );
  }

  Widget circleIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          CircularStepProgressIndicator(
            totalSteps: 100,
            currentStep: 13,
            stepSize: 10,
            removeRoundedCapExtraAngle: true,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("13.46%", style: size20_500W),
                Text("used", style: size14_500Grey),
              ],
            )),
            selectedColor: themeClr,
            unselectedColor: liteBlack,
            padding: 0,
            width: 150,
            height: 150,
            selectedStepSize: 10,
          ),
          w(35),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Free", style: size14_500Grey),
                  w(10),
                  const Text("844.50 MB", style: size14_600Grey),
                ],
              ),
              h(10),
              Row(
                children: [
                  const Text("Used", style: size14_500Grey),
                  w(10),
                  const Text("133.50 MB", style: size14_600Grey),
                ],
              ),
              h(10),
              Row(
                children: [
                  const Text("Total", style: size14_500Grey),
                  w(10),
                  const Text("1 GB", style: size14_600Grey),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  incDecrement() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: liteBlack,
      ),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: GestureDetector(
              onTap: () {
                minus();
              },
              child: const Icon(
                Icons.remove,
                size: 25,
                color: grey,
              ),
            ),
          ),
          Text('$_n' + ' GB', style: size16_600W),
          SizedBox(
            height: 20,
            width: 20,
            child: GestureDetector(
              onTap: () {
                add();
              },
              child: const Icon(Icons.add, size: 25, color: grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget slider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
      child: Column(
        children: [
          BalloonSlider(
              value: 0.5,
              ropeLength: 100,
              showRope: true,
              onChangeStart: (val) {},
              onChanged: (val) {},
              onChangeEnd: (val) {},
              color: const Color(0xff5484FF)),
          Row(
            children: const [
              Text("5 GB", style: size14_500Grey),
              Spacer(),
              Text("100 GB", style: size14_500Grey),
            ],
          )
        ],
      ),
    );
  }

  buttons(String txt, Color clr, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(10), color: clr),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(txt, style: size14_600W),
        ),
      ),
    );
  }
}
