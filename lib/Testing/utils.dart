import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Utils {
  static Future<String> getFileUrl(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileName";
  }
}


Future addToPatients(data) async {
//  showProgress("Processing the entry...");
  print("dataaaa");
  print(data);

  await _firestore.collection('test').add(
      {
        "data":data.toString().trim(),


      }).then((value)async{



    //  dismissProgress();



    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();
       print("errorrrr");
       print(error);
  });

  return "rslt";
}