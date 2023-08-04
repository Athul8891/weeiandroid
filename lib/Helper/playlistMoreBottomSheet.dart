import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/addToPlaylistBottom.dart';
import 'package:weei/Screens/Main_Screens/Library/sendMediaToFriends.dart';
import 'package:weei/Screens/Upload/Data/deleteFileApi.dart';

// morePlaylistBottomSheet(context,type,item,path) {
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
//                       databaseReference.child(path).remove();
//                          Navigator.pop(context);
//                     },
//                     child: Text(
//                       'Remove',
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
// }

morePlaylistBottomSheet(context,type,item,path) {
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
            //     Container(
            //       height: 40,
            //       child: TextButton(
            //         onPressed: () async {
            //           Navigator.pop(context);
            //
            //           sendMediaToFriendBottom(context, (type=="VIDEO"?"FILEVIDEO":"FILEMUSIC"), item);
            //
            //         },
            //         child: Text("Send",
            //           style: size14_600W,
            //         ),
            //       ),
            //     ),
            // Divider(color: Color(0xff404040), thickness: 1),
                Container(
                  height: 40,
                  child: TextButton(

                    onPressed: () {
                      Navigator.pop(context);

                      databaseReference.child(path).remove();

                    },
                    child: Text(
                      'Remove',
                      style: size14_600R,
                    ),
                  ),
                ),
          Divider(color: Color(0xff404040), thickness: 1),
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