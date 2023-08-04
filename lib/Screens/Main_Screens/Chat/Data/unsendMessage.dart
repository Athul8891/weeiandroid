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


Future unsendMessage(mesagePath,messageId) async {
//  showProgress("Processing the entry...");



  final  uid = auth.currentUser!.uid;
  var img = await getSharedPrefrence(IMG);
  var nm = await getSharedPrefrence(NAME);
  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(messageId).delete().then((value)async{






    updateMessage(mesagePath);

    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
}

updateMessage(mesagePath)async{
  await _firestore.collection('Chat').doc(mesagePath).update(
      {


        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),

        'lastMessage': "𝘔𝘦𝘴𝘴𝘢𝘨𝘦 𝘳𝘦𝘮𝘰𝘷𝘦𝘥",
        'startChat': true,


      }).then((value)async{



    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

  });

}
