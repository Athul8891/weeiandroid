import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:weei/Helper/generateTumbnail.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/getYUrl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../../../../Helper/sharedPref.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;
FirebaseStorage storage = FirebaseStorage.instance;
File? fileImage;

Future sendMeassageToFriend(mesagePath,message,type,friendUid,friendData,url,startTime) async {
//  showProgress("Processing the entry...");




     print("aykooooooo");
   final  uid = auth.currentUser!.uid;
   var img = await getSharedPrefrence(IMG);
   var nm = await getSharedPrefrence(NAME);
   var docId = DateTime.now().millisecondsSinceEpoch.toString();


     if(type==VOICENOTE){
       _storeFile(url,mesagePath,docId);

     }

   await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(docId).set(
      {

        'message':message,
        'messagePath':mesagePath,
        'type':  type,
        'thumb': img,
        'name': nm,
        'time': DateFormat.jm().format(DateTime.now()),

        'uId':  uid.toString(),
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'url':  "false",
        'mediaThumb':  "",
        'startTime':  startTime,
        'mediaName':  "",
        'mediaType':  "",
        'isPlaylist': "",

      }


      ).then((value)async{

      //  "Voice message 🎤"

     print("doooone");
     print(friendData['type']);
     print("doooone");

         updateMessage(mesagePath,message);



       if(friendData['type']=="YVideoBot"){
         getSong(message,mesagePath,friendData);
       }

       if(friendData['type']=="YMusicBot"){
         getSong(message,mesagePath,friendData);
       }

  //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;

    print("error");
    print(error);
    print(mesagePath);
    showToastSuccess(errorcode);
  });

  return docId;
}


updateMessage(mesagePath,lastMessage)async{
  await _firestore.collection('Chat').doc(mesagePath).update(
      {


        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),
        'time':  DateFormat.jm().format(DateTime.now()).toString(),

        'lastMessage': lastMessage,
        'startChat': true,


      }).then((value)async{
           print("trueeee");


    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

}


_storeFile(file,mesagePath,docId) async{
  final  uid = auth.currentUser!.uid;

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

  var rsp =  await  _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(docId).update({
    'url':url,
    //'sec':sec,
   // 'message':'true'



  });
  return url ;
}

