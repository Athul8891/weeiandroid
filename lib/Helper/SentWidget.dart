import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class SentWidget extends StatefulWidget {
  final room;
  final path;
  final id;
  final data;
  SentWidget({this.room,this.path,this.id,this.data});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<SentWidget> {

  var send = false;
  var loading = false;

  @override
  Widget build(BuildContext context) {
    return   loading==true? SpinKitRing(
      color: themeClr,
      size: 20.0,
      lineWidth: 2.0,
    ): GestureDetector(onTap: loading==true?null:()async{
           print("srnt");
           setState(() {
             loading=true;
           });


           var rsp;

        if(send==false){
          rsp  = await   sendMeassageToFriend(widget.path,widget.room,"ROOMIN",widget.id,widget.data,"","");
           setState(() {
             send=true;
           });
        }else{
          unsendMessage(widget.path,rsp);
          setState(() {
            send=false;
          });
        }
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
          child: Text(send==true?"Undo":"Sent", style: size12_200W),
        ),
      ),
    );
  }


}
