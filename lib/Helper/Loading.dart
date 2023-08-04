import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';


class Loading extends StatefulWidget {


  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<Loading> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgClr,

      child: Center(child: CircularProgressIndicator(color: themeClr,))
      ,
    );
  }


}
