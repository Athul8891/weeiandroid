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


Future sendInvetationToFriend(mesagePath,message,type,friendUid,friendData,startTime) async {
//  showProgress("Processing the entry...");



   final  uid = auth.currentUser!.uid;
   var img = await getSharedPrefrence(IMG);
   var nm = await getSharedPrefrence(NAME);
   var docId = DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(docId).set(
      {

        'message':message,
        'messagePath':mesagePath,
        'type':  type,
        'thumb': img,
        'name': nm,
        'time':  DateFormat.jm().format(DateTime.now()).toString(),
        'uId':  uid.toString(),
        'startTime':  startTime,
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'url':  "",
        'mediaThumb':  "",
        'mediaName':  "",
        'mediaType':  "",
        'isPlaylist': "",

      }).then((value)async{

       updateMessage(mesagePath,message);


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
        'lastMessage': "Session Invitation 📥",
        'startChat': true,


      }).then((value)async{

            print("updatindd");

    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

}




