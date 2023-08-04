import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';


class textMessageWidget extends StatefulWidget {


  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<textMessageWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgClr,

      child: Center(child: CircularProgressIndicator(color: themeClr,))
      ,
    );
  }


}
