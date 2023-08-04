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


Future clearMessages(mesagePath) async {
//  showProgress("Processing the entry...");


  print("clearPathh");
  print(mesagePath);
  final  uid = auth.currentUser!.uid;
  var img = await getSharedPrefrence(IMG);
  var nm = await getSharedPrefrence(NAME);
  await _firestore.collection('Chat').doc(mesagePath).delete().then((value)async{





    showToastSuccess("Clear");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
}

