
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
final yt = YoutubeExplode();
FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
var rslt  ;

Future<dynamic> getSong(message,mesagePath,botData) async {
         print("message");
         print(message);
         print(message.contains("you"));
   if(message.contains("you")==true){

      if(message.contains("playlist")==true)  {
       final  playlist = await yt.playlists.get('https://www.youtube.com/playlist?list='+(message.split('=').last.toString()));
       sendMeassageBot(mesagePath,message,botData['type'].toString().toUpperCase(),botData,true,playlist.url.toString() ,playlist.thumbnails.highResUrl.toString(),playlist.title.toString());
      }else{
        final song = await yt.videos.get(message.split('/').last.toString());
     //   final song = yt.videos.get(message.split('/').last.toString()).whenComplete(() { video=true;    }).catchError((error) {});



          sendMeassageBot(mesagePath,message,botData['type'].toString().toUpperCase(),botData,false,song.url.toString() ,song.thumbnails.highResUrl.toString(),song.title.toString());


      }



   }else{
     sendMeassageBot(mesagePath,"Sorry i cant find any result for this message","TEXT",botData,true,null,null,null);
   }



}


Future sendMeassageBot(mesagePath,message,type,friendData,isPlaylist, url ,mediaThumb,mediaName) async {
//  showProgress("Processing the entry...");


    var docu = DateTime.now().millisecondsSinceEpoch.toString();

  await _firestore.collection('Chat').doc(mesagePath).collection(mesagePath).doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
      {

        'message':message,
        'mesagePath':mesagePath,
        //'type':  type,
        'type':  type,
        'thumb': friendData['profile'],
        'name': friendData['name'],
        //'botType': friendData['type'].toString().toUpperCase(),
        'time': DateFormat.jm().format(DateTime.now()),

        'uId':  friendData['friendUid'],
        'stamp':  DateTime.now().millisecondsSinceEpoch.toString(),
        'isPlaylist': isPlaylist,

      //print(playlist.thumbnails.lowResUrl);
    //  print(playlist.title);
    //  print(playlist.url);
     // print(playlist.videoCount);
        'url':  url,
        'mediaThumb':  mediaThumb!=null? mediaThumb:"",
        'mediaName':   mediaName!=null? mediaName:"",
        'mediaType':  mediaThumb!=null?"YBOT":"",


      }).then((value)async{

      if(message=="Sorry i cant find any result for this message"){
        updateMessage(mesagePath,"Sorry i cant find any result for this message");

      }else{
        updateMessage(mesagePath,"Attechment 📎");

      }


    //  showToastSuccess("Upload Success");


    //Navigator.of(context).pop();
  }).catchError((error) {
    //  dismissProgress();

    print("errorrrrr");
    print(error);
    rslt=false;
    showToastSuccess(errorcode);
  });

  return rslt;
}