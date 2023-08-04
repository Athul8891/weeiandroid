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
import 'package:weei/Screens/Search/Data/addBot.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;




Future addFriend(item) async {
//  showProgress("Processing the entry...");


  final  uid = auth.currentUser!.uid;

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);

  await _firestore.collection('Friend').doc(item['uid']).collection(item['uid']).doc(uid).set(
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


        "friendUid":uid.toString(), ///requesting person uid
        "addUid":item['uid'].toString(),  ///added person uid
        'name': nm,
        'number': num,
        'profile': img,

        'createMillisecond':DateTime.now().millisecondsSinceEpoch,
        'createTime':getTime(),
        'username': item['username'].toString(),
        'bio': item['bio'].toString(),
        'accepted': false,
        'blocked': false,
       // 'requested': true,

        'type': item['profileType'],


      }).then((value)async{

          // if (item['profileType']=="YVideoBot"||item['profileType']=="YMusicBot"){
          //   acceptBotFriend(item);
          // }

    rslt=true;

    showToastSuccess("Request sent");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
}

Future undoFriend(item) async {
//  showProgress("Processing the entry...");


  final  uid = auth.currentUser!.uid;

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);

  await _firestore.collection('Friend').doc(item['uid']).collection(item['uid']).doc(uid).delete().then((value)async{

    // if (item['profileType']=="YVideoBot"||item['profileType']=="YMusicBot"){
    //   acceptBotFriend(item);
    // }

    rslt=true;

      showToastSuccess("Request cancelled");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
}