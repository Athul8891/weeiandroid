import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LocalThumbnail extends StatefulWidget {
  final name;

  LocalThumbnail({this.name});
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<LocalThumbnail> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          //  child: Icon(Icons.music_note, color: Colors.pink,size: 100,),
            child: SvgPicture.asset("assets/svg/logo.svg", ),
      ),
      decoration: BoxDecoration(
        color: liteBlack,

        borderRadius:
        BorderRadius.circular(
            10),
      ),
    );
  }


}
