import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weei/Helper/Const.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/SentWidget.dart';
import 'package:weei/Helper/addBtForPlaylistBottm.dart';
import 'package:weei/Helper/fwdSentWidget.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Screens/Main_Screens/Library/SentWidgetMedia.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

int a =2;
final FirebaseAuth auth = FirebaseAuth.instance;
void  addToPlayListBottom(BuildContext context, type,datas) {




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
            children: <Widget>[
              Container(
                height: 60,
                decoration: const BoxDecoration(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10),
                  child: Row(
                    children: [
                      Text("Share", style: size18_500W),
                      SizedBox(width: 10,),
                      Icon(
                        CupertinoIcons.location_fill,
                        size: 15,
                        color: Colors.white,
                      ),
                      Spacer(),
                      IconButton(
                          icon: const Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: Color(0xff363636),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ),
                ),
              ),
              const Divider(color: Color(0xff404040), thickness: 1),

              Scrollbar(
                child: PaginateFirestore(
                  // Use SliverAppBar in header to make it sticky
                  // header: SliverToBoxAdapter(child: Text('HEADER')),
                  // footer: SliverToBoxAdapter(child: Text('FOOTER')),
                  // item builder type is compulsory.
                  // separator: Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8),
                  //   child: Divider(color: Color(0xff404040), thickness: 1),
                  // ),
                  key: ValueKey(dropdownvalue),
                  shrinkWrap: true,
                  itemBuilderType: PaginateBuilderType.listView,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.65),
                  // Change types accordingly
                  itemBuilder:
                      (context, documentSnapshots, index) {
                    final data =
                    documentSnapshots[index].data() as Map?;
                    return data != null
                        ? playlistItems(
                        documentSnapshots[index].id,
                        data,
                        index,
                      datas
                    )
                        : const Center(
                      child: Text("No Playlist Found!",
                          style: size14_600W),
                    );
                  },
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance
                      .collection('Playlist')
                      .where('userId',
                      isEqualTo:
                      auth.currentUser!.uid.toString())
                      .where("playlistType", isEqualTo: type)
                      .orderBy("uploadAt", descending: true),
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


playlistItems(var doc, var items, int index,itemData) {
  print("item");
  print(items);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GestureDetector(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => audioPlayerScreen()));
        if (items['playlistType'] == "VIDEO") {
          // NavigatePage(
          //     context,
          //     MyVideoPlayList(
          //       path: items['playlistPath'],
          //       count: items['playlistSize'].toString(),
          //       name: items['playlistName'].toString(),
          //       doc: doc,
          //     ));
        } else {
          // NavigatePage(
          //     context,
          //     MyAudioPlayList(
          //       path: items['playlistPath'],
          //       count: items['playlistSize'].toString(),
          //       name: items['playlistName'].toString(),
          //       doc: doc,
          //     ));
        }
      },
      child: Row(
        children: [
          Container(
            height: 49,
            width: 49,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(tstImg), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          w(10),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///.split(':').first.toString()
                  Text(items['playlistName'].toString(), style: size14_500W),
                  Text(
                      items['playlistSize'].toString() +
                          " " +
                          items['playlistType'].toString().toLowerCase(),
                      style: size14_500Grey),
                ],
              )),
          SentPlayListWidget(path: items['playlistPath'],data: itemData,)


        ],
      ),
    ),
  );
}


div() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Divider(color: Color(0xff404040), thickness: 1),
  );
}


