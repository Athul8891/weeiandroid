import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weei/Helper/Toast.dart';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/Upload/Data/getStorage.dart';




final databaseReference = FirebaseDatabase.instance.reference();



final  uid = auth.currentUser!.uid;


var  used ="0000";
var  storage ="0000";
var  purchased ="0000";
var  totalGoingToUpload =000;
var  rsp;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;
var thumbnail  ;
var convertDataToJson;
Future deleteFileApi(contentsId,size ) async {
  print("server");
  print(contentsId);
  var request = http.MultipartRequest('DELETE', Uri.parse('https://api.gofile.io/deleteContent'));
  request.fields.addAll({
    'token': 'mTrriQYoGOO7Gm0OG3cbFraTYe7pe0A7',
    'contentsId': contentsId
  });


  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var rsp = await response.stream.bytesToString();
    convertDataToJson = json.decode(rsp);

    dltMediaDocument(contentsId);
    deleteStorage(size);
   // showToastSuccess(convertDataToJson.toString());
  }
  else {

    showToastSuccess("Failed to delete, Check internet connection!");
    convertDataToJson=0;
    print(response.reasonPhrase);
  }
  return convertDataToJson;
}



Future dltMediaDocument(id) async{





  await _firestore.collection('Media').doc(id).delete().then((value){
    rslt = 1;
    //Navigator.of(context).pop();



  })
      .catchError((error) {
    rslt =0;


  });

  return rslt ;
}

Future deleteStorage(size) async {




  var rsp = await databaseReference.child('Users').child(uid.toString()).once().then(( snapshot) async {


    used = snapshot.snapshot.child('used').value.toString();
    storage = snapshot.snapshot.child('storage').value.toString();
    purchased = snapshot.snapshot.child('purchased').value.toString();
});


  var newSize =  int.parse(used.toString())-int.parse(size.toString())  ;

    print("newSize");
    print(newSize);
    print(used);
    print(size);

 var upt = await dltToStorage(newSize);

}