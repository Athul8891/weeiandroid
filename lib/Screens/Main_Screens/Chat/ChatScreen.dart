import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Friends/FirendList.dart';
import 'package:weei/Screens/Friends/FirendRequest.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatRequests.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatRoom.dart';
import 'package:weei/Screens/Main_Screens/Chat/blockedChats.dart';
import 'package:weei/Screens/Search/Search.dart';

import '../../../Helper/getBase64.dart';

class ChatScreen extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<ChatScreen> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  int a = 2;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          //  Icon(iconData, color: Colors.black,size: 10,),
          Text(title),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BannerAds(),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
             Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 23,
            )),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              // _onMenuItemSelected(value as int);
              print("value");
              print(value);
              if (value == 0) {
                NavigatePage(context,ChatRequestes());
              }


              if (value == 1) {

                NavigatePage(context,BlockedChatScreen());

                // var rsp = await clearMessages((auth.currentUser!.uid +"-"+widget.friendUid));
                //  Navigator.pop(context);
              }
              if (value == 2) {
                NavigatePage(context,Search());

                // var rsp = await clearMessages((auth.currentUser!.uid +"-"+widget.friendUid));
                //  Navigator.pop(context);
              }
            },
            itemBuilder: (ctx) => [
              _buildPopupMenuItem(' Request', Icons.add, 0),
              _buildPopupMenuItem(' Blocked', Icons.add, 1),
              _buildPopupMenuItem(' Search', Icons.add, 2),
           //   _buildPopupMenuItem(' Archived', Icons.clear, 2),
            //  _buildPopupMenuItem(' View ', Icons.clear, 2),
              // _buildPopupMenuItem('Copy', Icons.copy, 2),
              // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
            ],
          ),
        ],
        title: const Text("Direct Message", style: size16_600W),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 1),
        child: Scrollbar(
          // key: ValueKey(dropdownvalue),
          // child: ListView.separated(
          //   scrollDirection: Axis.vertical,
          //   separatorBuilder: (context, index) => h(10),
          //   shrinkWrap: true,
          //   itemCount: 50,
          //   itemBuilder: (context, index) {
          //     // final item = arrOrderDetail != null
          //     //     ? arrOrderDetail[index]
          //     //     : null;
          //
          //     return participantsList(index);
          //   },
          // ),
          // child: FirebaseAnimatedList(
          //   key: ValueKey(dropdownvalue),
          //
          //   query: FirebaseDatabase.instance
          //       .reference()
          //       .child('session').child("EZypBJHwk4MtztMyuvMjCxwNWIh1").limitToFirst(a),
          //
          //   itemBuilder: (BuildContext context, DataSnapshot snapshot,
          //       Animation<double> animation, int index) {
          //
          //     // Object? contact = snapshot.value;
          //     // contact['key'] = snapshot.key;
          //     return MusicList( snapshot.value,index);
          //   },
          // ),
          child: PaginateFirestore(
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
                  ? chatListNew(documentSnapshots[index].id, data, index)
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
    );
  }




  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No conversations found.", style: size13_600W),
        SizedBox(height: 15,),






      ],),);

  }
  chatListNew(var docId, var item, int index) {
    var hisId = auth.currentUser!.uid == item['uIds'][0]
        ? item['uIds'][1]
        : item['uIds'][0];
    print("hisId");
    print(hisId);
    return GestureDetector(
      onTap: () {
        print("taaaaap");
        NavigatePage(
            context,
            ChatRoom(
              fullData: item,
              friendType: item[hisId]['type'],
              friendUid: item[hisId]['uid'],
              friendData: item[hisId],
              messagePath: item['messagePath'],
              chatStartTime:item['startTime'].toString() ,
            ));
      },
      child:  Column(
        children: [
          ListTile(
            title:  Text(item[hisId]['name'].toString(), style: size14_600WT,maxLines: 1,),
            subtitle:  Text(item['lastMessage'].toString(), style: size14_500Grey,maxLines: 1,),
            leading:  Container(
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                backgroundImage:
                MemoryImage(dataFromBase64String(item[hisId]['profile'])),
                //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
              ),
              width: 40,
            ),
            trailing: Column(
              children: [
                Text(item['time'].toString(), style: size1_200W,maxLines: 1,),

              ],
            ),
          //  trailing: CupertinoSwitch(value: true, onChanged: (v) {}),
            contentPadding: EdgeInsets.zero,
          ),

          div()
        ],
      ),
    );
  }

  div() {
    return Divider(color: Color(0xff404040), thickness: 1);
  }
}
