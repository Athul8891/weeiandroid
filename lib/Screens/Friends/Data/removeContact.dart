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
import 'package:weei/Screens/Main_Screens/Chat/Data/clearMessages.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future removeContact(orginId,partnerId) async {
//  showProgress("Processing the entry...");




  ///me
  await _firestore.collection('Friend').doc(orginId).collection(orginId).doc(partnerId).delete().then((value)async{

    thenremoveContact(orginId,partnerId);

    //Navigator.of(context).pop();
  }).catchError((error) {

  });





  return rslt;
}


Future thenremoveContact(orginId,partnerId) async {
//  showProgress("Processing the entry...");




  ///me
  await _firestore.collection('Friend').doc(partnerId).collection(partnerId).doc(orginId).delete().then((value)async{

   showToastSuccess("Contact removed");

    //Navigator.of(context).pop();
  }).catchError((error) {

  });





  return rslt;
}







