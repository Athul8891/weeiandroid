import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Widgets/BottomNav.dart';

import 'package:firebase_database/firebase_database.dart';




final databaseReference = FirebaseDatabase.instance.reference();

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future updateUser(username,name,email,number,profile,bio ,context) async {
//  showProgress("Processing the entry...");

  final  uid = auth.currentUser!.uid;
  var fcm = await getSharedPrefrence(FCM);

  await _firestore.collection('Users').doc(uid.toString()).update(
      {

        //"uid":uid.toString(),
        "name":name.toString().trim(),
        "bio":bio.trim(),
        "username":username.toString().trim(),
        "email":email.toString().trim(),
        "number":number.toString().trim(),
        "search":[username.toString().trim(),number.toString().trim()],
        "fcmToken":fcm,
        // "storage":"7516192768".toString().trim(),
        // "purchased":"0000".toString().trim(),
        // "used":"0000".toString().trim(),
        //"profileType":"Human".toString().trim(),
        "profile":profile==null?PROFILEB64:profile,
      //  "createdDate":DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),


      }

      ).then((value)async{

    databaseReference.child('Users').child(uid.toString()).update(

        {

         // "uid":uid.toString(),
          "name":name.toString().trim(),
          "username":username.toString().trim(),
          "email":email.toString().trim(),
          "number":number.toString().trim(),
          "bio":bio.trim(),

          "fcmToken":fcm,
          // "storage":"7516192768".toString().trim(),
          // "purchased":"0000".toString().trim(),
          // "used":"0000".toString().trim(),
          // "profileType":"Human".toString().trim(),
          "profile":profile==null?PROFILEB64:profile,
         // "createdDate":DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + DateTime.now().hour.toString()+":"+DateTime.now().minute.toString(),


        }


    );

    rslt=true;

   // showToastSuccess(sucesscode);
    var nm = await setSharedPrefrence(NAME, name);
    var num = await setSharedPrefrence(NUMBER, number);
    var em = await setSharedPrefrence(EMAIL, email);
    var un = await setSharedPrefrence(UNAME, username);
    var bi = await setSharedPrefrence(BIO, bio);
    var img = await setSharedPrefrence(IMG, profile==null?PROFILEB64:profile);

    showToastSuccess("Account Updated!");

  //  Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
     showToastSuccess(errorcode);
  });

  return rslt;
}