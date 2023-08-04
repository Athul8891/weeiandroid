import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/Search/Data/addBot.dart';
import 'package:weei/Screens/Search/Data/addFreind.dart';
import 'package:weei/Screens/Search/Data/checkReq.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaerchSentWidget extends StatefulWidget {
  final item;

  SaerchSentWidget({this.item});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SaerchSentWidget> {

  var send = false;
  var undo = false;
  var loading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return  undo==true?GestureDetector(onTap: widget.item['uid']==auth.currentUser!.uid?null:()async{

      setState(() {
        undo=false;
      });

      var sent =undoFriend(widget.item);
      setState(() {
        undo=false;
      });
    },

    //  SvgPicture.asset("assets/svg/myreq.svg", width: 30,color: themeClr,):
      child: Container(
        alignment: Alignment.center,

        height: 30,
        // width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: themeClr),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(widget.item['uid']==auth.currentUser!.uid?"YOU":("UNDO"), style: size122_600W),
        ),
      ),
    ):  GestureDetector(onTap: widget.item['uid']==auth.currentUser!.uid?null:()async{


      if (widget.item['profileType']=="YVideoBot"||widget.item['profileType']=="YMusicBot"){
        addBot(widget.item);

        return;
      }

      setState(() {
        undo=true;
      });
      var rsp = await checkReq(widget.item['uid']);
      if(rsp==true){
        undo=true;
        showToastSuccess("Request already sent");
      }if(rsp==false){
        var sent = addFriend(widget.item);


      }
    },
      child:send==true? SvgPicture.asset("assets/svg/myreq.svg", width: 30,color: themeClr,):  Container(
        alignment: Alignment.center,

        height: 30,
       // width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: themeClr),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(widget.item['uid']==auth.currentUser!.uid?"YOU":("ADD"), style: size122_600W),
        ),
      ),
    );


}}
