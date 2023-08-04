import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weei/Helper/Const.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/SentWidget.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/sessionInviteSentWidget.dart';

import 'package:flutter_share/flutter_share.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';

PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

int a =2;
final FirebaseAuth auth = FirebaseAuth.instance;
void friendBottomInvite(BuildContext context,roomId) {


  FlutterShare.share(
    title: 'Hey , i have started a media session in Weei App, Come and join',
    text: "Join in this "+roomId +" ROOM ID",
    linkUrl: ANDROIDURL,
    // chooserTitle: 'Example Chooser Title'
  );
  return;

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 18,),
              Text("Send To", style: size14_600W),
              SizedBox(height: 6,),

              GestureDetector(
                onTap: (){
                  FlutterShare.share(
                    title: 'Hey , i have started a media session in Weei App, Come and join',
                    text: "Join in this "+roomId +" ROOM ID",
                    linkUrl: ANDROIDURL,
                    // chooserTitle: 'Example Chooser Title'
                  );
                },
                child: Container(

                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Share as link #" + roomId.toString(), style: size14_500W),
                        w(5),
                        const CircleAvatar(
                          backgroundColor: grey,
                          child: Icon(CupertinoIcons.link, size: 10),
                          radius: 10,
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xff2B2B2B)),
                ),
              ),
              SizedBox(height: 2,),
              div(),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Scrollbar(
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
                          ?chatList(documentSnapshots[index].id,data,index,roomId)
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
              ),
              h(5),
              BannerAds(),
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
chatList(var docId,var item, int index,var roomId) {
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
          trailing:SessionSentWidget(path: item['messagePath'],id:hisId ,data: item,room: roomId,),
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