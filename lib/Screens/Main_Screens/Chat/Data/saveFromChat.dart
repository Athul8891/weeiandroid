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





saveMessage(mesagePath,docId)async{
  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(docId).update(
      {


        'saved':  DateTime.now().millisecondsSinceEpoch.toString(),



      }).then((value)async{






    //Navigator.of(context).pop();
  }).catchError((error) {


  });

}

unsave(mesagePath,docId,data)async{

  //  showProgress("Processing the entry...");









  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(docId).set(
      {

        'message':data['message'],
        'messagePath':data['messagePath'],
        'type':  data['type'],
        'thumb': data['thumb'],
        'name': data['name'],
        'time': data['time'],

        'uId':  data['uId'],
        'stamp':  data['stamp'],

        'url':  data['url'],
        'mediaThumb':  data['mediaThumb'],
        'startTime':  data['startTime'],
        'mediaName':  data['mediaName'],
        'mediaType':  data['mediaType'],
        'isPlaylist': data['isPlaylist'],

      }


  ).then((value)async{



    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });


}


