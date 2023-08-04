import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void NavigatePage(context,page){


  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void NavigatePageRelace(context,page){


  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}