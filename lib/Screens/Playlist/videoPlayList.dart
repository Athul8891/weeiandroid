import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/bytesToMb.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/playlistMoreBottomSheet.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Chat/addLocalForSession.dart';
import 'package:weei/Screens/Playlist/addPlayListMedia.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:weei/Screens/VideoSession/videoPlayerLocal.dart';

class MyVideoPlayList extends StatefulWidget {
  final path;
  final count;
  final doc;
  final name;
 MyVideoPlayList({this.path,this.count,this.doc,this.name});

  @override
  _MyVideosListState createState() => _MyVideosListState();
}

class _MyVideosListState extends State<MyVideoPlayList> {

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
   var playList;
   var isLoading=true;
  @override
  void initState() {

  }


  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child:  Row(
        children: [
          //  Icon(iconData, color: Colors.black,size: 10,),
          Text(title),
        ],
      ),
    );
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
          PopupMenuButton(
            onSelected: (value) {
              // _onMenuItemSelected(value as int);
              print("value");
              print(value);
              print("value");
              print(value);
              if(value==0){

              }

              if(value==1){
                NavigatePage(context, addMediaToPlaylist(type: "VIDEO",count: widget.count,doc: widget.doc,name: widget.name,path: widget.path,));
              }
              if(value==2){
                deletePlyListAlert( context);
              }
              if(value==3){
                NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: widget.path ,data: []  ,index: 0, playingType:"VIDEO",isPlaylist:true,url:null));
              }

            },
            itemBuilder: (ctx) => [
           //   _buildPopupMenuItem(' Select', Icons.check, 0),
              _buildPopupMenuItem(' Add more', Icons.add, 1),
              _buildPopupMenuItem(' Delete playlist', Icons.delete, 2),
              _buildPopupMenuItem(' Play playlist', Icons.arrow_forward, 3),

              // _buildPopupMenuItem('Copy', Icons.copy, 2),
              // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
            ],
          )
        ],
        title:  Text(widget.name, style: size16_600W),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RealtimeDBPagination(
            isLive: true,
            query: FirebaseDatabase.instance.ref().child(widget.path),
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(color: Color(0xff404040), thickness: 1),
            ),
            itemBuilder: (context, dataSnapshot, index) {

              Map<String, dynamic> data = Map<String, dynamic>.from(
                dataSnapshot.value! as Map<Object?, Object?>,
              );
              //final data = dataSnapshot.value as Map<String, dynamic>;
              return MusicList(data,index);
              // Do something cool with the data
            },
          ),
        ),
      ),
    );
  }

  VideosGrid(var item,int index) {
    return SizedBox(
      width: 164,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 164,
            width: 164,
            child: Image.memory( dataFromBase64String(item['fileThumb'])),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200])
            ,
          ),
          h(5),
           Text(item['fileName'].toString(), style: size14_500W,maxLines: 2,),
          h(3),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 0),
          //   child: Row(
          //     children: const [
          //       Text("03:04", style: size14_500Grey),
          //       Spacer(),
          //       Text("58.84 MB", style: size14_500Grey),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  MusicList(var item, int index) {
    return GestureDetector(
      onTap: (){
        var packedData=[{'docId': item['fileUrl'], 'fileName':  item['fileName'], 'fileThumb':  item['fileThumb'], 'fileUrl':   item['fileUrl'], 'fileType':  "VIDEO",}];


        NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"VIDEO",isPlaylist:false,url:item['fileUrl']));
      },
      child: Row(
        children: [
          Container(
            height: 33,
            width: 33,
            child: Image.memory( dataFromBase64String(item['fileThumb'])),
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200])
            ,
          ),
          w(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['fileName'].toString(), style: size14_500W,maxLines: 1,),
                h(5),
                //Text(getFileSize(int.parse(item['fileSize'].toString()),1).toString(), style: size14_500Grey),
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
                morePlaylistBottomSheet(context,"AUDIO",item,widget.path+"/"+index.toString());

              },
            ),
          ),
        ],
      ),
    );
  }

  void deletePlyListAlert(BuildContext context) {




    // DatabaseReference reference =
    // FirebaseDatabase.instance.reference().child('channel');

    String dropdownvalue = 'All';
    var onSubmit = false;
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        // isScrollControlled: true,
        builder: (context) => Stack(children: [
          Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: liteBlack),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Text("Confirm delete?", style: size14_600W),
                      Spacer(),

                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xff404040), thickness: 1),
                  ),
                  //  const Text("This will close the room and \n joins will be exited .", style: size14_500Grey),
                  h(10),
                  Row(
                    children: [
                      Expanded(
                        child: buttons("Confirm", const Color(0xff333333), ()async {
                          _firestore.collection('Playlist').doc(widget.doc).delete().then((value)async{



                            databaseReference.child(widget.path).remove();
                            Navigator.pop(context);
                            Navigator.pop(context);



                            //Navigator.of(context).pop();
                          }).catchError((error) {
                            //  dismissProgress();
                             print("errorrrrr");
                             print(error);
                            showToastSuccess(errorcode);
                          });

                        }),
                      ),
                      w(10),
                      Expanded(
                        child: buttons("Cancel", themeClr, () async{

                          Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const UpgradeScreen()),
                          // );
                        }),
                      ),
                    ],
                  ),

                  h(5),
                  BannerAds()
                ],
              ),
            ),
          ),
        ]));




  }


  buttons(String txt, Color clr, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: clr),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(txt, style: size14_600W),
        ),
      ),
    );
  }
}
