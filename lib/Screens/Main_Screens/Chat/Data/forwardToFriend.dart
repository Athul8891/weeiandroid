import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:weei/Helper/generateTumbnail.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/getYUrl.dart';

import '../../../../Helper/sharedPref.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future forwardToFriend(mesagePath,data,startTime) async {
//  showProgress("Processing the entry...");
       print("fwwwwwd");
       print(mesagePath);
       print(data['type']);


   final  uid = auth.currentUser!.uid;
   var img = await getSharedPrefrence(IMG);
   var nm = await getSharedPrefrence(NAME);
   var docId = DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(docId).set(
      {

        'message':data['message'],
        'messagePath':mesagePath,
        'type': data['type'] ,
        'thumb': img,
        'name': nm,
        'time': DateFormat.jm().format(DateTime.now()),

        'uId':  uid.toString(),
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'url':  data['url'],
        'mediaThumb':  data['mediaThumb'],
        'mediaName': data['mediaName'],
        'mediaType':  data['mediaType'],
       // 'startTime':  startTime,
         //'botType':  data['botType'].toString(),
        'isPlaylist': data['isPlaylist'],

      }).then((value)async{


           print("friendData['type']");
           print(data['type']);
           // print(data['botType']);

       if(data['type']=="TEXT"){
         updateMessage(mesagePath,data['message']);
       }
       if(data['type'].toString().toUpperCase()=="YMUSICBOT"){
      updateMessage(mesagePath,"Attechment 📎");
       }

       if(data['type'].toString().toUpperCase()=="YVIDEOBOT"){
      updateMessage(mesagePath,"Attechment 📎");
       }


       if(data['type']=="ROOMIN"){
         updateMessage(mesagePath,"Invite 📥");
       }
       if(data['type']=="FILEMUSIC"){
         updateMessage(mesagePath,"Attechment 📎");
       }
       if(data['type']=="FILEVIDEO"){
         updateMessage(mesagePath,"Attechment 📎");
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

        'lastMessage': lastMessage,
        'startChat': true,
        'time': DateFormat.jm().format(DateTime.now()),


      }).then((value)async{



    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

}




