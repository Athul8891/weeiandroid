import 'package:firebase_database/firebase_database.dart';
import 'package:random_string/random_string.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkLastRoomAndDelete.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerScreen.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen2.dart';
// import 'package:timezone/browser.dart' as tz;
import 'package:timezone/standalone.dart' as tz;
final databaseReference = FirebaseDatabase.instance.reference();
var response;

final FirebaseAuth auth = FirebaseAuth.instance;
final  uid = auth.currentUser!.uid;
void checkAndCreateSession(context,path,private,sessionType,ConcatenatingAudioSource) async{

  var code = randomNumeric(7);
  //var code = "060625";
  databaseReference.child("channel").child(code.toString()).once().then(( snapshot) {
   // print('Connected to second database and read ${snapshot.snapshot.value}');
    if(snapshot.snapshot.value==null){
      createData(code,context,path,private,sessionType,ConcatenatingAudioSource);
       response=true;
    }else{
      print("thappunnu");
      checkAndCreateSession(context,path,private,sessionType,ConcatenatingAudioSource);
       response=false;

    }

  });

  return response;
}


void createData(code,context,path,private,sessionType,ConcatenatingAudioSource)async{
  var name = await getSharedPrefrence(NAME);
  var img = await getSharedPrefrence(IMG);

 // await tz.initializeTimeZone();
  var detroit = tz.getLocation('Indian/Reunion');
  var now = tz.TZDateTime.now(detroit);

  // print("indiannn");
  // print(now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString()+"  -  "+now.hour.toString() +":"+now.minute.toString());
  print(now.millisecondsSinceEpoch);

  databaseReference.child("channel").child(code).set({
     'time': '00000',
     'gmt': now.millisecondsSinceEpoch.toString(),
    'videoType': 'storage',
    'intialStart': 'false',
    'playlist': path,
    'thumbnail': "",
    'controller': 'pause',
    'playing': code,
    'adminId': uid,
    'url': "",
    'chat': "",
    'currentIndex': "0",
    'index': "0",
    'name': "name",
    'exit': 'false',
    'channelType': sessionType,
    'private': private.toString(),

  }).whenComplete((){
    databaseReference.child('channel').child(code.toString()+"/joins").child(uid).update({
      "status": true,
      "img": img,
      "name": name,
      "uid": uid,
    }).whenComplete((){
        checkLastRoom(code);
      if(sessionType=="VIDEO" ||sessionType=="INSTA_VIDEO"||sessionType=="FB_VIDEO" ){
        NavigatePageRelace(context, VideoPlayerScreen2(id: code,type: "CREATE",path: path,));

      }

      if(sessionType=="AUDIO"||sessionType=="INSTA_AUDIO"||sessionType=="FB_AUDIO"){
        NavigatePageRelace(context, audioPlayerScreen(id: code,type: "CREATE",path: path,concatenatingAudioSource:ConcatenatingAudioSource));

      }

      if(sessionType=="YTVIDEO"){
        NavigatePageRelace(context, VideoPlayerScreen2(id: code,type: "CREATE",path: path,));

      }
      if(sessionType=="YTAUDIO"){
        NavigatePageRelace(context, audioPlayerScreen(id: code,type: "CREATE",path: path,concatenatingAudioSource:ConcatenatingAudioSource));

      }
    });
  });


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

