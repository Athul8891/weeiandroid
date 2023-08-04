import 'dart:convert';
import 'dart:io' as Io;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

import 'package:weei/Helper/sharedPref.dart';

Future<String> getBase64(imagefile)async{


  final bytes = Io.File(imagefile.path).readAsBytesSync();

  String img64 = base64Encode(bytes);

  print("img64");
  print(img64);
  //_write( img64.toString());
 //var rsp = await setSharedPrefrence(VDO, img64);
  return img64;
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}