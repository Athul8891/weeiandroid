

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../Helper/sharedPref.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;




Future sendMediaMeassage(mesagePath,message,type,friendData ,mediaData,startTime) async {
//  showProgress("Processing the entry...");


     print("shaaare");
     print(mediaData['fileUrl']);

     final  uid = auth.currentUser!.uid;
     var img = await getSharedPrefrence(IMG);
     var nm = await getSharedPrefrence(NAME);
      var path = DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(path).set(
      {

        'message':"null",
        'mesagePath':mesagePath,
        'type':  type,
        // 'thumb': friendData['profile'],
        // 'name': friendData['name'],
        'thumb': img,
        'name': nm,
        'startTime': startTime,
        'time': DateFormat.jm().format(DateTime.now()),

        //'uId':  friendData['friendUid'],
        'uId':  uid,
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),
        'isPlaylist': false,

      //print(playlist.thumbnails.lowResUrl);
    //  print(playlist.title);
    //  print(playlist.url);
     // print(playlist.videoCount);
        'url':  mediaData['fileUrl'],
        'mediaThumb':  mediaData['fileThumb'].toString().isNotEmpty? mediaData['fileThumb']:"https://store4.gofile.io/download/direct/f27fcbc0-85c8-4f2b-9962-de5894976523/images.jpg",
        'mediaName':   mediaData['fileName'],
        'mediaType':  type,


      }).then((value)async{


         print("sennttt");
        rslt = path;

      updateMessage(mesagePath,"Media 📎");





    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

    print("errorrrrr");
    print(error);
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
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
