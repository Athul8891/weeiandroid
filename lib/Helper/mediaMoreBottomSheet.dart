import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/addToPlaylistBottom.dart';
import 'package:weei/Screens/Main_Screens/Library/sendMediaToFriends.dart';
import 'package:weei/Screens/Upload/Data/deleteFileApi.dart';

// moreMediaBottomSheet(context,type,item) {
//
//   return showModalBottomSheet(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       backgroundColor: const Color(0xff4F4F4F),
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return StatefulBuilder(builder: (BuildContext context,
//             StateSetter setState /*You can rename this!*/) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
//             child: Row(
//               children: [
//                 // Expanded(
//                 //   child: TextButton(
//                 //     onPressed: () async {
//                 //       addToPlayListBottom( context, type,item);
//                 //     },
//                 //     child: Text(
//                 //       'Add',
//                 //       style: size14_600W,
//                 //     ),
//                 //   ),
//                 // ),
//                 // Spacer(),
//                 SizedBox(width: 15,),
//                 Expanded(
//                   child:    TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//
//
//                       sendMediaToFriendBottom(context, (type=="VIDEO"?"FILEVIDEO":"FILEMUSIC"), item);
//                     },
//                     child: Text(
//                       'Share',
//                       style: size14_600W,
//                     ),
//                   ),
//                 ),
//
//                 Spacer(),
//
//                 Expanded(
//                   child:        TextButton(
//                     onPressed: ()async {
//
//                       deletePlyListAlert( context,item);
//                     },
//                     child: Text(
//                       'Delete',
//                       style: size14_600R,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 15,),
//
//               ],
//             ),
//           );
//         });
//       });
//
//
//
//
// }

div() {
  return  Divider(color: Color(0xff404040), thickness: 1);
}

moreMediaBottomSheet(context,type,item) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: liteBlack,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Container(
                //   height: 40,
                //   child: TextButton(
                //     onPressed: () async {
                //       Navigator.pop(context);
                //
                //       sendMediaToFriendBottom(context, (type=="VIDEO"?"FILEVIDEO":"FILEMUSIC"), item);
                //     },
                //     child: Text("Send",
                //       style: size14_600W,
                //     ),
                //   ),
                // ),
                //div(),
                Container(
                  height: 40,
                  child: TextButton(

                    onPressed: () {
                      Navigator.pop(context);

                      deletePlyListAlert( context,item);
                    },
                    child: Text(
                      'Delete',
                      style: size14_600W,
                    ),
                  ),
                ),
                div(),
                Container(
                  height: 40,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);


                    },
                    child: Text(
                      'Cancel',
                      style: size14_600W,
                    ),
                  ),
                ),


              ],
            ),
          );
        });
      });
}

void deletePlyListAlert(BuildContext context,item) {




  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';
  var onSubmit = false;
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: liteBlack,
      context: context,
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
                    Text("Confirm delete?", style: size14_600W),
                    Spacer(),

                  ],
                ),

                //  const Text("This will close the room and \n joins will be exited .", style: size14_500Grey),
                h(35),
                Row(
                  children: [
                    Expanded(
                      child: buttons("Confirm", const Color(0xff333333), ()async {


                        Navigator.pop(context);
                        var rsp = await deleteFileApi(item['fileId'],item['fileSize']);

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
                )
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