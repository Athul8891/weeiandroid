import 'dart:convert';

import 'package:http/http.dart' as http;


var convertDataToJson;

Future getServerApi() async {

  var request = http.Request('GET', Uri.parse('https://api.gofile.io/getServer'));


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var rsp = await response.stream.bytesToString();
    convertDataToJson = json.decode(rsp);
  }
  else {

    convertDataToJson = 0;
  }
    return convertDataToJson;
}
