import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Home/SessionWaitingScreen.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerScreen.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen2.dart';
import 'package:just_audio/just_audio.dart';

final databaseReference = FirebaseDatabase.instance.reference();
var response;

final FirebaseAuth auth = FirebaseAuth.instance;
final  uid = auth.currentUser!.uid;
 checkSessionExist(context,code) async{

  //var code = randomNumeric(7);
  //var code = "060625";
 var wait = await databaseReference.child("channel").child(code.toString()).once().then(( snapshot) async{
    // print('Connected to second database and read ${snapshot.snapshot.value}');
    if(snapshot.snapshot.value!=null){
      await checkPrivacy (code,context);
      //NavigatePage(context, WaitingScreen(id: code,type: "JOIN"));
    }else{
      print("thappunnu");

      response=false;
      showToastSuccess("Session code invalid!");

    }

  });

  return response;
}


checkPrivacy (code,context)async{
  final  uid = auth.currentUser!.uid;


  var wait = await databaseReference.child('channel').child(code).once().then(( snapshot) async {


    var  private = snapshot.snapshot.child('private').value;
    var  channelType = snapshot.snapshot.child('channelType').value;
    var  adminId = snapshot.snapshot.child('adminId').value;
    var  playlist = snapshot.snapshot.child('playlist').value;

    print("private..");
    print(private);

     if(uid==adminId){

       navigateAdmin(channelType,context,code,playlist);


    }else{


       if(private=="true"){

         var wait =await authenticateSession(code,false,context,channelType);
       }else{
         var wait =await  authenticateSession(code,true,context,channelType);
       }
     }


  });
}

authenticateSession(code,status,context,channelType)async{
   var name = await getSharedPrefrence(NAME);
   var img = await getSharedPrefrence(IMG);

   print("uidddd");
   final  uid = auth.currentUser!.uid;

   var wait = await databaseReference.child('channel').child(code.toString()+"/joins").child(uid).update({
    "status": status,
    "img": img,
    "name": name,
    "uid": uid,
  }).whenComplete((){


    if(status==false){
      NavigatePage(context, WaitingScreen(id: code,type: "JOIN",channelType:channelType));
    //  NavigatePage(context, WaitingScreen(id: code,type: "JOIN"));
    }else{

      print("ithippo egota");

      if(channelType=="VIDEO"){
        NavigatePage(context, VideoPlayerScreen2(id: code,type: "JOIN"));

      }

      if(channelType=="AUDIO"){
        NavigatePage(context, audioPlayerScreen(id: code,type: "JOIN",concatenatingAudioSource: ConcatenatingAudioSource(children: []),));

      }

      if(channelType=="YTVIDEO"){
        NavigatePage(context, VideoPlayerScreen2(id: code,type: "JOIN"));

      }
      if(channelType=="YTAUDIO"){
        NavigatePage(context, audioPlayerScreen(id: code,type: "JOIN",concatenatingAudioSource: ConcatenatingAudioSource(children: [])));

      }

    }
  });
}

navigateAdmin(sessionType,context,code,path){
  showToastSuccess("Getting back to your session");


  if(sessionType=="VIDEO"){
    NavigatePage(context, VideoPlayerScreen2(id: code,type: "CREATE",path: path,));

  }

  if(sessionType=="AUDIO"){
    NavigatePage(context, audioPlayerScreen(id: code,type: "CREATE",path: path,concatenatingAudioSource: ConcatenatingAudioSource(children: [])));

  }

  if(sessionType=="YTVIDEO"){
    NavigatePage(context, VideoPlayerScreen2(id: code,type: "CREATE",path: path,));

  }
  if(sessionType=="YTAUDIO"){
    NavigatePage(context, audioPlayerScreen(id: code,type: "CREATE",path: path,concatenatingAudioSource: ConcatenatingAudioSource(children: [])));

  }


}