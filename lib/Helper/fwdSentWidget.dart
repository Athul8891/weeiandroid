import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/forwardToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendNotificationApi.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/verifyMessagePath.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SentFwdWidget extends StatefulWidget {

  final path;

  final data;
  final userData;
  SentFwdWidget({this.path,this.data,this.userData});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SentFwdWidget> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  var send = false;

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return   loading==true? SpinKitRing(
      color: themeClr,
      size: 20.0,
      lineWidth: 2.0,
    ): GestureDetector(onTap:()async{
      print("sendd");
      print(widget.data);
       if(widget.userData['type']!="Human"){

         showToastSuccess("Error sending! This account not accepting any forward messages.");
         return;
       }




           var rsp;

        if(send==false){
          setState(() {
            send=true;
          });

          if(widget.userData['fcmToken'].toString()!="null"&&widget.userData['sendNoti'].toString()!="false"){
            var name= await getSharedPrefrence(UNAME);
            sendPushMessage( "Send an message",  name,  widget.userData['fcmToken'].toString());
          }
          rsp  = await   forwardToFriend(widget.path,widget.data,widget.path);

        }else{
          setState(() {
            send=false;
          });
          unsendMessage(widget.path,rsp);

        }
      print(rsp);

    },
      child: Container(
        alignment: Alignment.center,

        height: 30,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9), color: themeClr),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(send==true?"Undo":"Send", style: size122_600W),
        ),
      ),
    );
  }


}
