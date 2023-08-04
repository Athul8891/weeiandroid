import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';


class ButtonLoading extends StatefulWidget {
  final height;
  final width;

  ButtonLoading({this.height,this.width});

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<ButtonLoading> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height==null?20.0:widget.height,
      width: widget.width==null?20.0:widget.width,
      child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 3
      ),
    );
  }


}
