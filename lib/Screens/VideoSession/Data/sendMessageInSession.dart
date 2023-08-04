import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:random_string/random_string.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen2.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
final databaseReference = FirebaseDatabase.instance.reference();
var response;

final FirebaseAuth auth = FirebaseAuth.instance;
final  uid = auth.currentUser!.uid;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

FirebaseStorage storage = FirebaseStorage.instance;
File? fileImage;

// sendMessageInSesssion(code,message,type,index) async {
// //  showProgress("Processing the entry...");
//
//   final  uid = auth.currentUser!.uid;
//   var img = await getSharedPrefrence(IMG);
//   var nm = await getSharedPrefrence(NAME);
//
//
//  // index==null?"0":index.length.toString()
//   //DateTime.now().millisecondsSinceEpoch.toString()
//     var rsp = await    databaseReference.child("channel").child(code).child('chat').child(index==null?"0":index.length.toString()).update({
//       'message':message,
//       'type':  type,
//       'thumb': img,
//       'name': nm,
//       'time': DateTime.now().hour.toString()+":"+(DateTime.now().minute.toString().length==1?("0"+DateTime.now().minute.toString()):DateTime.now().minute.toString()),
//
//       'uId':  uid.toString(),
//       'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),
//
//     });
//
//
//
//
//
//
//
//
//
// }


sendMessageInSesssion(code,message,type,sec) async {
//  showProgress("Processing the entry...");

  final  uid = auth.currentUser!.uid;
  var img = await getSharedPrefrence(IMG);
  var nm = await getSharedPrefrence(NAME);

  var ref=DateTime.now().millisecondsSinceEpoch.toString();

 // index==null?"0":index.length.toString()
  //DateTime.now().millisecondsSinceEpoch.toString()

  if(type=="VOICENOTE"){
    _storeFile(message,ref,code,sec);

  }


    var rsp = await _firestore.collection('Chat').doc(code).collection(code).doc(ref).set({
      'message':type=="VOICENOTE"?"false":message,
      'type':  type,
      'thumb': img,
      'name': nm,
      'time': DateFormat.jm().format(DateTime.now()),

      'uId':  uid.toString(),
      'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

    });

  databaseReference.child('channel').child(code).update({
    'chat': nm+" : "+(type=="VOICENOTE"?"Voice message":message.toString()+("||")+uid),
  });







}
_storeFile(file,ref,code,sec) async{
  Reference storagerefrence = storage.ref().child("voicenotes/${DateTime.now().toIso8601String()+uid}"+".mp3");

  TaskSnapshot uploadTask = await storagerefrence.putFile(File(file));
  String url = await storagerefrence.getDownloadURL();//download url from firestore and add to firebase database
     print(url);

  // var rsp = await    databaseReference.child("channel").child(code).child('chat').child(ref).update({
  //   'url':url,
  //   'sec':sec,
  //   'message':'true'
  //
  //
  //
  // });

  var rsp =  await _firestore.collection('Chat').doc(code).collection(code).doc(ref).update({
    'url':url,
    'sec':sec,
    'message':'true'



  });
    return url ;
}
