import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weei/Helper/getBase64.dart';

import 'dart:convert';
import 'dart:io' as Io;

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
Future<String?> generateTumbnail(url)async{

  print("urllllllllll");
  print(url);

  final fileName = await VideoThumbnail.thumbnailFile(
    video: url,
    thumbnailPath: (await getTemporaryDirectory()).path,
    imageFormat: ImageFormat.JPEG,
    maxHeight: 164, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    quality: 75,
  );

    print("fileName");
    print(fileName);
  final bytes = Io.File(fileName.toString()).readAsBytesSync();

  String img64 = base64Encode(bytes);

  print("img64");
  print(img64);
   return img64;

}