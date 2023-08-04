
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
class MyClass with ChangeNotifier {

  static int myNumber = 0;

  void currentVoiceNote(index){
    myNumber = index;
    notifyListeners();
  }

}