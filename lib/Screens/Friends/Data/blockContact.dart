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
import 'package:weei/Screens/Friends/Data/removeContact.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/clearMessages.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future blockContact(myid,partnerId,path) async {
//  showProgress("Processing the entry...");


 print("Blocccccck");
 print(path);

 print(myid);
 print(partnerId);

  ///me
  await _firestore.collection('Friend').doc(myid).collection(myid).doc(partnerId).update(
      {

        'blocked': true,
        'accepted': false,


      }).then((value)async{

      var rsp = await clearMessages(path);
      var rspd = await eraseContact(myid,partnerId,path);

    //Navigator.of(context).pop();
  }).catchError((error) {

  });





  return rslt;
}



Future eraseContact(orginId,partnerId,path) async {
//  showProgress("Processing the entry...");




  ///me
  await _firestore.collection('Friend').doc(partnerId).collection(partnerId).doc(orginId).delete().then((value)async{



    //Navigator.of(context).pop();
  }).catchError((error) {

  });





  return rslt;
}



