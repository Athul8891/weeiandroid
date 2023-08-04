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
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
// import 'package:weei/Screens/Main_Screens/Data/checkOngoingSession.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkOngoingSession.dart';
import 'package:weei/Screens/Playlist/addPlayListMedia.dart';
import 'package:just_audio/just_audio.dart';

import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';
class selectPlaylistToSession extends StatefulWidget {
  final type;
  final private;
   selectPlaylistToSession({this.type,this.private}) ;

  @override
  _AddNewVideoScreenState createState() => _AddNewVideoScreenState();
}

class _AddNewVideoScreenState extends State<selectPlaylistToSession> {
  String dropdownvalue = 'Private';

  var itemsId=[];
  var itemsName=[];
  var itemsUrl=[];
  var itemsThumb=[];


  var path;
  bool chk = false;
  bool adding = false;
  bool tap = false;
  var addedNum=0;


  final databaseReference = FirebaseDatabase.instance.reference();

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;



  createSessionList(type,itemsId,itemsName,itemsThumb,itemsUrl) async {
//  showProgress("Processing the entry...");

    final  uid = auth.currentUser!.uid;



    for (var i = 0; i < itemsId.length; i++) {

      var rsp = await    databaseReference.child("session").child(uid).child(i.toString()).update({
        'docId': itemsId[i],
        'fileName':  itemsName[i],
        'fileThumb': type=="VIDEO"? itemsThumb[i]:"",

        'fileUrl':  itemsUrl[i],

      });


  setState(() {
    addedNum=i+1;
    if(itemsId.length==addedNum){
    // adding=false;
    // tap=false;
     checkAndCreateSession(context,"session/"+uid,widget.private,widget.type,ConcatenatingAudioSource(children: []));
    }
  });

    }




  }
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
                child: GestureDetector(
                    onTap:(path==null||tap==true)?null: ()async {


                      if(path==null){

                        showToastSuccess("Playlist not selected");

                        return;
                      }
                      setState(() {
                        adding=true;
                        tap=true;
                      });
                      //var rsp =await  createSessionList("VIDEO",itemsId,itemsName,itemsThumb,itemsUrl);
                      checkAndCreateSession(context,path,widget.private,widget.type,ConcatenatingAudioSource(children: []));

                     // checkAndCreateSession(context,itemsId);

                      // createPlayListBottomSheet();
                    },
                    child:  Text("Done", style:(path==null||tap==true)?size14_600Grey: size14_600G))),
          )
        ],
        title:  Text("Select", style: tap==true?size16_600GR:size16_600W),
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

                  addedNum==itemsId.length?Text("Creating room...", style: size13_600W):Text("Preparing " + addedNum.toString()+" / "+itemsId.length.toString(), style: size13_600W)
                ],
              ),
            ):Container(),
            BannerAds(),
            // GestureDetector(
            //   onTap: () {
            //
            //
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
            SizedBox(height: 10,),
            Expanded(
              child: Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:   PaginateFirestore(

                    // Use SliverAppBar in header to make it sticky
                    // header: SliverToBoxAdapter(child: Text('HEADER')),
                    // footer: SliverToBoxAdapter(child: Text('FOOTER')),
                    // item builder type is compulsory.
                    // separator: Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 8),
                    //   child: Divider(color: Color(0xff404040), thickness: 1),
                    // ),
                    onEmpty: emptyList(widget.type),
                    separator: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),
                    shrinkWrap: true,
                    itemBuilderType:
                    PaginateBuilderType.listView,


                    // Change types accordingly
                    itemBuilder: (context, documentSnapshots, index) {
                      final data = documentSnapshots[index].data() as Map?;
                      return data!=null ?videoList(documentSnapshots[index].id,data,index):Container(  child: Center(child: Text("No Entries Found!"),),);
                    },
                    // orderBy is compulsory to enable pagination
                    query: FirebaseFirestore.instance.collection('Playlist').where('userId',isEqualTo: auth.currentUser!.uid.toString()).where("playlistType",isEqualTo:widget.type).orderBy("uploadAt", descending: true),
                    // to fetch real-time data
                    listeners: [
                      refreshChangeListener,
                    ],

                    isLive: true,
                  ),


                  ///below
                  // ListView.separated(
                  //   physics: const BouncingScrollPhysics(),
                  //   scrollDirection: Axis.vertical,
                  //   separatorBuilder: (context, index) => const Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 8),
                  //     child: Divider(color: Color(0xff404040), thickness: 1),
                  //   ),
                  //   shrinkWrap: true,
                  //   itemCount: 25,
                  //   itemBuilder: (context, index) {
                  //     // final item = arrOrderDetail != null
                  //     //     ? arrOrderDetail[index]
                  //     //     : null;
                  //
                  //     return videoList(index);
                  //   },
                  // ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  videoList(var id,var item,int index) {
    return Row(
      children: [
      Container(
      height: 69,
      child: const Icon(Icons.video_collection, color: Color(0xff808080)),
      width: 101,
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
               Text(item['playlistName'].toString(),
                  style: size14_500W,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              h(5),
               Text(item['playlistSize'].toString()+" "+item['playlistType'].toString().toLowerCase(), style: size14_500Grey),
            //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
            ],
          ),
        ),
        w(10),
        Checkbox(
            value:path==item['playlistPath']?true:false,
            onChanged: (v) {


              setState(() {
              if(path==null){

                  path=item['playlistPath'].toString();


              }else{
                path=null;
              }
              });
            },
            side: const BorderSide(color: Colors.white, width: 1),
            checkColor: Colors.black,
            activeColor: themeClr)
      ],
    );
  }

  Widget emptyList(type) {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No playlist found, Try adding some.", style: size13_600W),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: (){

            NavigatePage(
                context,
                 addMediaToPlaylist(
                  type: type,
                ));
          },
          child: Container(

            alignment: Alignment.center,

            height: 30,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: themeClr),
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Add", style: size14_600White),
            ),
          ),
        )





      ],),);

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
