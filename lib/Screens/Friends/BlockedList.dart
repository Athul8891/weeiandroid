import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Screens/Friends/Data/unblockContact.dart';

import '../../../Helper/getBase64.dart';

class BlockedList extends StatefulWidget {
  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<BlockedList> {
  TextEditingController numberController = TextEditingController();

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  int a = 2;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';
  var onSubmit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Blocked", style: size16_600W),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
            onEmpty: Container(  child: Center(child: Text("No Freinds Found!"),)),

            itemBuilderType: PaginateBuilderType.listView,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65),
            // Change types accordingly
            itemBuilder: (context, documentSnapshots, index) {
              final data = documentSnapshots[index].data() as Map?;

              print("daaaaaaaata");
              print(data);
              return data != null
                  ? chatList(documentSnapshots[index].id, data, index)
                  : Container(
                      child: Center(
                        child: Text("No Freinds Found!"),
                      ),
                    );
            },
            // orderBy is compulsory to enable pagination
            query: FirebaseFirestore.instance
                .collection('Friend')
                .doc(auth.currentUser!.uid)
                .collection(auth.currentUser!.uid)
                .where('accepted', isEqualTo: false)
                .where('blocked', isEqualTo: true),
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

  chatList(var docId, var item, int index) {
    return GestureDetector(
      onTap: () {
        // print("taaaaap");
        // NavigatePage(context,ChatRoom(friendType: item['type'],friendUid: item['friendUid'],friendData:item ,));
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 40,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      MemoryImage(dataFromBase64String(item['profile'])),
                  //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
                ),
                width: 40,
              ),
              w(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'].toString(), style: size14_500W),
                    h(5),
                    Text(item['number'].toString(), style: size14_500Grey),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var rsp = await unblockContact(
                      auth.currentUser!.uid, item['friendUid']);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 30,
                  // width: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8), color: themeClr),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        item['uid'] == auth.currentUser!.uid
                            ? "You"
                            : "Unblock",
                        style: size14_600W),
                  ),
                ),
              )
            ],
          ),
          div()
        ],
      ),
    );
  }

  div() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: Color(0xff404040), thickness: 1),
    );
  }
}
