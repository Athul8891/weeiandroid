import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
// import 'package:weei/Screens/Main_Screens/Data/checkOngoingSession.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkOngoingSession.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerLocal.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerScreen.dart';
import 'package:weei/Screens/Playlist/selectPlaylistForSession.dart';
import 'package:weei/Screens/VideoSession/videoPlayerLocal.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen2.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:direct_link/direct_link.dart';

import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';

class loadInAppPlayer extends StatefulWidget {
  final type;
  final private;
  final isPlaylist;
  final item;
  final path;
  loadInAppPlayer({this.type,this.private,this.isPlaylist,this.item,this.path});
  @override
  _AddNewVideoScreenState createState() => _AddNewVideoScreenState();
}

class _AddNewVideoScreenState extends State<loadInAppPlayer> {
  String dropdownvalue = 'Private';
  FlutterInsta flutterInsta =
  FlutterInsta();
  var itemsData=[];

   var playlistLength =0;
  bool chk = false;
  bool adding = false;
  bool tap = false;
  var addedNum=0;


  final databaseReference = FirebaseDatabase.instance.reference();
  final yt = YoutubeExplode();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
   var pageClosed = false;

  @override
  void dispose() {
    setState(() {
      pageClosed = true;
    });
  }

  @override
  void initState() {

    Future.delayed(const Duration(minutes: 1), () {

// Here you can write your code
   if(pageClosed==false){
     Navigator.pop(context);
     showToastSuccess("Failed to load!");
   }

    });
    if(widget.isPlaylist.toString()=="true"){
      this.playPlaylist();

    }else{
      this.playSingle();

    }
  }
  playSingle()async{
    if(widget.type=="YTVIDEO"){
      fetchYtSingle();

    }
    if(widget.type=="YTAUDIO"){
      fetchYtSingle();

    }
    if(widget.type=="VIDEO"){
      fetchLocalSingle();

    }
    if(widget.type=="AUDIO"){

      fetchLocalSingle();

    }

    if(widget.type=="INSTA_AUDIO"){
      playInstaAudio(widget.item['url']);

    }
    if(widget.type=="INSTA_VIDEO"){
      playInstaVideo(widget.item['url']);

    }


    if(widget.type=="FB_AUDIO"){
      playFbAudio(widget.item['url']);

    }
    if(widget.type=="FB_VIDEO"){
      playFbVideo(widget.item['url']);

    }
  }

     playPlaylist(){
    if(widget.type=="YTVIDEO"){

      fetchYtPlaylist();
    }
    if(widget.type=="YTAUDIO"){

      fetchYtPlaylist();
    }
    if(widget.type=="VIDEO"){


      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigatePageRelace(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));

      });
     ///pass with path
    }
    if(widget.type=="AUDIO"){


      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigatePageRelace(context, audioPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));

      });
      ///pass with path

    }

  }

   fetchLocalSingle()async {


   // var itDat = [];
   // itDat.add({
   //   'docId': widget.item['url'],
   //   'fileName':   widget.item['mediaName'],
   //   'fileThumb':  widget.item['mediaThumb'],
   //   'fileUrl':   widget.item['url'],
   //   'fileType':  widget.type,
   // });

   setState(() {
     itemsData.add(


         {
           'docId': widget.item['url'],
           'fileName':   widget.item['mediaName'],
           'fileThumb':  widget.item['mediaThumb'],
           'fileUrl':   widget.item['url'],
           'fileType':  widget.type,
         }


         );
   });



   if(widget.type=="VIDEO"){
     WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigatePageRelace(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));

     });
     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
     //     VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url'])), (Route<dynamic> route) => false);

  //NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itDat,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));


   }else{

     WidgetsBinding.instance.addPostFrameCallback((_) {
       NavigatePageRelace(context, audioPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));

     });
   }





  }
  fetchLocalPlaylist()async{


  }
  fetchYtPlaylist()async  {

    await for (var video in yt.playlists.getVideos(widget.item['url'])) {


      setState(() {

        pageClosed = true;
      itemsData.add({
        'docId': video.url,
        'fileName':  video.title,
        'fileThumb': video.thumbnails.highResUrl,

        'fileUrl':  video.url,
        'fileType':  widget.type,

      });
      });

    }
    if(widget.type=="YTVIDEO"){
      NavigatePageRelace(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));


    }else{

      NavigatePageRelace(context, audioPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));

    }

  }

  fetchYtSingle()async{

     print(widget.item['url']);
    final video = await yt.videos.get(widget.item['url']);
    print("videoxxxxxx");
    print(video.url);

     setState(() {
       pageClosed = true;
       itemsData.add({
         'docId': video.url,
         'fileName':  video.title,
         'fileThumb': video.thumbnails.highResUrl,

         'fileUrl':  video.url,
         'fileType':  widget.type,

       });

     });


    if(widget.type=="YTVIDEO"){
      NavigatePageRelace(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));
    }else{
   //   NavigatePageRelace(context, audioPlayerScreen(id: 00,type: "CREATE",path: widget.path ,));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigatePageRelace(context, audioPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:widget.type,isPlaylist:widget.isPlaylist,url:widget.item['url']));

      });

    }
  }
  void playInstaAudio(url) async {
    var s = await flutterInsta
        .downloadReels(url);

    setState(() {
      itemsData.add(


          {
            'docId':s,
            'fileName':   url,
            'fileThumb':  webIcon,
            'fileUrl':   s,
            'fileType':  "INSTA_AUDIO",
          }


      );
    });

    NavigatePageRelace(context, audioPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:"INSTA_AUDIO",isPlaylist:widget.isPlaylist,url:s));

  }
  void playInstaVideo(url) async {


    var s = await flutterInsta.downloadReels(url);

    setState(() {
      itemsData.add(


          {
            'docId':s,
            'fileName':   url,
            'fileThumb':  webIcon,
            'fileUrl':   s,
            'fileType':  "INSTA_VIDEO",
          }


      );
    });

    NavigatePageRelace(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:"INSTA_VIDEO",isPlaylist:widget.isPlaylist,url:s));

  }

  void playFbAudio(url) async {
    var check = await DirectLink.check(url); // add your url
     var s ;
    if (check != null) {
      // null condition
      for (var element in check!) {
        print("element.quality");
        // print(element.quality);

        setState(() {
          s =element.link;
        });
        print(element.link);
      }

    }

    setState(() {
      itemsData.add(


          {
            'docId':s,
            'fileName':   url,
            'fileThumb':  webIcon,
            'fileUrl':   s,
            'fileType':  "FB_AUDIO",
          }


      );
    });

    NavigatePageRelace(context, audioPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:"FB_AUDIO",isPlaylist:widget.isPlaylist,url:s));

  }
  void playFbVideo(url) async {
    var check = await DirectLink.check(url); // add your url
    var s ;
    if (check != null) {
      // null condition
      for (var element in check!) {
        print("element.quality");
        // print(element.quality);

        setState(() {
          s =element.link;
        });
        print(element.link);
      }

    }

    setState(() {
      itemsData.add(


          {
            'docId':s,
            'fileName':   url,
            'fileThumb':  webIcon,
            'fileUrl':   s,
            'fileType':  "FB_VIDEO",
          }


      );
    });

    NavigatePageRelace(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: itemsData,index: 0, playingType:"FB_VIDEO",isPlaylist:widget.isPlaylist,url:s));

  }
//   createSessionList(type,itemsId,itemsName,itemsThumb,itemsUrl) async {
// //  showProgress("Processing the entry...");
//       print("step 1");
//     final  uid = auth.currentUser!.uid;
//
//
//
//     for (var i = 0; i < itemsId.length; i++) {
//
//       var rsp = await    databaseReference.child("session").child(uid).child(i.toString()).update({
//         'docId': itemsId[i],
//         'fileName':  itemsName[i],
//         'fileThumb': type=="VIDEO"? itemsThumb[i]:"",
//
//         'fileUrl':  itemsUrl[i],
//         'fileType':  type,
//
//       });
//
//       print("step "+i.toString());
//
//   setState(() {
//     addedNum=i+1;
//     if(itemsId.length==addedNum){
//
//       print("step 2");
//
//       // adding=false;
//     // tap=false;
//      checkAndCreateSession(context,"session/"+uid,widget.private,widget.type);
//     }
//   });
//
//     }
//
//
//
//
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            )),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 15),
        //     child: Center(
        //         child: GestureDetector(
        //             onTap:tap==true?null: ()async {
        //               setState(() {
        //                 adding=true;
        //                 tap=true;
        //               });
        //              var rsp =await  createSessionList("VIDEO",itemsId,itemsName,itemsThumb,itemsUrl);
        //
        //
        //              // checkAndCreateSession(context,itemsId);
        //
        //               // createPlayListBottomSheet();
        //             },
        //             child: const Text("Done", style: size14_600G))),
        //   )
        // ],
        title:  Text("Opening media", style: tap==true?size16_600GR:size16_600W),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 0),
        child: Loading(),
      ),
    );
  }





  Widget TitletxtBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          style: size16_600W,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff404040)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: grey),
              ),
              hintStyle: size14_500Grey,
              hintText: "Name"),
        ),
      ),
    );
  }

  Widget emailTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          style: size16_600W,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff404040))),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: grey)),
              hintStyle: size14_500Grey,
              hintText: "Email"),
        ),
      ),
    );
  }
}
