import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';




final databaseReference = FirebaseDatabase.instance.reference();

FirebaseFirestore _firestore = FirebaseFirestore.instance;

controlJoins(code,uid,control){


  switch (control.toString()) {
    case "false":
    // do something
      databaseReference.child('channel').child(code+"/joins").child(uid).update({
        'status': true.toString(),
      });
      break;
    case "true":
      databaseReference.child('channel').child(code+"/joins").child(uid).update({
        'status': "exit",
      }).whenComplete((){
        deleteJoins(code,uid);

      });
      break;




  }

}

deleteJoins(code,uid){

  databaseReference.child('channel').child(code+"/joins").child(uid).remove();


}


closeTheRoom(code,context)async{



      databaseReference.child('channel').child(code).update({
        'exit': true.toString(),
      }).then((value){ databaseReference.child('channel').child(code).remove();
       _firestore.collection('Chat').doc(code).delete().then((value)async{



         databaseReference.child('channel').child(code).remove();
         databaseReference.child('time').child(code).remove();




        //Navigator.of(context).pop();
      });

      });





  }



