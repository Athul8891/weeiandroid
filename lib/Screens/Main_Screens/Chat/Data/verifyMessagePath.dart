import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rslt ;




Future verifyMessagePath(id1,id2,data) async {

  print(id1);
  print(id2);
  try {
    // Get reference to Firestore collection
    var collectionRef1 = await _firestore.collection('Chat').where('uIds',arrayContains: (id1+"-"+id2).toString() ).get().then((snapshot) async{
      if(snapshot.docs.isNotEmpty){

        print("firstpath");
        print(snapshot.docs.single.get("startTime"));
        print(snapshot.docs.single);
        print("firstpath");

        //   rslt = (id1+"-"+id2);

        rslt = [snapshot.docs.single.get("messagePath"),snapshot.docs.single.get("startTime")];

        //  createPath(id1,id2,data);
      } else{


        rslt = await checkSecondPath(id1,id2,data);

        print("firsttttt");
        print(rslt);
      }



    });


   //
   //  var collectionRef = _firestore.collection('Chat');
   //
   //  var doc = await collectionRef.doc(id1+"-"+id2).get();
   //  // return doc.exists;
   //
   //  if(doc.exists){
   //    print("startTime");
   //    print("firstpath");
   //    print(doc.get("startTime"));
   // //   rslt = (id1+"-"+id2);
   //    rslt = [(id1+"-"+id2),doc.get("startTime")];
   //
   //  //  createPath(id1,id2,data);
   //  } else{
   //
   //
   //    rslt = await checkSecondPath(id1,id2,data);
   //
   //    print("firsttttt");
   //    print(rslt);
   //  }
  } catch (e) {
    rslt = false;
    showToastSuccess(e.toString());
    throw e;
  }

  return rslt;
}

Future checkSecondPath(id1,id2,data) async {
  try {
    // Get reference to Firestore collection



    var collectionRef1 = await _firestore.collection('Chat').where('uIds',arrayContains: (id2+"-"+id1).toString() ).get().then((snapshot) async{
      if(snapshot.docs.isNotEmpty){
        print("startTime");
        print("secondpaath");
        print(snapshot.docs.single.get("startTime"));
        //   rslt = (id1+"-"+id2);

        rslt = [snapshot.docs.single.get("messagePath"),snapshot.docs.single.get("startTime")];

        //  createPath(id1,id2,data);
      } else{


        rslt = await createPath(id1,id2,data) ;

        print("secondd");
        print(rslt);

        print("firsttttt");
        print(rslt);
      }



    });

    // var collectionRef = _firestore.collection('Chat');
    //
    // var doc = await collectionRef.doc(id2+"-"+id1).get();
    // // return doc.exists;
    //
    // if(doc.exists){
    // //  rslt = (id2+"-"+id1);
    //
    //   rslt = [(id2+"-"+id1),doc.get("startTime")];
    //
    //   print("startTime");
    //   print("secondpath");
    //   print(doc.get("startTime"));
    // //  createPath(id2,id1,data) ;
    //
    // } else{
    //
    //
    //   rslt = await createPath(id1,id2,data) ;
    //
    //   print("secondd");
    //   print(rslt);
    // }
  } catch (e) {
    rslt = false;
    showToastSuccess(e.toString());
    throw e;
  }

  return rslt;
}


Future createPath(myId,hisId,hisData) async {
//  showProgress("Processing the entry...");

print("thirdd");
      print("daaaaaaaaata");
      print(hisData['type']);
      print(hisData['name']);

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);
  var email =await getSharedPrefrence(EMAIL);
 var startTime=DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc((myId +"-"+hisId+"-"+startTime).toString()).set(
      {

           'uIds': [myId,hisId,(myId +"-"+hisId),(hisId +"-"+myId )],
          myId:{'email':email,'name':nm,'number':num,'profile':img,'uid':myId,'type':"Human",},
          hisId:{'email':hisData['email'],'name':hisData['name'],'number':hisData['number'],'profile':hisData['profile'],'uid':hisId,'type':hisData['type'],},
         'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

         'startChat':  false,
         'blocked':  false,
         'bothAccept':  false,
          myId+'Accept':  true,
          hisId+'Accept':  false,

         'messagePath':  (myId +"-"+hisId+"-"+startTime).toString(),
         'lastMessage':  "",
         'startTime':  startTime,

      }).then((value)async{


    print("startTime");
    print("newpath");

    rslt=[(myId +"-"+hisId+"-"+startTime).toString(),startTime];
   // rslt=(myId +"-"+hisId);

    //showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
  });

  return rslt;
}


