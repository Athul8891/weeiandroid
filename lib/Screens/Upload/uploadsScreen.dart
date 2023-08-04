import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerLocal.dart';
import 'package:weei/Screens/Upload/confirmUpload.dart';
import 'package:weei/Screens/VideoSession/videoPlayerLocal.dart';

class UploadsScreen extends StatefulWidget {
  const UploadsScreen({Key? key}) : super(key: key);

  @override
  _UploadsScreenState createState() => _UploadsScreenState();
}

class _UploadsScreenState extends State<UploadsScreen> {
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
                uploadBottomSheet();
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
        title: const Text("Uploads", style: size16_600W),
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
              onEmpty: emptyList(),
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
                //  .where('fileType', isEqualTo: "VIDEO")
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
        ),
      ),
    );
  }
  uploadBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff1E1E1E),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: const [
                    Text('Add media', style: size14_600W),
                    Spacer(),
                    Icon(CupertinoIcons.xmark_circle_fill,
                        color: grey, size: 25)
                  ],
                ),
              ),
              const Divider(
                color: Color(0xff2F2E41),
                thickness: 1,
              ),
              h(10),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigatePage(
                          context,
                          ConfirmUploadsScreen(
                            type: "AUDIO",
                          ));
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Icon(CupertinoIcons.music_note_2,
                          color: Colors.white),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey),
                    ),
                  ),
                  w(15),
                  GestureDetector(
                    onTap: () {
                      NavigatePage(
                          context, ConfirmUploadsScreen(type: "VIDEO"));
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Icon(CupertinoIcons.video_camera_solid,
                          color: Colors.white),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 10),
              ),
              BannerAds(),
            ],
          ),
        ));
  }

  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No uploads found, Try adding some.", style: size13_600W),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: (){
            uploadBottomSheet();

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
  // MusicList(var data, int index) {
  //   return Row(
  //     children: [
  //       Container(
  //         height: 33,
  //         child: const Icon(Icons.image, color: Colors.blue),
  //         width: 33,
  //         decoration: BoxDecoration(
  //           color: Colors.grey[200],
  //           borderRadius: BorderRadius.circular(5),
  //         ),
  //       ),
  //       w(10),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text("audio-file-name.mp3", style: size14_500W),
  //             h(5),
  //             const Text("58.84 MB", style: size14_500Grey),
  //           ],
  //         ),
  //       ),
  //       w(10),
  //       // Icon(CupertinoIcons.clear_circled_solid, color: Colors.red)
  //       // Icon(Icons.check_circle, color: Colors.green)
  //       uploadProgress()
  //     ],
  //   );
  // }
  //
  // uploadProgress() {
  //   return Column(children: [
  //     Row(
  //       children: const [
  //         Text("64%", style: size14_600W),
  //         Text("4.8 Mbps", style: size14_500Grey),
  //       ],
  //     ),
  //     h(5),
  //     const StepProgressIndicator(
  //       totalSteps: 100,
  //       currentStep: 43,
  //       size: 8,
  //       padding: 0,
  //       roundedEdges: Radius.circular(10),
  //       selectedGradientColor: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [blueClr, blueClr],
  //       ),
  //       unselectedGradientColor: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xff3E3E3E), Color(0xff3E3E3E)],
  //       ),
  //     )
  //   ]);
  // }

  MusicList(var item, int index) {
    return GestureDetector(
      onTap: (){

        if( item['fileType'] == "VIDEO"){
          var packedData=[{'docId': item['fileUrl'], 'fileName':  item['fileName'], 'fileThumb':  item['fileThumb'], 'fileUrl':   item['fileUrl'], 'fileType':  "VIDEO",}];


          NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"VIDEO",isPlaylist:false,url:item['fileUrl']));

        }else{
          var packedData=[{'docId': item['fileUrl'], 'fileName':  item['fileName'], 'fileThumb':  item['fileThumb'], 'fileUrl':   item['fileUrl'], 'fileType':  "AUDIO",}];


          NavigatePage(context, audioPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"AUDIO",isPlaylist:false,url:item['fileUrl']));

        }

      },
      child: Row(
        children: [
          item['fileType'] == "VIDEO"
              ? Container(
                  height: 33,
                  child: Image.memory(dataFromBase64String(item['fileThumb'])),
                  width: 33,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                )
              : Container(
                  height: 33,
                  child: const Icon(Icons.music_note_outlined,
                      color: Colors.pinkAccent),
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
                Text(
                  item['fileName'].toString(),
                  style: size14_500W,
                  maxLines: 1,
                ),
                h(5),
                Text(
                    getFileSize(int.parse(item['fileSize'].toString()), 1) +" | "+ item['createdTime'].toString()
                        .toString(),
                    style: size14_500Grey),
              ],
            ),
          ),
          w(10),
          // Icon(CupertinoIcons.clear_circled_solid, color: Colors.red)
          // Icon(Icons.check_circle, color: Colors.green)
          //  uploadProgress()
          item['fileStatus'] == "0" ? removeItem(index) : completeItem()
        ],
      ),
    );
  }

  uploadProgress() {
    return Column(children: [
      Row(
        children: const [
          Text("64%", style: size14_600W),
          Text("4.8 Mbps", style: size14_500Grey),
        ],
      ),
      h(5),
      const StepProgressIndicator(
        totalSteps: 100,
        currentStep: 43,
        size: 8,
        padding: 0,
        roundedEdges: Radius.circular(10),
        selectedGradientColor: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [blueClr, blueClr],
        ),
        unselectedGradientColor: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff3E3E3E), Color(0xff3E3E3E)],
        ),
      )
    ]);
  }

  removeItem(index) {
    return GestureDetector(
      onTap: () {
        //  showToastSuccess(fileName[index].toString() +" removed !");
      },
      child: Container(
        height: 25,
        width: 25,
        child: const Icon(
          CupertinoIcons.delete,
          color: Colors.white,
          size: 17,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.redAccent),
      ),
    );
  }

  completeItem() {
    return GestureDetector(
      onTap: () {
        //  showToastSuccess(fileName[index].toString() +" removed !");
      },
      child: Container(
        height: 25,
        width: 25,
        child: const Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: themeClr,

          size: 17,
        ),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5), color: Colors.green),
      ),
    );
  }
}
