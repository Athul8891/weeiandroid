import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';




final databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth auth = FirebaseAuth.instance;
final  uid = auth.currentUser!.uid;


var  used ="0000";
var  storage ="0000";
var  purchased ="0000";
var  totalGoingToUpload =000;
var  rsp;


Future getStorage(uploading) async {


         print(uid.toString());

 var rsp = await databaseReference.child('Users').child(uid.toString()).once().then(( snapshot) async {


        used = snapshot.snapshot.child('used').value.toString();
        storage = snapshot.snapshot.child('storage').value.toString();
        purchased = snapshot.snapshot.child('purchased').value.toString();







  // ignore: void_checks
  });

         for (var i = 0; i < uploading.length; i++) {

           totalGoingToUpload = totalGoingToUpload+int.parse(uploading[i].toString());

         }

         if((totalGoingToUpload+int.parse(used.toString()))<(int.parse(storage.toString())+int.parse(purchased.toString()))){
           rsp = true;
         }else{
           rsp = false;
         }

         print("totalGoingToUpload");
         print(totalGoingToUpload);
         print((totalGoingToUpload+int.parse(used.toString())));
         print(storage);

         return [rsp,(totalGoingToUpload+int.parse(used.toString()))];

}


Future addToStorage(val) async {


var use="00" ;
var store="00" ;
var  purch="00" ;
    var rsp = await databaseReference.child('Users').child(uid.toString()).once().then(( snapshot) async {


      use = snapshot.snapshot.child('used').value.toString();
     store = snapshot.snapshot.child('storage').value.toString();
    purch = snapshot.snapshot.child('purchased').value.toString();







    // ignore: void_checks
  });
  databaseReference.child('Users').child(uid.toString()).update(

      {


        "used":(int.parse(val.toString())+int.parse(use.toString())).toString(),



      }


  );
}


Future dltToStorage(val) async {



  databaseReference.child('Users').child(uid.toString()).update(

      {


        "used":val.toString(),



      }


  );
}