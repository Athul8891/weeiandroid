import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;
var thumbnail  ;


Future uploadPlaylistFirestore(playlistName,playlistType,playlistSize,playlistPath,public) async {
//  showProgress("Processing the entry...");


  final  uid = auth.currentUser!.uid;

  await _firestore.collection('Playlist').add(
      {

        "userId":uid.toString(),
        "playlistName":playlistName.toString(),
        "playlistType":playlistType.toString().trim(),
       // "playlistIcon":playlistIcon.toString().trim(),
        "public":public,
        "ALL":"ALL",

        "playlistSize":playlistSize.toString().trim(),

        "uploadAt":DateTime.now().toIso8601String(),

        "playlistPath":playlistPath.toString(),



      }).then((value)async{



    rslt=true;




    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
  });

  return rslt;
}


Future editPrivacyPlaylistFirestore(doc,public) async {
//  showProgress("Processing the entry...");


  final  uid = auth.currentUser!.uid;

  await _firestore.collection('Playlist').doc(doc).update({


        "public":true





      }).then((value)async{



    rslt=true;




    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

  return rslt;
}

Future updatePlaylistCountFirestore(doc,count) async {
//  showProgress("Processing the entry...");


  final  uid = auth.currentUser!.uid;

  await _firestore.collection('Playlist').doc(doc).update({


        "playlistSize":count.toString()





      }).then((value)async{



    rslt=true;




    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

  return rslt;
}


Future dltPlaylistDocument(id) async{





  await _firestore.collection('Playlist').doc(id).delete().then((value){
    rslt = 1;
    //Navigator.of(context).pop();



  })
      .catchError((error) {
    rslt =0;


  });

  return rslt ;
}