import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:weei/Helper/generateTumbnail.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;
var thumbnail  ;


Future uploadToFirebase(fileId,fileName,fileSize,fileType,fileUrl,filePath,fileStatus) async {
//  showProgress("Processing the entry...");

  if(fileType=="VIDEO"){
    thumbnail = await generateTumbnail(fileUrl);
  }
   final  uid = auth.currentUser!.uid;

  await _firestore.collection('Media').doc(fileId.toString()).set(
      {

        "userId":uid.toString(),
        "fileId":fileId.toString(),
        "fileName":fileName.toString().trim(),
        "fileSize":fileSize.toString().trim(),
        "fileThumb":thumbnail,

        "fileType":fileType.toString().trim(),
        "fileOwner":true,
        "uploadAt":DateTime.now().toIso8601String(),

        "fileUrl":fileUrl.toString().trim(),
        "filePath":filePath.toString().trim(),
        "fileStatus":fileStatus,

        "createdTime":DateFormat.yMMMd().format(DateTime.now()).toString() +" at "+DateFormat.jm().format(DateTime.now()),


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