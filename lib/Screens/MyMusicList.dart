import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Helper/mediaMoreBottomSheet.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Library/sendMediaToFriends.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerLocal.dart';
import 'package:weei/Screens/Upload/confirmUpload.dart';

class MyMusicList extends StatefulWidget {
  const MyMusicList({Key? key}) : super(key: key);

  @override
  _MyMusicListState createState() => _MyMusicListState();
}

class _MyMusicListState extends State<MyMusicList> {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
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
        actions:  [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: GestureDetector(
              onTap: () {
                NavigatePage(
                    context, ConfirmUploadsScreen(type: "AUDIO"));
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const AddMediaScreen()),
                // );

                //NavigatePage(context,FilePickerDemo());
              },
              child: Container(
                width: 40,
                //  height: 30,
                decoration: BoxDecoration(
                    color: themeClr, borderRadius: BorderRadius.circular(5)),
                child: const Icon(

                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
        title: const Text("Music", style: size16_600W),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: PaginateFirestore(
              // Use SliverAppBar in header to make it sticky
              // header: SliverToBoxAdapter(child: Text('HEADER')),
              // footer: SliverToBoxAdapter(child: Text('FOOTER')),
              // item builder type is compulsory.
              separator: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(color: Color(0xff404040), thickness: 1),
              ),
              shrinkWrap: true,
              itemBuilderType:
                  PaginateBuilderType.listView, //Change types accordingly
              onEmpty: emptyList() ,
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots[index].data() as Map?;
                return data != null
                    ? MusicList(data, index)
                    : Container(
                        child: Center(
                          child: Text("No Entries Found!", style: size14_600W),
                        ),
                      );
              },
              // orderBy is compulsory to enable pagination
              query: FirebaseFirestore.instance
                  .collection('Media')
                  .where('userId', isEqualTo: auth.currentUser!.uid.toString())
                  .where('fileType', isEqualTo: 'AUDIO')
                  .orderBy("uploadAt", descending: true),
              // to fetch real-time data
              listeners: [
                refreshChangeListener,
              ],

              isLive: true,
            ),

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
            //     return MusicList(index);
            //   },
            // ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 15),
          //   child: ListView.separated(
          //     physics: const BouncingScrollPhysics(),
          //     scrollDirection: Axis.vertical,
          //     separatorBuilder: (context, index) => const Padding(
          //       padding: EdgeInsets.symmetric(vertical: 8),
          //       child: Divider(color: Color(0xff404040), thickness: 1),
          //     ),
          //     shrinkWrap: true,
          //     itemCount: 25,
          //     itemBuilder: (context, index) {
          //       // final item = arrOrderDetail != null
          //       //     ? arrOrderDetail[index]
          //       //     : null;
          //
          //       return MusicList(index);
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }
  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No audios found, Try adding some.", style: size13_600W),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: (){
            NavigatePage(
                context, ConfirmUploadsScreen(type: "AUDIO"));

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
  MusicList(var item, int index) {
    return GestureDetector(


      onTap: () {
        var packedData=[{'docId': item['fileUrl'], 'fileName':  item['fileName'], 'fileThumb':  item['fileThumb'], 'fileUrl':   item['fileUrl'], 'fileType':  "AUDIO",}];


        NavigatePage(context, audioPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"AUDIO",isPlaylist:false,url:item['fileUrl']));
        //sendMediaToFriendBottom(context, "FILEMUSIC", item);
      },
      onLongPress: (){
        moreMediaBottomSheet(context,"AUDIO",item);
      },
      child: Row(
        children: [
          Container(
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
                Text(item['fileName'].toString(), style: size14_500W,maxLines: 1,),
                h(5),
                Text(
                    getFileSize(int.parse(item['fileSize'].toString()), 1)
                        .toString(),
                    style: size14_500Grey),
              ],
            ),
          ),

          Container(
            width: 25,
            child: IconButton (
              icon: new Icon(Icons.more_horiz_outlined),
              iconSize: 16,
              color: Colors.white,
              // highlightColor: Colors.white,
              onPressed: (){
                moreMediaBottomSheet(context,"AUDIO",item);

              },
            ),
          ),
        ],
      ),
    );
  }
}
