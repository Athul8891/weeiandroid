import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Friends/Data/removeContact.dart';
import 'package:weei/Screens/VideoSession/Data/acceptOrDeclne.dart';

import 'package:weei/Screens/Main_Screens/Chat/Data/clearMessages.dart';

void roomExitAlertNav(BuildContext ctx,code,uid) {




  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';
  var onSubmit = false;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: liteBlack,
      context: ctx,
      // isScrollControlled: true,
      builder: (context) => Stack(children: [
        Container(

          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: liteBlack),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Text("Confirm exit?", style: size14_600W),
                    Spacer(),

                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xff404040), thickness: 1),
                ),
              const Text("This will close the room and \n joins will be exited .", style: size14_500Grey),
                h(25),
                Row(
                  children: [
                    Expanded(
                      child: buttons("Confirm", const Color(0xff333333), ()async {
                   var rsp = await     closeTheRoom(code,ctx);

                   var rmv = await rmvSharedPrefrence(LASTROOM);
                   Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                      }),
                    ),
                    w(10),
                    Expanded(
                      child: buttons("Cancel", themeClr, () async{

                        Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const UpgradeScreen()),
                        // );
                      }),
                    ),
                  ],
                ),
                h(3),

                BannerAds(),
              ],
            ),
          ),
        ),
      ]));




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

