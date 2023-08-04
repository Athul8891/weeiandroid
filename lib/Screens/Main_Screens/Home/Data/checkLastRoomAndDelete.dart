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


final FirebaseAuth auth = FirebaseAuth.instance;




checkLastRoom(code)async{


  var room = await getSharedPrefrence(LASTROOM);
  if(room!=null){
   databaseReference.child("channel").child(room.toString()).remove();
  }

  var set = await setSharedPrefrence(code, LASTROOM);
}

// void demoFreind(){
//   var nw = DateTime.now();
//   var iiid = "xxxxxxsdxxxxxxxxxxxx";
//   databaseReference.child("friendList").child("EZypBJHwk4MtztMyuvMjCxwNWIh1").child(DateTime.now().millisecondsSinceEpoch.toString()).set({
//     'profile': tstIcon,
//     'name': 'latest',
//     'lastMessageTime':DateTime.now().millisecondsSinceEpoch,
//     'lastMessage': "ok da",
//     'opened': true,
//     'uid': iiid,
//     'type': "Human",
//
//
//
//   });
// }

