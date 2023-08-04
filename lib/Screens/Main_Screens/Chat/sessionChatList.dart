import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weei/Helper/Const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/playVoiceNote2.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';

class sessionChatList extends StatefulWidget {
  final code;
  final voiceNotePlayingListner;
  sessionChatList({this.code,this.voiceNotePlayingListner});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<sessionChatList> {

  PaginateRefreshedChangeListener refreshChangeListener =
  PaginateRefreshedChangeListener();

  final FirebaseAuth auth = FirebaseAuth.instance;
  var voiceNoteReloadListner = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 5,left:10 ),
        child: PaginateFirestore(

          shrinkWrap: true,
          reverse: true,
          onEmpty: emptyList(),
          itemBuilderType: PaginateBuilderType.listView,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65),
          // Change types accordingly
          itemBuilder: (context, documentSnapshots, index) {
            final data = documentSnapshots[index].data() as Map?;
            return data != null
                ? Padding(
                padding: EdgeInsets.only(right: 10, bottom: 10),
                child: chhat(
                    documentSnapshots[index].id, data, index))
                : Container(
              child: Center(
                child: Text("No Freinds Found!"),
              ),
            );
          },
          // orderBy is compulsory to enable pagination
          query: FirebaseFirestore.instance
              .collection('Chat')
              .doc(widget.code)
              .collection(
              widget.code)
              .orderBy("stamp", descending: true),
          // to fetch real-time data
          listeners: [
            refreshChangeListener,
          ],

          isLive: true,
        ),
      ),
    );
  }
  chhat(var docId,var item,int index) {



    return item['type']=="VOICENOTE"?GestureDetector(
      onLongPress: (){
        moreBottomSheet(item['messagePath'],
            item['type'], item['uId'], item,docId,index);

      },
      child: Column(
        crossAxisAlignment: auth.currentUser!.uid==item['uId']?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          h(10),
          auth.currentUser!.uid==item['uId']?Row(
            mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
            //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
            children: [

              Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
              w(8),
              Text(" • " + item['time'].toString(), style: size10_400grey)
            ],
          ):Row(
            mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
            //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
            children: [
              Text( item['time'].toString()+" • " , style: size10_400grey),
              w(8),
              Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),

            ],
          ),
          h(10),

          Row(
            mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
            children: [
              auth.currentUser!.uid!=item['uId'] ? CircleAvatar(
                radius: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 15,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                        width: 15,

                      ),
                    ),


                  ],
                ),
              ) :Container(),
              w(5),
              playVoiceNote2(item:item,uid: auth.currentUser!.uid,index: index,voiceNotePlayingListner:widget.voiceNotePlayingListner,voiceNoteReloadListner: voiceNoteReloadListner,),
              w(5),
              auth.currentUser!.uid==item['uId'] ?  CircleAvatar(
                radius: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 15,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                        width: 15,

                      ),
                    ),


                  ],
                ),
              ):Container(),



            ],
          ),
        ],
      ),
    ): GestureDetector(
      onLongPress: (){

        moreBottomSheet(item['messagePath'],
            item['type'], item['uId'], item,docId,index);
      },
      child: Column(
        crossAxisAlignment: auth.currentUser!.uid==item['uId'].toString()?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          h(10),
          Row(
            mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
            //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
            children: [

              Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
              w(8),
              Text(" • " + item['time'].toString(), style: size10_400grey)
            ],
          ),
          // Row(
          //   crossAxisAlignment: auth.currentUser!.uid==item['uId'].toString()?CrossAxisAlignment.end:CrossAxisAlignment.start,
          //
          //   mainAxisAlignment: auth.currentUser!.uid==item['uId'].toString()?MainAxisAlignment.end:MainAxisAlignment.start,
          //
          //   children: [
          //
          //
          //     Row(
          //       mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          //       //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
          //       children: [
          //
          //         Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
          //         w(8),
          //         Text(" • " + item['time'].toString(), style: size10_400grey)
          //       ],
          //     ),
          //     // CircleAvatar(
          //     //   radius: 12,
          //     //   child: Stack(
          //     //     clipBehavior: Clip.none,
          //     //     fit: StackFit.expand,
          //     //     children: [
          //     //       ClipOval(
          //     //         child:  Container(
          //     //           height: 23,
          //     //           color: Colors.black,
          //     //           child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
          //     //           width: 23,
          //     //
          //     //         ),
          //     //       ),
          //     //
          //     //
          //     //     ],
          //     //   ),
          //     // ),
          //     // w(10),
          //     // Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size14_600W),
          //     // w(8),
          //     // Text("• " + item['time'].toString(), style: size12_400grey)
          //   ],
          // ),

          h(10),

          Row(
            mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
            children: [

              auth.currentUser!.uid!=item['uId'] ? CircleAvatar(
                radius: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 15,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                        width: 15,

                      ),
                    ),


                  ],
                ),
              ) :Container(),
              item['message'].toString().length>12? Expanded(
                child: Container(
                  margin:  EdgeInsets.only(right: 5,left: 5),
                  child:  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                    child: Text(item['message'].toString(), style:auth.currentUser!.uid!=item['uId']?size14_500B: size14_500W),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                        bottomRight:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),



                      color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                ),
              ):Container(
                margin:  EdgeInsets.only(right: 5,left: 5),
                child:  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                  child: Text(item['message'].toString(), style:auth.currentUser!.uid!=item['uId']?size14_500B: size14_500W),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft:
                      auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                      bottomRight:
                      auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),



                    color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
              ),
              auth.currentUser!.uid==item['uId'] ?  CircleAvatar(
                radius: 12,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 15,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['thumb']),gaplessPlayback: true,),
                        width: 15,

                      ),
                    ),


                  ],
                ),
              ):Container(),





            ],
          ),


        ],
      ),
    );
  }

  moreBottomSheet(item, type, uid, data,docId,index) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff4F4F4F),
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
                  (type == "TEXT")?  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () async {
                        if (type == "TEXT") {
                          await Clipboard.setData(
                              ClipboardData(text: data['message']));
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        "Copy" ,
                        style: size14_600W,
                      ),
                    ),
                  ): Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        setState(() {
                          voiceNoteReloadListner.text = index.toString();
                        });

                      },
                      child: Text(
                        "Reload" ,
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),


                  uid==auth.currentUser!.uid ? Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        unsendMessage(
                            widget.code,
                            docId);
                      },
                      child: Text(
                        'Unsend',
                        style: size14_600W,
                      ),
                    ),
                  ):Container(),
                  uid==auth.currentUser!.uid ?  div():Container(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: ()async {
                        showToastSuccess("This message has been reported to Weei team");
                        Navigator.pop(context);


                        //
                        // unsendMessage(
                        //     chatPath,
                        //     docid);
                      },
                      child: Text(
                        'Report',
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: ()async {

                        Navigator.pop(context);


                        //
                        // unsendMessage(
                        //     chatPath,
                        //     docid);
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
  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No conversations found.", style: size13_600W),
        SizedBox(height: 15,),






      ],),);

  }

  div() {
    return  Divider(color: Color(0xff404040), thickness: 1);
  }
}
