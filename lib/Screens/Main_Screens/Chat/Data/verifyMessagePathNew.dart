import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:intl/intl.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
var rslt ;




Future verifyMessagePathNew(id1,id2) async {

  print(id1);
  print(id2);

    // Get reference to Firestore collection
    var collectionRef1 = await _firestore.collection('Chat').where('uIds',arrayContains: (id1+"-"+id2).toString() ).get().then((snapshot) async{
      if(snapshot.docs.isNotEmpty){

        snapshot.docs.single.get("messagePath");

        print("firstpath");

        //   rslt = (id1+"-"+id2);

         rslt=  snapshot.docs.single.get("messagePath");
        print(rslt);

        //  createPath(id1,id2,data);
      } else{


        rslt = await checkSecondPath(id1,id2);

        print("firsttttt");
        print(rslt);
      }



    }).catchError((error) {

      // showToastSuccess("Request failed");

      //  dismissProgress();
      rslt=false;
    });





  return rslt;
}

Future checkSecondPath(id1,id2) async {

    // Get reference to Firestore collection



    var collectionRef1 = await _firestore.collection('Chat').where('uIds',arrayContains: (id2+"-"+id1).toString() ).get().then((snapshot) async{
      if(snapshot.docs.isNotEmpty){
        print("startTime");
        print("secondpaath");
        print(snapshot.docs.single.get("startTime"));
        //   rslt = (id1+"-"+id2);

        rslt=  snapshot.docs.single.get("messagePath");
        //  createPath(id1,id2,data);
      } else{


       // rslt = await createPath(id1,id2,data) ;

        rslt =null;
      }



    }).catchError((error) {

       showToastSuccess(error.toString());

      //  dismissProgress();
      rslt=false;
    });



  return rslt;
}


Future createPathRobo(myId,hisId,hisData) async {
//  showProgress("Processing the entry...");

print("thirdd");
      print("daaaaaaaaata");
      print(hisData);
      print(hisData['type']);
      print(hisData['name']);

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);
  var email =await getSharedPrefrence(EMAIL);
  var un =await getSharedPrefrence(UNAME);
  var bio =await getSharedPrefrence(BIO);
   var fcmToken =await getSharedPrefrence(FCM);

var startTime=DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc((myId +"-"+hisId+"-"+startTime).toString()).set(
      {

           'uIds': [myId,hisId,(myId +"-"+hisId),(hisId +"-"+myId )],
          myId:{'email':email,'name':nm,'number':num,'profile':img,'uid':myId,'type':"Human",'username':un,'bio':bio,'fcmToken':fcmToken,'sendNoti':true},
          hisId:{'email':hisData['email'],'name':hisData['name'],'number':hisData['number'],'profile':hisData['profile'],'uid':hisId,'type':(hisData['profileType']==null?hisData['type']:hisData['profileType']),'username':hisData['username'],'bio':hisData['bio'],'fcmToken':"",'sendNoti':false},
         'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

         'startChat':  true,  ///key to archive // show to main chat
         'blocked':  false,
         'blockedBy':  '',
         'bothAccept':  true,
         'acceptPending':  "NILL",
         'mute'+hisId:  false,
         'mute'+myId:  false,
         // hisId+'Accept':  false,

         'messagePath':  (myId +"-"+hisId+"-"+startTime).toString(),
         'lastMessage':  "Request Accepted",
         'time':  DateFormat.jm().format(DateTime.now()).toString(),
         'startTime':  startTime,

      }).then((value)async{


    print("startTime");
    print("newpath");

    rslt=(myId +"-"+hisId+"-"+startTime).toString();
   // rslt=(myId +"-"+hisId);

    //showToastSuccess("Requested");


    //Navigator.of(context).pop();
  }).catchError((error) {

   // showToastSuccess("Request failed");

    //  dismissProgress();
    rslt=false;
  });

  return rslt;
}

Future createPathNew(myId,hisId,hisData) async {
//  showProgress("Processing the entry...");

  print("thirdd");
  print("daaaaaaaaata");
  print(hisData['type']);
  print(hisData['name']);

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);
  var email =await getSharedPrefrence(EMAIL);
  var un =await getSharedPrefrence(UNAME);
  var bio =await getSharedPrefrence(BIO);
  var fcmToken =await getSharedPrefrence(FCM);
  var startTime=DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc((myId +"-"+hisId+"-"+startTime).toString()).set(
      {

        'uIds': [myId,hisId,(myId +"-"+hisId),(hisId +"-"+myId )],
        myId:{'email':email,'name':nm,'number':num,'profile':img,'uid':myId,'type':"Human",'username':un,'bio':bio,'fcmToken':fcmToken,'sendNoti':true},
        hisId:{'email':hisData['email'],'name':hisData['name'],'number':hisData['number'],'profile':hisData['profile'],'uid':hisId,'type':(hisData['profileType']==null?hisData['type']:hisData['profileType']),'username':hisData['username'],'bio':hisData['bio'],'fcmToken':hisData['fcmToken'],'sendNoti':true},
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'startChat':  false,  ///key to archive // show to main chat
        'blocked':  false,
        'blockedBy':  '',
        'bothAccept':  false,
        'acceptPending':  hisId,
        'mute'+hisId:  false,
        'mute'+myId:  false,
        // hisId+'Accept':  false,

        'messagePath':  (myId +"-"+hisId+"-"+startTime).toString(),
        'lastMessage':  "Message Request",
        'time':  DateFormat.jm().format(DateTime.now()).toString(),
        'startTime':  startTime,

      }).then((value)async{


    print("startTime");
    print("newpath");

    rslt=(myId +"-"+hisId+"-"+startTime).toString();
    // rslt=(myId +"-"+hisId);

    showToastSuccess("Requested");


    //Navigator.of(context).pop();
  }).catchError((error) {

    showToastSuccess("Request failed");

    //  dismissProgress();
    rslt=false;
  });

  return rslt;
}
acceptMessage(mesagePath)async{
  await _firestore.collection('Chat').doc(mesagePath).update(
      {


        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),
        'time':  DateFormat.jm().format(DateTime.now()).toString(),
        'lastMessage': "Chat request accepted",
        'startChat': true,
        'bothAccept': true,
        'acceptPending': "NILL",


      }).then((value)async{
    print("trueeee");

  rslt =true;
     showToastSuccess("Accepted");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    showToastSuccess("Failed to accept");

   // showToastSuccess(ERRORCODE);
    rslt =false;

  });
   return rslt;
}
blockUser(mesagePath,myId)async{
  await _firestore.collection('Chat').doc(mesagePath).update(
      {



        'blocked': true,
        'blockedBy': myId,
        'lastMessage':  "You blocked this user",
        'time':  DateFormat.jm().format(DateTime.now()).toString(),
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

      }).then((value)async{
    print("trueeee");
   rslt=true;

    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;

  });
 return rslt;
}

unblockUser(mesagePath,myId)async{
  await _firestore.collection('Chat').doc(mesagePath).update(
      {



        'blocked': false,
        'blockedBy': '',
        'lastMessage':  "You unblocked this user",
        'time':  DateFormat.jm().format(DateTime.now()).toString(),
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

      }).then((value)async{
    print("trueeee");
    rslt=true;

    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;

  });
  return rslt;
}
///clear chat
clearChat(mesagePath,myId,hisId,hisData)async{
  await _firestore.collection('Chat').doc(mesagePath).delete().then((value)async{
    print("trueeee");


    //  showToastSuccess("Upload Success");
    createPathAfterClear(myId,hisId,hisData);

    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

}
Future createPathAfterClear(myId,hisId,hisData) async {
//  showProgress("Processing the entry...");

  print("thirdd");
  print("daaaaaaaaata");
  print(hisData['type']);
  print(hisData['name']);

  var img = await getSharedPrefrence(IMG);
  var nm =await getSharedPrefrence(NAME);
  var num =await getSharedPrefrence(NUMBER);
  var email =await getSharedPrefrence(EMAIL);
  var un =await getSharedPrefrence(UNAME);
  var bio =await getSharedPrefrence(BIO);
  var fcmToken =await getSharedPrefrence(FCM);

  var startTime=DateTime.now().millisecondsSinceEpoch.toString();
  await _firestore.collection('Chat').doc((myId +"-"+hisId+"-"+startTime).toString()).set(
      {

        'uIds': [myId,hisId,(myId +"-"+hisId),(hisId +"-"+myId )],
        myId:{'email':email,'name':nm,'number':num,'profile':img,'uid':myId,'type':"Human",'username':un,'bio':bio,'fcmToken':fcmToken,'sendNoti':true},
        hisId:{'email':hisData['email'],'name':hisData['name'],'number':hisData['number'],'profile':hisData['profile'],'uid':hisId,'profileType':hisData['type'],'username':hisData['username'],'bio':hisData['bio'],'fcmToken':hisData['fcmToken'],'sendNoti':true},
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'startChat':  true,  ///key to archive // show to main chat
        'blocked':  false,
        'blockedBy':  '',
        'bothAccept':  true,
        'acceptPending':  "NILL",
        'mute'+hisId:  false,
        'mute'+myId:  false,
        // hisId+'Accept':  false,

        'messagePath':  (myId +"-"+hisId+"-"+startTime).toString(),
        'lastMessage':  "Message Cleared",
        'time':  DateFormat.jm().format(DateTime.now()).toString(),
        'startTime':  startTime,

      }).then((value)async{


    print("startTime");
    print("newpath");

    rslt=true;
    // rslt=(myId +"-"+hisId);




    //Navigator.of(context).pop();
  }).catchError((error) {



    //  dismissProgress();
    rslt=false;
  });

  return rslt;
}
///clear chat


deleteRquest(mesagePath)async{
  await _firestore.collection('Chat').doc(mesagePath).delete().then((value)async{
    print("trueeee");


    //  showToastSuccess("Upload Success");
    rslt=true;

    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;

  });
      return rslt;
}