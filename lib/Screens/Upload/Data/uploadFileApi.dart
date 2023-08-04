import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weei/Helper/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:weei/Screens/Upload/Data/tst.dart';


var convertDataToJson;
Future  uploadFileApi(fileLength,filePath,server ) async {
  print("server");
  print(server);

  var request = http.MultipartRequest('POST', Uri.parse('https://'+server+'.gofile.io/uploadFile'));
  request.fields.addAll({
    'token': 'G2T0F6TTiNFlct1lc3lG9s7ArhJ3lDre'
  });
  request.files.add(await http.MultipartFile.fromPath('file', filePath));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var rsp = await response.stream.bytesToString();
    convertDataToJson = json.decode(rsp);
   // showToastSuccess(convertDataToJson.toString());
  }
  else {
    convertDataToJson=0;
    print(response.reasonPhrase);
  }
  return convertDataToJson;
}




