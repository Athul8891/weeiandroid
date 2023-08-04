import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendNotificationApi.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weei/Screens/Main_Screens/Library/Data/shareMediaToChat.dart';

import '../Chat/Data/verifyMessagePath.dart';


class SentWidgetMedia extends StatefulWidget {

  final path;
  final id1;
  final id2;
  final mediaType;
  final mediaData;
  final partnerData;
  SentWidgetMedia({this.path,this.id1,this.id2,this.mediaData,this.mediaType,this.partnerData});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SentWidgetMedia> {

  var send = false;
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return   loading==true? SpinKitRing(
      color: themeClr,
      size: 20.0,
      lineWidth: 2.0,
    ): GestureDetector(onTap: loading==true?null:()async{


      print("sendd");
      print(widget.partnerData);
      if(widget.partnerData['type']!="Human"){

        showToastSuccess("Error sending! This account not accepting any forward messages.");
        return;
      }


      if(widget.partnerData['fcmToken'].toString()!="null"&&widget.partnerData['sendNoti'].toString()!="false"){
        var name= await getSharedPrefrence(UNAME);
        sendPushMessage( "Shared a media 📎",  name,  widget.partnerData['fcmToken'].toString());
      }

      var rsp;

      if(send==false){
        setState(() {
          send=true;
        });
        rsp  = await   sendMediaMeassage(widget.path,"",widget.mediaType,widget.partnerData ,widget.mediaData,widget.path);

      print("rsppp");
      print(rsp);
      }else{
        setState(() {
          send=false;
        });
        unsendMessage(widget.path,rsp);

      }


      ///




    },
      child: Container(
        alignment: Alignment.center,

        height: 30,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9), color: themeClr),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(send==true?"Undo":"Sent", style: size122_600W),
        ),
      ),
    );
  }


}
