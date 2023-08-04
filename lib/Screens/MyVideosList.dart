import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Helper/mediaMoreBottomSheet.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Library/sendMediaToFriends.dart';
import 'package:weei/Screens/Upload/confirmUpload.dart';
import 'package:weei/Screens/VideoSession/videoPlayerLocal.dart';

class MyVideosList extends StatefulWidget {
  const MyVideosList({Key? key}) : super(key: key);

  @override
  _MyVideosListState createState() => _MyVideosListState();
}

class _MyVideosListState extends State<MyVideosList> {
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
                    context, ConfirmUploadsScreen(type: "VIDEO"));
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
        title: const Text("Videos", style: size16_600W),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: GridView.builder(
                //     physics: const BouncingScrollPhysics(),
                //     shrinkWrap: true,
                //     itemCount: 5,
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         crossAxisSpacing: 15,
                //         mainAxisSpacing: 10,
                //         childAspectRatio: 0.65),
                //     itemBuilder: (BuildContext context, int index) {
                //       // final item = arrOrderDetail != null
                //       //     ? arrOrderDetail[index]
                //       //     : null;
                //       return VideosGrid(index);
                //     },
                //   ),
                // ),

                PaginateFirestore(
              // Use SliverAppBar in header to make it sticky
              // header: SliverToBoxAdapter(child: Text('HEADER')),
              // footer: SliverToBoxAdapter(child: Text('FOOTER')),
              // item builder type is compulsory.
              // separator: Padding(
              //   padding: EdgeInsets.symmetric(vertical: 8),
              //   child: Divider(color: Color(0xff404040), thickness: 1),
              // ),
              // shrinkWrap: true,
              // itemBuilderType: PaginateBuilderType.gridView,
              // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 15,
              //     mainAxisSpacing: 10,
              //     childAspectRatio: 0.65),

                    separator: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),
                    shrinkWrap: true,
                    itemBuilderType:
                    PaginateBuilderType.listView,
                  onEmpty: emptyList(),
              // Change types accordingly
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots[index].data() as Map?;
                return data != null
                    ? VideosGrid(data, index)
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
                  .where('fileType', isEqualTo: "VIDEO")
                  .orderBy("uploadAt", descending: true),
              // to fetch real-time data
              listeners: [
                refreshChangeListener,
              ],

              isLive: true,
            ),
          ),
        ),
      ),
    );
  }
  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No videos found, Try adding some.", style: size13_600W),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: (){
            NavigatePage(
                context, ConfirmUploadsScreen(type:"VIDEO"));

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
  // VideosGrid(var item, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       sendMediaToFriendBottom(context, "FILEVIDEO", item);
  //     },
  //     child: SizedBox(
  //       width: 164,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             height: 164,
  //             width: 164,
  //             child: Image.memory(dataFromBase64String(item['fileThumb'])),
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 color: Colors.grey[200]),
  //           ),
  //           h(5),
  //           Text(
  //             item['fileName'].toString(),
  //             style: size14_500W,
  //             maxLines: 2,
  //           ),
  //           h(3),
  //           // Padding(
  //           //   padding: const EdgeInsets.symmetric(horizontal: 0),
  //           //   child: Row(
  //           //     children: const [
  //           //       Text("03:04", style: size14_500Grey),
  //           //       Spacer(),
  //           //       Text("58.84 MB", style: size14_500Grey),
  //           //     ],
  //           //   ),
  //           // )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  VideosGrid(var item, int index) {
    return GestureDetector(
      onTap: () {
        var packedData=[{'docId': item['fileUrl'], 'fileName':  item['fileName'], 'fileThumb':  item['fileThumb'], 'fileUrl':   item['fileUrl'], 'fileType':  "VIDEO",}];


        NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"VIDEO",isPlaylist:false,url:item['fileUrl']));
        // sendMediaToFriendBottom(context, "FILEVIDEO", item);
      },
      onLongPress: (){
        moreMediaBottomSheet(context,"VIDEO",item);
      },
      child: Row(
        children: [

          Container(
            height: 33,
            width: 33,
            child: Image.memory(dataFromBase64String(item['fileThumb'])),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.grey[200]),
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
                moreMediaBottomSheet(context,"VIDEO",item);

              },
            ),
          ),
        ],
      ),
    );
  }
}
