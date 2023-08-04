import 'dart:io';

import 'package:intl/intl.dart';

import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/sharedPref.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';
import 'package:weei/Screens/Auth/Data/logout.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();


var rslt;
Future getFromUsers()async{
  final  uid = auth.currentUser!.uid;


  await _firestore
      .collection('Users').doc(uid).get().then((DocumentSnapshot documentSnapshot) async{

    print('Document data: ${documentSnapshot.data()}');



    var   name =  documentSnapshot.get('name');
    var   number =  documentSnapshot.get('number');
    var   email =  documentSnapshot.get('email');
    var   profile =  documentSnapshot.get('profile');
    var   uid =  documentSnapshot.get('uid');
    var   username =  documentSnapshot.get('username');
    var   bi =  documentSnapshot.get('bio');

    if (Platform.isAndroid) {

      var awa = await getInitainlData('android');
    } else if (Platform.isIOS) {
      var awa = await getInitainlData('ios');

    }
    updateFcm(uid);
    var sav = await saveAll(name,number,email,profile,uid,username,bi );




    // else {
    //
    //  var c  = await addToPatients(num,name);
    //  print('Document does not exist on the database');
    //  rslt = c;
    //
    // }

    return rslt;
  }).catchError((error) async{
    // dismissProgress();
    rslt =0;
   // signOut();

    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      signOut();
      showToastSuccess("Unexpected failure occurred! Close and reopen the app .");
    } else {


      showToastSuccess("Unexpected failure occurred! Check your internet connection.");

    }


    return rslt;
  });





  print("rsltt");
  print(rslt);
  return rslt;


}

updateFcm(uid)async{
  var fcm = await getSharedPrefrence(FCM);
  await _firestore.collection('Users').doc(uid.toString()).update(
      {

        //"uid":uid.toString(),
        "fcmToken":fcm,

      }

  ).then((value)async{

    databaseReference.child('Users').child(uid.toString()).update(

        {

          // "uid":uid.toString(),
          "fcmToken":fcm,


        }


    );

});}

void noConnectionPopUp(context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xff1e1e1e),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      content: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Text('No connection', style: size14_600W),
                    Spacer(),
                    Icon(Icons.wifi, color: grey, size: 20)
                  ],
                ),
                const Divider(
                  color: const Color(0xff2F2E41),
                  thickness: 1,
                ),
                const Text(
                    "Please check your internet connection and try again.",
                    style: size14_500Grey),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          }),
      actions: const [Text("Try again", style: size16_600G)],
      actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
    ),
  );
}