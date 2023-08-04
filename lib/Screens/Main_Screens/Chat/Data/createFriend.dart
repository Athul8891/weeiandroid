import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:weei/Helper/generateTumbnail.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;


Future demoFriendFirebase() async {
//  showProgress("Processing the entry...");


   final  uid = auth.currentUser!.uid;
    var fid  =uid+"as";
  await _firestore.collection('Friends').doc(uid).collection(uid).doc(fid).set(
      {

        "friendUid":fid.toString(),
        'name': 'YVBot',
        'lastMessageTime':DateTime.now().millisecondsSinceEpoch,
        'lastMessage': "ok da",
        'opened': true,
        'profile': tstIcon,

        'type': "YVideoBot",


      }).then((value)async{



    rslt=true;

    showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
}

