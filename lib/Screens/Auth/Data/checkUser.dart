import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Toast.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rslt ;




Future checkIfUserExists(id) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = _firestore.collection('Users');

    var doc = await collectionRef.doc(id).get();
    // return doc.exists;

    if(doc.exists){
      rslt = true;
    } else{
      rslt = false;
    }
  } catch (e) {
    rslt = false;
    showToastSuccess(e.toString());
    throw e;
  }

  return rslt;
}