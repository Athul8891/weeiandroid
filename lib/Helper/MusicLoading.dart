import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';


class MusicLoading extends StatefulWidget {
 final height;
 MusicLoading({this.height});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<MusicLoading> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color:  Color(0xff1e1e1e),

      child: Center(child: CircularProgressIndicator(color: themeClr,))
      ,
    );
  }


}
