import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendInvetationToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendNotificationApi.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/verifyMessagePath.dart';


class SessionSentWidget extends StatefulWidget {
  final room;
  final path;
  final id;
  final data;
  SessionSentWidget({this.room,this.path,this.id,this.data});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SessionSentWidget> {

  var send = false;
  var loading = false;
  var path;

  @override
  Widget build(BuildContext context) {
    return   loading==true? SpinKitRing(
      color: themeClr,
      size: 20.0,
      lineWidth: 2.0,
    ): GestureDetector(onTap: loading==true?null:()async{


      print("widget.data['profileType']");
      print(widget.data[widget.id]['type']);
      if(widget.data[widget.id]['type']!="Human"){

        showToastSuccess("Error sending! This account not accepting any forward messages.");
        return;
      }




      var rsp;

      if(send==false){
        setState(() {
          send=true;
        });

        if(widget.data[widget.id]['fcmToken'].toString()!="null"&&widget.data[widget.id]['sendNoti'].toString()!="false"){
          var name= await getSharedPrefrence(UNAME);
          sendPushMessage( "Invited to join a ongoing session 📥",  name,  widget.data[widget.id]['fcmToken'].toString());
        }
        rsp  = await   sendInvetationToFriend(widget.path,widget.room,"ROOMIN",widget.id,widget.data,widget.path);


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
