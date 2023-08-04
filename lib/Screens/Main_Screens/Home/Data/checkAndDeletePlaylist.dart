import 'package:firebase_database/firebase_database.dart';
import 'package:random_string/random_string.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerScreen.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen2.dart';

final databaseReference = FirebaseDatabase.instance.reference();
var response;

final FirebaseAuth auth = FirebaseAuth.instance;

checkAndDeletePlaylist() async{
  final  uid = auth.currentUser!.uid;
  //var code = randomNumeric(7);
  //var code = "060625";
  var wait = await databaseReference.child("session").child(uid).once().then(( snapshot) async{
    // print('Connected to second database and read ${snapshot.snapshot.value}');
    if(snapshot.snapshot.value!=null){
      databaseReference.child("session").child(uid).remove();
      //NavigatePage(context, WaitingScreen(id: code,type: "JOIN"));
    }

  });

  return response;
}
