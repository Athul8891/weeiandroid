import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rslt ;




Future checkMessagePath(id1,id2) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = _firestore.collection('Chat');

    var doc = await collectionRef.doc(id1+"-"+id2).get();
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

Future checkSecondPath(id1,id2) async {
  try {
    // Get reference to Firestore collection
    var collectionRef = _firestore.collection('Chat');

    var doc = await collectionRef.doc(id2+"-"+id1).get();
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


Future createPath(myId,hisId,hisData) async {
//  showProgress("Processing the entry...");
      print("daaaaaaaaata");
      print(hisData['type']);
      print(hisData['name']);

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);
  var email =await getSharedPrefrence(EMAIL);

  await _firestore.collection('Chat').doc((myId +"-"+hisId).toString()).set(
      {

           'uIds': [myId,hisId],
          myId:{'email':email,'name':nm,'number':num,'profile':img,'uid':myId,'type':"Human",},
          hisId:{'email':hisData['email'],'name':hisData['name'],'number':hisData['number'],'profile':hisData['profile'],'uid':hisId,'type':hisData['type'],},
         'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'startChat':  false,
        'lastMessage':  "",
        'startTime':  DateTime.now().millisecondsSinceEpoch.toString(),

      }).then((value)async{




    rslt=true;

    //showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
  });

  return rslt;
}


