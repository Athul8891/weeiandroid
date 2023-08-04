//
//
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
//
//
// final databaseReference = FirebaseDatabase.instance.reference();
// final FirebaseAuth auth = FirebaseAuth.instance;
//
// var current =0;
//
//  createSessionList(type,itemsId,itemsName,itemsThumb,itemsUrl) async {
// //  showProgress("Processing the entry...");
//
//   final  uid = auth.currentUser!.uid;
//
//
//
//   for (var i = 0; i < itemsId.length; i++) {
//
//       var rsp = await    databaseReference.child("session").child(uid).child(itemsId[i]).update({
//       'docId': itemsId[i],
//       'fileName':  itemsName[i],
//       'fileThumb': type=="VIDEO"? itemsThumb[i]:"",
//
//       'fileUrl':  itemsUrl[i],
//
//     });
//
//       print("iii");
//       print(i);
//
//       current=i+1;
//
//   }
//
//   return current;
//
//
// }