import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Const.dart';

customSnackBarError(BuildContext context, String msg,GlobalKey<ScaffoldState> key) {
  final SnackBar snackBar = SnackBar(
    content: Text(msg),
    duration: Duration(milliseconds: 100),
    // action: SnackBarAction(
    //     label: action, textColor: Colors.yellow, onPressed: () {}),
  );
  // ignore: deprecated_member_use


  key.currentState!.showSnackBar(new SnackBar(    content: new Text(msg ,style: size14600Red,)));
}

showToastError(String message){
  Fluttertoast.showToast(

      msg: message,
      toastLength: Toast.LENGTH_SHORT,

      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,


      fontSize: 16.0
  );
}


showToastSuccess(String message){
  Fluttertoast.showToast(
      msg: message,

      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,


      fontSize: 16.0
  );
}