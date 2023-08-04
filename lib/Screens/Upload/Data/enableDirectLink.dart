import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weei/Screens/Upload/Data/getStorage.dart';
import 'package:weei/Screens/Upload/Data/uploadToFirebase.dart';


var convertDataToJson;

Future enableDirectLink(contentId) async {
  print("contentIddd");
  print(contentId);
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  var request = http.Request('PUT', Uri.parse('https://api.gofile.io/setOption'));
  request.bodyFields = {
    'contentId': contentId,
    'token': 'G2T0F6TTiNFlct1lc3lG9s7ArhJ3lDre',
    'option': 'directLink',
    'value': 'true'
  };

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var rsp = await response.stream.bytesToString();


    convertDataToJson = json.decode(rsp);
  }
  else {

    convertDataToJson=0;
    print(response.reasonPhrase);
  }

  return convertDataToJson;
}