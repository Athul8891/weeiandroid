import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;


FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rslt ;


final  uid = auth.currentUser!.uid;

Future checkReq(id) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = _firestore.collection('Friend');

    var doc = await collectionRef.doc(id).collection(id).doc(uid).get();
    // return doc.exists;

    if(doc.exists){

      if(doc['blocked']==true){

        showToastSuccess("Request failed !");

        return null;

      }
       if(doc['accepted']==false){

         rslt = true;
       }else{
         rslt = false;
       }

    } else{
      print("doc.get('accepted')");

      rslt = false;
    }
  } catch (e) {
    rslt = false;
    showToastSuccess(e.toString());

  }

  return rslt;
}