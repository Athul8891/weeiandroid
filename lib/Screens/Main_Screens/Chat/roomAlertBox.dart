import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Friends/Data/removeContact.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/verifyMessagePathNew.dart';
import '../../Friends/Data/blockContact.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/clearMessages.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

// void roomAlert(BuildContext context,type,path,myid,partnerId,friendData,pagename) {
//
//
//
//   ProgressDialog pd = ProgressDialog(context: context);
//
//   // DatabaseReference reference =
//   // FirebaseDatabase.instance.reference().child('channel');
//
//   String dropdownvalue = 'All';
//   var onSubmit = false;
//   showModalBottomSheet(
//       shape: const RoundedRectangleBorder(
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: liteBlack,
//       context: context,
//       // isScrollControlled: true,
//       builder: (context) => Stack(children: [
//         type=="BLOCK"? Container(
//           height: 210,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20), color: liteBlack),
//           child: Padding(
//             padding: const EdgeInsets.all(25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//               ],
//             ),
//           ),
//         ): type=="REMOVE"? Container(
//           height: 210,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20), color: liteBlack),
//           child: Padding(
//             padding: const EdgeInsets.all(25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//               ],
//             ),
//           ),
//         ): Container(
//           height: 210,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20), color: liteBlack),
//           child: Padding(
//             padding: const EdgeInsets.all(25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//               ],
//             ),
//           ),
//         ),
//       ]));
//
//
//
//
// }
roomAlert(BuildContext context,type,path,myid,partnerId,friendData,pagename) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: liteBlack,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return type=="BLOCK"?Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: const [
                    Text("Block this person", style: size14_600W),
                    Spacer(),

                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xff404040), thickness: 1),
                ),
                const Text("This person no longer can message after block!", style: size14_500Grey),
                h(25),
                Row(
                  children: [
                    Expanded(
                      child: buttons("Confirm", const Color(0xff333333), ()async {

                        if(pagename=="userprof"){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }else{
                          Navigator.pop(context);

                        }

                        var rsp = await blockUser(path,myid);



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
                h(2),
                BannerAds(),
              ],
            ),
          )  : type=="REMOVE"?       Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                Row(
                  children: const [
                    Text("Remove this person", style: size14_600W),
                    Spacer(),

                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xff404040), thickness: 1),
                ),
                const Text("This will clear chats and \nremove this person from chat.", style: size14_500Grey),
                h(25),
                Row(
                  children: [
                    Expanded(
                      child: buttons("Confirm", const Color(0xff333333), ()async {


                        if(pagename=="userprof"){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }else{
                          Navigator.pop(context);

                        }

                        var rsp = await deleteRquest(path);

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
                h(2),
                BannerAds(),
              ],
            ),
          )      :   Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: const [
                    Text("Clear this chat ?", style: size14_600W),
                    Spacer(),

                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xff404040), thickness: 1),
                ),
                const Text("This will clear all the existing\n chats between this person.", style: size14_500Grey),

                h(25),
                Row(
                  children: [
                    Expanded(
                      child: buttons("Confirm", const Color(0xff333333), () async{
                        //  pd.show(max: 100, msg: "Clearing..");

                        if(pagename=="userprof"){
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }else{
                          Navigator.pop(context);

                        }
                        //  Navigator.pop(context);

                        var rsp = await clearChat(path,myid,friendData['uid'],friendData);


                      }),
                    ),
                    w(10),
                    Expanded(
                      child: buttons("Cancel", themeClr, () {
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
                h(2),
                BannerAds(),
              ],
            ),
          );
        });
      });
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

