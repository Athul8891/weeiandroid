import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:weei/Helper/generateTumbnail.dart';
import 'package:weei/Helper/getTime.dart';
import 'package:weei/Helper/sharedPref.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future acceptFriend(item) async {
//  showProgress("Processing the entry...");


  final  uid = auth.currentUser!.uid;
  enableFriend(item['friendUid']);

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);
  var uname =await getSharedPrefrence(UNAME);
  var bio =await getSharedPrefrence(BIO);

  ///me
  await _firestore.collection('Friend').doc(item['friendUid']).collection(item['friendUid']).doc(uid).set(
      {

        // "friendUid":item['uid'].toString(),
        // 'name': item['name'],
        // 'requestMillisecond':DateTime.now().millisecondsSinceEpoch,
        // 'requestTime':DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
        //
        // 'accepted': false,
        // 'profile': item['profile'],
        //
        // 'type': item['profileType'],



        "addUid":item['friendUid'],  ///added person uid
        "friendUid":uid.toString(),  ///added person uid
        'name': nm,
        'number': num,
        'profile': img,
        'username': uname,
        'bio': bio,

        'createMillisecond':DateTime.now().millisecondsSinceEpoch,
        'createTime':getTime(),

        'accepted': true,
        'blocked': false,
        //'requested': false,
        //'lastInteraction': DateTime.now().millisecondsSinceEpoch,


        'type': "Human",


      }).then((value)async{



    rslt=true;

    showToastSuccess("Request accepted");


    //Navigator.of(context).pop();
  }).catchError((error) {
    showToastSuccess(error);
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });





  return rslt;
}


enableFriend(id)async{
  final  uid = auth.currentUser!.uid;

  ///me
  await _firestore.collection('Friend').doc(uid).collection(uid).doc(id).update(
      {

        // "friendUid":item['uid'].toString(),
        // 'name': item['name'],
        // 'requestMillisecond':DateTime.now().millisecondsSinceEpoch,
        // 'requestTime':DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),
        //
        // 'accepted': false,
        // 'profile': item['profile'],
        //
        // 'type': item['profileType'],





        'accepted': true,



      }).then((value)async{



    rslt=true;

    showToastSuccess("Request accepted");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });


}




