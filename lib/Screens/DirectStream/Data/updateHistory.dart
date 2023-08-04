import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';






FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future upadteHistory(url,type,doc) async {
//  showProgress("Processing the entry...");
//   final birthday = DateTime(1967, 10, 12);
//   final date2 = DateTime.now();
//   final difference = date2.difference(birthday).inMilliseconds;

if(doc==null){
  final  uid = auth.currentUser!.uid;


  await _firestore.collection('StreamHistory').add(
      {

        "uid":uid.toString(),

        "url":url,

        "type":type,
        "stamp":DateTime.now().toIso8601String(),

        "createdDate":DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + DateFormat.jm().format(DateTime.now()).toString(),


      }

  );
}else{

  final  uid = auth.currentUser!.uid;


  await _firestore.collection('StreamHistory').doc(doc).update(
      {

        // "uid":uid.toString(),
        //
        // "url":url,
        //
        // "type":type,
        "stamp":DateTime.now().toIso8601String(),
        //
        // "createdDate":DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + DateFormat.jm().format(DateTime.now()).toString(),


      }

  );
}

}

Future deleteHistory(id,) async {
//  showProgress("Processing the entry...");
//   final birthday = DateTime(1967, 10, 12);
//   final date2 = DateTime.now();
//   final difference = date2.difference(birthday).inMilliseconds;
  final  uid = auth.currentUser!.uid;


  await _firestore.collection('StreamHistory').doc(id).delete().then((value)async{

    // await _firestore.collection('Contents').doc(docId).update({'watchlist': FieldValue.arrayUnion([uid])});



    rslt=true;




    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;

  });

  return rslt;
}