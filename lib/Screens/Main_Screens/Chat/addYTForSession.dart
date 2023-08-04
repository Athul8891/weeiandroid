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
import 'package:weei/Helper/bytesToMb.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
// import 'package:weei/Screens/Main_Screens/Data/checkOngoingSession.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/SqureBannerAds.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkOngoingSession.dart';
import 'package:weei/Screens/Playlist/selectPlaylistForSession.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';
class addYTToSession extends StatefulWidget {
  final type;
  final private;
  final isPlaylist;
  final url;
  final ConcatenatingAudioSource ;

  addYTToSession({this.type,this.private,this.isPlaylist,this.url,this.ConcatenatingAudioSource});
  @override
  _AddNewVideoScreenState createState() => _AddNewVideoScreenState();
}

class _AddNewVideoScreenState extends State<addYTToSession> {
  String dropdownvalue = 'Private';

  var itemsId=[];
  var itemsName=[];
  var itemsUrl=[];
  var itemsThumb=[];
   var playlistLength =0;
  bool chk = false;
  bool adding = false;
  bool tap = false;
  var addedNum=0;


  final databaseReference = FirebaseDatabase.instance.reference();

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final yt = YoutubeExplode();


  @override
  void initState() {
    Future.delayed(const Duration(seconds: 6), () {

// Here you can write your code

      if(widget.isPlaylist==true){
        this.fetchFromPlaylist();
      }else{
        this.fetchSingle();
      }

    });

    print("xxxxxxxxxxxxxxx");
    print(widget.type);
    print(widget.private);
    print(widget.isPlaylist);
    print(widget.url);
    print("xxxxxxxxxxxxxxx");


  }
   fetchFromPlaylist()async{
    var set = await databaseReference.child("session").child(uid).remove();
    var i =0;
    var playlist = await yt.playlists.get(widget.url);
    setState(() {
      adding=true;
      tap=true;
      playlistLength =playlist.videoCount!;
    });
     await for (var video in yt.playlists.getVideos(widget.url)) {


       var rsp = await    databaseReference.child("session").child(uid).child(i.toString()).update({
         'docId': video.url,
         'fileName':  video.title,
         'fileThumb': video.thumbnails.highResUrl,

         'fileUrl':  video.url,
         'fileType':  widget.type,

       }).whenComplete((){
         setState(() {
           i=i+1;
           addedNum =i;
         });
       });

     }


    setState(() {
      print("step 2");

      // adding=false;
      // tap=false;
      checkAndCreateSession(context,"session/"+uid,widget.private,widget.type,widget.ConcatenatingAudioSource);
      // if(playlist.videoCount==(i+1)){
      //
      //   print("step 2");
      //
      //   // adding=false;
      //   // tap=false;
      //   checkAndCreateSession(context,"session/"+uid,widget.private,widget.type);
      // }
    });
   }

   fetchSingle()async{
     var set = await databaseReference.child("session").child(uid).remove();

     var i =0;
   // var playlist = await yt.playlists.get(widget.url);
    setState(() {
      adding=true;
      tap=true;
      playlistLength =1;
    });

    final video = await yt.videos.get(widget.url);

    var rsp = await    databaseReference.child("session").child(uid).child(i.toString()).update({
      'docId': video.url,
      'fileName':  video.title,
      'fileThumb': video.thumbnails.highResUrl,

      'fileUrl':  video.url,
      'fileType':  widget.type,

    }).whenComplete((){
      print("comppp");
      setState(() {
        i=i+1;
        addedNum =i;
      });

      checkAndCreateSession(context,"session/"+uid,widget.private,widget.type,widget.ConcatenatingAudioSource);
    });



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
      bottomNavigationBar: BannerAds(),
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
        title:  Text("Finding room..", style: tap==true?size16_600GR:size16_600W),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            adding==true? Container(
              height: 25,
              decoration: BoxDecoration(

                  color: themeClr),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [

                  addedNum==playlistLength?Text("Creating room...", style: size13_600W):Text("Preparing " + addedNum.toString()+" / "+playlistLength.toString(), style: size13_600W)
                ],
              ),
            ):Container(
              height: 25,
              decoration: BoxDecoration(

                  color: themeClr),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [

                  Text("Preparing..", style: size13_600W)
                ],
              ),
            ),
            // widget.type=="YT"?Container():GestureDetector(
            //   onTap: () {
            //
            //     NavigatePage(context,selectPlaylistToSession(type: widget.type,));
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(
            //     //       builder: (context) => SessionScreen()),
            //     // );
            //   },
            //   child: Container(
            //     height: 40,
            //     margin: EdgeInsets.all(5),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(2),
            //         color: liteBlack),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children:  [
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 6),
            //           child: Icon(Icons.add_to_photos_outlined,
            //               color: Colors.white,size: 12,),
            //         ),
            //         Text("Choose a playlist", style: size13_600W)
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10,),
            // widget.type=="YT"?Container():Expanded(
            //   child: Scrollbar(
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 15),
            //       child:   PaginateFirestore(
            //
            //         // Use SliverAppBar in header to make it sticky
            //         // header: SliverToBoxAdapter(child: Text('HEADER')),
            //         // footer: SliverToBoxAdapter(child: Text('FOOTER')),
            //         // item builder type is compulsory.
            //         // separator: Padding(
            //         //   padding: EdgeInsets.symmetric(vertical: 8),
            //         //   child: Divider(color: Color(0xff404040), thickness: 1),
            //         // ),
            //         separator: Padding(
            //           padding: EdgeInsets.symmetric(vertical: 8),
            //           child: Divider(color: Color(0xff404040), thickness: 1),
            //         ),
            //         shrinkWrap: true,
            //         itemBuilderType:
            //         PaginateBuilderType.listView,
            //
            //
            //         // Change types accordingly
            //         itemBuilder: (context, documentSnapshots, index) {
            //           final data = documentSnapshots[index].data() as Map?;
            //           return data!=null ?videoList(documentSnapshots[index].id,data,index):Container(  child: Center(child: Text("No Entries Found!"),),);
            //         },
            //         // orderBy is compulsory to enable pagination
            //         query: FirebaseFirestore.instance.collection('Media').where('userId',isEqualTo: auth.currentUser!.uid.toString()).where('fileType',isEqualTo: widget.type).orderBy("uploadAt", descending: true),
            //         // to fetch real-time data
            //         listeners: [
            //           refreshChangeListener,
            //         ],
            //
            //         isLive: true,
            //       ),
            //
            //
            //       ///below
            //       // ListView.separated(
            //       //   physics: const BouncingScrollPhysics(),
            //       //   scrollDirection: Axis.vertical,
            //       //   separatorBuilder: (context, index) => const Padding(
            //       //     padding: EdgeInsets.symmetric(vertical: 8),
            //       //     child: Divider(color: Color(0xff404040), thickness: 1),
            //       //   ),
            //       //   shrinkWrap: true,
            //       //   itemCount: 25,
            //       //   itemBuilder: (context, index) {
            //       //     // final item = arrOrderDetail != null
            //       //     //     ? arrOrderDetail[index]
            //       //     //     : null;
            //       //
            //       //     return videoList(index);
            //       //   },
            //       // ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 2,),
            Center(child: BannerAds())
           // SqureBannerAds()
          ],
        ),
      ),
    );
  }

  videoList(var id,var item,int index) {
    return Row(
      children: [
        widget.type=="VIDEO"?  Container(
          height: 69,
          child: Image.memory( dataFromBase64String(item['fileThumb'])),
          width: 101,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
        ):Container(
          height: 33,
          child: const Icon(Icons.music_note_rounded, color: Colors.pink),
          width: 33,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        w(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(item['fileName'].toString(),
                  style: size14_500W,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              h(5),
               Text(getFileSize(int.parse(item['fileSize'].toString()),1).toString(), style: size14_500Grey),
            //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
            ],
          ),
        ),
        w(10),
        Checkbox(
            value: itemsId.contains(id)?true:false,
            onChanged: (v) {

              setState(() {

                if(itemsId.contains(id)==true){
                  int indexx = itemsId.indexWhere((item) => item.contains(id));
                  print("indexx");
                  print(indexx);
                  itemsId.removeAt(indexx);
                  itemsName.removeAt(indexx);
                  itemsThumb.removeAt(indexx);
                  itemsUrl.removeAt(indexx);
                }else{
                  itemsId.add(id);
                  itemsName.add(item['fileName']);
                  itemsThumb.add(item['fileThumb']);
                  itemsUrl.add(item['fileUrl']);

                }
             print(itemsId);

              });
            },
            side: const BorderSide(color: Colors.white, width: 1),
            checkColor: Colors.black,
            activeColor: themeClr)
      ],
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
