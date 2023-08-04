import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/forwardToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/verifyMessagePath.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SentPlayListWidget extends StatefulWidget {

  final path;

  final data;

  SentPlayListWidget({this.path,this.data,});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SentPlayListWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();

  var send = false;
  var path;
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return   loading==true? SpinKitRing(
      color: themeClr,
      size: 20.0,
      lineWidth: 2.0,
    ): GestureDetector(onTap:()async{


      print("srnt");
      print(widget.data['friendUid']);
      print(widget.path);
      setState(() {
        loading=true;
      });





        var rsp = await    databaseReference.child(widget.path).child(widget.data['fileId']).update({
          'docId': widget.data['fileId'],
          'fileName':  widget.data['fileName'],
          'fileThumb': widget.data['fileType']=="VIDEO"? widget.data['fileThumb']:"",

          'fileUrl':  widget.data['fileUrl'],
          'fileType':  widget.data['fileType'],

        }).whenComplete((){
          setState(() {
            send=true;
          });


        });


      setState(() {
        loading=false;
      });


    },
      child: Container(
        alignment: Alignment.center,

        height: 30,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: themeClr),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("Add", style: size12_200W),
        ),
      ),
    );
  }


}