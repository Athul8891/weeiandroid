import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';

class updateAlertBox extends StatefulWidget {
  const updateAlertBox({Key? key}) : super(key: key);

  @override
  _updateAlertBoxState createState() => _updateAlertBoxState();
}

class _updateAlertBoxState extends State<updateAlertBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: liteBlack),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text("Update available", style: size14_600W),
                Spacer(),
                Text("v 2.3.0.1", style: size12_400grey),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: Color(0xff404040), thickness: 1),
            ),
            const Text("Minor bug fixes", style: size14_500Grey),
            h(25),
            Row(
              children: [
                Expanded(
                  child: buttons("Later", const Color(0xff333333), () {}),
                ),
                w(10),
                Expanded(
                  child: buttons("Update", themeClr, () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const UpgradeScreen()),
                    // );
                  }),
                ),
              ],
            )
          ],
        ),
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
