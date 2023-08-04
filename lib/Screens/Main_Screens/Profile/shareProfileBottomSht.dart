import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weei/Helper/Const.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/SentWidget.dart';
import 'package:weei/Helper/fwdSentWidget.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Screens/Main_Screens/Library/SentWidgetMedia.dart';
import 'package:weei/Screens/Main_Screens/Profile/SentWidgetShareProf.dart';


PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

int a =2;
final FirebaseAuth auth = FirebaseAuth.instance;
void  shareProfileBottom(BuildContext context,   sendingData) {




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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 1),
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       Container(
        //         height: 60,
        //         decoration: const BoxDecoration(
        //           borderRadius:
        //           BorderRadius.vertical(top: Radius.circular(20.0)),
        //         ),
        //         alignment: Alignment.centerLeft,
        //         child: Padding(
        //           padding: const EdgeInsets.only(top: 10,left: 10),
        //           child: Row(
        //             children: [
        //                Text("Share", style: size18_500W),
        //               SizedBox(width: 10,),
        //               Icon(
        //                 CupertinoIcons.location_fill,
        //                 size: 15,
        //                 color: Colors.white,
        //               ),
        //                Spacer(),
        //               IconButton(
        //                   icon: const Icon(
        //                     CupertinoIcons.clear_circled_solid,
        //                     color: Color(0xff363636),
        //                   ),
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   })
        //             ],
        //           ),
        //         ),
        //       ),
        //       const Divider(color: Color(0xff404040), thickness: 1),
        //
        //       Scrollbar(
        //         child: PaginateFirestore(
        //
        //           // Use SliverAppBar in header to make it sticky
        //           // header: SliverToBoxAdapter(child: Text('HEADER')),
        //           // footer: SliverToBoxAdapter(child: Text('FOOTER')),
        //           // item builder type is compulsory.
        //           // separator: Padding(
        //           //   padding: EdgeInsets.symmetric(vertical: 8),
        //           //   child: Divider(color: Color(0xff404040), thickness: 1),
        //           // ),
        //           reverse: true,
        //           key: ValueKey(dropdownvalue),
        //           shrinkWrap: true,
        //           itemBuilderType:
        //           PaginateBuilderType.listView,
        //
        //           // Change types accordingly
        //           itemBuilder: (context, documentSnapshots, index) {
        //             final data = documentSnapshots[index].data() as Map?;
        //             return data!=null ?chatList(documentSnapshots[index].id,data,index, mediaType, mediaData):Container(  child: Center(child: Text("No Freinds Found!"),),);
        //           },
        //           // orderBy is compulsory to enable pagination
        //           query: FirebaseFirestore.instance.collection('Friend').doc(auth.currentUser!.uid).collection(auth.currentUser!.uid).where('accepted',isEqualTo:true).where('blocked',isEqualTo:false),
        //           // to fetch real-time data
        //           listeners: [
        //             refreshChangeListener,
        //           ],
        //
        //           isLive: true,
        //         ),
        //       ),
        //       h(5),
        //       // Row(
        //       //   children: [
        //       //     Expanded(
        //       //       child: Container(
        //       //         height: 40,
        //       //         decoration: BoxDecoration(
        //       //             color: const Color(0xff333333),
        //       //             borderRadius: BorderRadius.circular(10)),
        //       //         child: Padding(
        //       //           padding:
        //       //           const EdgeInsets.symmetric(horizontal: 20),
        //       //           child: TextFormField(
        //       //             cursorColor: Colors.white,
        //       //             autofocus: false,
        //       //             style: size14_600W,
        //       //             decoration: const InputDecoration(
        //       //               border: InputBorder.none,
        //       //               hintStyle: size14_500Grey,
        //       //               hintText: "Type your message here",
        //       //               focusedBorder: InputBorder.none,
        //       //               enabledBorder: InputBorder.none,
        //       //               errorBorder: InputBorder.none,
        //       //               disabledBorder: InputBorder.none,
        //       //             ),
        //       //           ),
        //       //         ),
        //       //       ),
        //       //     ),
        //       //     w(9),
        //       //     Container(
        //       //       alignment: Alignment.center,
        //       //       height: 40,
        //       //       decoration: BoxDecoration(
        //       //           borderRadius: BorderRadius.circular(10),
        //       //           color: themeClr),
        //       //       child: const Padding(
        //       //         padding: EdgeInsets.symmetric(horizontal: 20),
        //       //         child: Text("Send", style: size14_600W),
        //       //       ),
        //       //     )
        //       //   ],
        //       // ),
        //       // Padding(
        //       //   padding: EdgeInsets.only(
        //       //       bottom: MediaQuery.of(context).viewInsets.bottom,
        //       //       top: 10),
        //       // ),
        //     ],
        //   ),
        // ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 18,),
              Text("Send To", style: size14_600W),
              div(),
              Scrollbar(
                child:PaginateFirestore(
                  // Use SliverAppBar in header to make it sticky
                  // header: SliverToBoxAdapter(child: Text('HEADER')),
                  // footer: SliverToBoxAdapter(child: Text('FOOTER')),
                  // item builder type is compulsory.
                  // separator: Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8),
                  //   child: Divider(color: Color(0xff404040), thickness: 1),
                  // ),
                  reverse: true,
                  key: ValueKey(dropdownvalue),
                  shrinkWrap: true,
                  onEmpty: emptyList(),
                  itemBuilderType: PaginateBuilderType.listView,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65),
                  // Change types accordingly
                  itemBuilder: (context, documentSnapshots, index) {
                    final data = documentSnapshots[index].data() as Map?;

                    print("dataaa");
                    return data != null
                        ? chatListNew(documentSnapshots[index].id,data,index, sendingData)
                        : Container(
                      child: const Center(
                        child: Text("No Friends Found!", style: size14_600W),
                      ),
                    );
                  },
                  // orderBy is compulsory to enable pagination
                  // query: FirebaseFirestore.instance.collection('Friends').doc(auth.currentUser!.uid).collection(auth.currentUser!.uid).orderBy("lastMessageTime", descending: true),
                  query: FirebaseFirestore.instance
                      .collection('Chat')
                      .where('uIds', arrayContains: auth.currentUser!.uid)
                      .where('startChat', isEqualTo: true)
                      .where('blocked', isEqualTo: false)
                      .orderBy("stamp", descending: false),
                  // to fetch real-time data
                  listeners: [
                    refreshChangeListener,
                  ],

                  isLive: true,
                ),
              ),
              h(5),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 40,
              //         decoration: BoxDecoration(
              //             color: const Color(0xff333333),
              //             borderRadius: BorderRadius.circular(10)),
              //         child: Padding(
              //           padding:
              //           const EdgeInsets.symmetric(horizontal: 20),
              //           child: TextFormField(
              //             cursorColor: Colors.white,
              //             autofocus: false,
              //             style: size14_600W,
              //             decoration: const InputDecoration(
              //               border: InputBorder.none,
              //               hintStyle: size14_500Grey,
              //               hintText: "Type your message here",
              //               focusedBorder: InputBorder.none,
              //               enabledBorder: InputBorder.none,
              //               errorBorder: InputBorder.none,
              //               disabledBorder: InputBorder.none,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     w(9),
              //     Container(
              //       alignment: Alignment.center,
              //       height: 40,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           color: themeClr),
              //       child: const Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 20),
              //         child: Text("Send", style: size14_600W),
              //       ),
              //     )
              //   ],
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       bottom: MediaQuery.of(context).viewInsets.bottom,
              //       top: 10),
              // ),
            ],
          ),
        ),
      ]));




}
Widget emptyList() {
  return Container( height:150,child: Column(
    //    crossAxisAlignment: CrossAxisAlignment.center,
    // mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Text("No recent conversations found.", style: size13_600W),
      SizedBox(height: 15,),






    ],),);

}

chatListNew(var docId,var item, int index, sendingData) {
  var hisId = auth.currentUser!.uid == item['uIds'][0]
      ? item['uIds'][1]
      : item['uIds'][0];
  print("hisId");
  print(hisId);
  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(left: 5,right: 5),
        child: ListTile(
          visualDensity: VisualDensity(vertical: -3),
          title:  Text(item[hisId]['name'].toString(), style: size14_600WT,maxLines: 1,),
          subtitle:  Text(item[hisId]['username'].toString(), style: size14_500Grey,maxLines: 1,),
          leading:  Container(
            height: 40,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
              MemoryImage(dataFromBase64String(item[hisId]['profile'])),
              //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
            ),
            width: 40,
          ),
          trailing:SentWidgetProfileShare(path: item['messagePath'],sendData: sendingData,partnerData: item[hisId], ),
          //  trailing: CupertinoSwitch(value: true, onChanged: (v) {}),
          contentPadding: EdgeInsets.zero,
        ),
      ),

      // div()
    ],
  );
}
div() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
    child: Divider(color: Color(0xff404040), thickness: 1),
  );
}