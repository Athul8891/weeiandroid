import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Screens/Upload/Data/enableDirectLink.dart';
import 'package:weei/Screens/Upload/Data/getStorage.dart';
import 'package:weei/Screens/Upload/Data/uploadToFirebase.dart';


var convertDataToJson;

Future fetchUrlApi(contentId,type,fileSize,filePath ) async {

  var enable = await  enableDirectLink(contentId);
  // print("enableee");
  // print(enable['data'].toString().split('/').last);
  // print(enable['data']);


  if(enable!=0){
    var gt = await uploadToFirebase(contentId,enable['data'].toString().split('/').last,fileSize,type,enable['data'],filePath,"1");
    var sp = await  addToStorage(fileSize);
  }else{
    showToastSuccess("Upload Failed!");
  }


  return;
  var request = http.Request('GET', Uri.parse('https://api.gofile.io/getContent?contentId='+contentId+'&token=G2T0F6TTiNFlct1lc3lG9s7ArhJ3lDre'));


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var rsp = await response.stream.bytesToString();


    convertDataToJson = json.decode(rsp);
   print("getttFileee");
   print(convertDataToJson);
    var fileId= convertDataToJson['data']['childs'][0];
    var fileName= convertDataToJson['data']['contents'][fileId]['name'];
    //var fileSize= convertDataToJson['data']['contents'][fileId]['size'];
    var fileUrl= convertDataToJson['data']['contents'][fileId]['directLink'];
    print("childs");
    print(fileId);

     var gt = await uploadToFirebase(fileId,fileName,fileSize,type,fileUrl,filePath,"1");
     var sp = await  addToStorage(fileSize);
    // showToastSuccess(convertDataToJson.toString());
  }
  else {
    convertDataToJson=0;
    print(response.reasonPhrase);
  }
  return convertDataToJson;


}