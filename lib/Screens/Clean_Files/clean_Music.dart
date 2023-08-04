import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:flutter/cupertino.dart';

import 'package:paginate_firestore/bloc/pagination_listeners.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Screens/Upload/Data/deleteFileApi.dart';

class cleanMusic extends StatefulWidget {
  final alert;
  cleanMusic({this.alert});

  @override
  _cleanMusicState createState() => _cleanMusicState();
}

class _cleanMusicState extends State<cleanMusic> {
  bool chk = false;
  String dropdownvalue = 'Private';




  var itemsId=[];
  var itemsSize=[];
  var itemsUrl=[];
  var itemsThumb=[];


  bool tap = false;
  var addedNum=0;


  final databaseReference = FirebaseDatabase.instance.reference();

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController playlistController = TextEditingController();

  bool adding = false;
  var addingText="";
  var totalPlaylistLength=0;
  var totalClearSize=0;
  var total=0;


  @override
  void initState() {
    //totalSize();
  }

  clearSize(){
    setState(() {
      totalClearSize =0;

    });
    for (var i = 0; i < itemsSize.length; i++) {

      totalClearSize = totalClearSize+int.parse(itemsSize[i].toString());

    }
  }

  deleteFiles() async {
//  showProgress("Processing the entry...");


       setState(() {
         adding=true;
       });


    for (var i = 0; i < itemsId.length; i++) {

      setState(() {
        addingText=    "Deleting " + i.toString()+" / "+itemsId.length.toString();
        widget.alert.text= addingText;
      });


      var rsp = await deleteFileApi(itemsId[i],itemsSize[i]);
      if(itemsId.length==i+1){
        setState(() {
          addingText=    "Completed !";

          widget.alert.text= addingText;
          setState(() {
            adding=false;

            itemsId.clear();

            itemsUrl.clear();
            itemsThumb.clear();
            itemsSize.clear();

            widget.alert.text="NILL";
            showToastSuccess("Files cleared!");

          });

        });
      }

    }











  }

  delayFunc(){

  }

  totalSize()async{

    setState(() {
      total=0;
    });

    final querySnapshot = await FirebaseFirestore.instance.collection('Media').where('userId',isEqualTo: auth.currentUser!.uid.toString()).get();

    for (var doc in querySnapshot.docs) {
      var add= "0";
      // Getting data directly


      // Getting data from map
      Map<String, dynamic> data = doc.data();
      print("data['fileSize']");
      if(data['fileSize']==null){
         add = "0";
        print("maiyrree");
      }else{
        add =data['fileSize'];
        print(data['fileSize']);

      }

      //
       total = total+int.parse(add.toString());
    }

    print("totallllllllll");
    print(total);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
          onTap:(itemsSize.isEmpty||adding==true)?null: (){
            deleteFiles();
          },
          child: adding==true?Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color:(itemsSize.isEmpty||adding==true)?Colors.grey: red),
            height: 50,
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ):Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color:(itemsSize.isEmpty||adding==true)?Colors.grey: red),
            height: 50,
            child: itemsSize.isEmpty?Text("Clean", style: size16_600W):Text("Clean ("+getFileSize(totalClearSize,1)+")", style: size16_600W),
          ),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [




            Expanded(
              child: Scrollbar(
                child:  Padding(
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
                    separator: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),
                    shrinkWrap: true,
                    itemsPerPage: 200,
                    itemBuilderType:
                    PaginateBuilderType.listView,

                    onEmpty: emptyList(),
                    // Change types accordingly
                    itemBuilder: (context, documentSnapshots, index) {
                      final data = documentSnapshots[index].data() as Map?;
                      return data!=null ?MusicList(documentSnapshots[index].id,data,index):Container(  child: Center(child: Text("No Entries Found!"),),);
                    },
                    // orderBy is compulsory to enable pagination
                    query: FirebaseFirestore.instance.collection('Media').where('userId',isEqualTo: auth.currentUser!.uid.toString()).where('fileType',isEqualTo: "AUDIO").orderBy("uploadAt", descending: true),
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
            h(65)
          ],
        ),
      ),
    );
  }

  MusicList(var id,var item,int index) {
    return Row(
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
              Text(item['fileName'].toString(),
                  style: size14_500W,
                  maxLines: 1,
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
                  itemsSize.removeAt(indexx);
                  // itemsName.removeAt(indexx);
                  // itemsThumb.removeAt(indexx);
                  itemsUrl.removeAt(indexx);

                }else{
                  itemsId.add(id);
                  // itemsName.add(item['fileName']);
                  // itemsThumb.add(item['fileThumb']==null?null:item['fileThumb']);
                  itemsUrl.add(item['fileUrl']);
                  itemsSize.add(item['fileSize']);

                }
                print(itemsId);

              });
              clearSize();
            },
            side: const BorderSide(color: Colors.white, width: 1),
            checkColor: Colors.black,
            activeColor: themeClr)
      ],
    );
  }

  videoList(int index) {
    return Row(
      children: [
        Container(
          height: 40,
          child: const Icon(Icons.video_collection, color: Colors.pink),
          width: 60,
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
              const Text("YouTube video file name goes here",
                  style: size14_500W,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              h(5),
              const Text("58.84 MB", style: size14_500Grey),
            ],
          ),
        ),
        w(10),
        Checkbox(
            value: chk,
            onChanged: (v) {
              setState(() {});
            },
            side: const BorderSide(color: Colors.white, width: 1),
            checkColor: Colors.black,
            activeColor: themeClr)
      ],
    );
  }

  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No files to remove.", style: size13_600W),
        SizedBox(height: 15,),






      ],),);

  }
}
