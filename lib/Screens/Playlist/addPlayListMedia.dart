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
import 'package:weei/Screens/Playlist/Data/createFirebasePath.dart';
import 'package:weei/Screens/Playlist/cofirmExitWhileCreatePlaylst.dart';
import 'package:weei/Screens/Upload/confirmUpload.dart';

import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';
class addMediaToPlaylist extends StatefulWidget {
  final type;
  final count;
  final path;
  final doc;
  final name;
  const addMediaToPlaylist({this.type,this.count,this.path,this.doc,this.name}) ;

  @override
  _AddNewVideoScreenState createState() => _AddNewVideoScreenState();
}

class _AddNewVideoScreenState extends State<addMediaToPlaylist> {
  String dropdownvalue = 'Private';

  var items = ['Private', 'Public'];
  bool chk = false;

  var itemsId=[];
  var itemsName=[];
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


  @override
  void initState() {
    if(widget.count!=null){
      totalPlaylistLength= int.parse(widget.count.toString());
    }
  }

  void dispose(){
    super.dispose();

  }
  Future<bool> _onBackPressed() {

    if(tap==true){
      confirmExitAlertPlaylist( context);
    }else{
      Navigator.pop(context);
    }
    return Future<bool>.value(true);
  }
  createPlayList(type,itemsId,itemsName,itemsThumb,itemsUrl,playlistName) async {
//  showProgress("Processing the entry...");

    final  uid = auth.currentUser!.uid;

       setState(() {
         tap=true;
       });

    for (var i = 0; i < itemsId.length; i++) {

      setState(() {
        addingText=    "Adding " + i.toString()+" / "+itemsId.length.toString();
      });
      var rsp = await    databaseReference.child("playlist/"+widget.type).child(uid).child(playlistName).child((i).toString()).update({
        'docId': itemsId[i],
        'fileName':  itemsName[i],
        'fileThumb': type=="VIDEO"? itemsThumb[i]:"",

        'fileUrl':  itemsUrl[i],
        'fileType':  type,

      });




    }



    setState(() {
      addingText="Creating..";
    });
    var rsp = await uploadPlaylistFirestore(playlistName,type,itemsId.length,"playlist/"+widget.type+"/"+uid+"/"+playlistName,true);

    if(rsp==true){
      setState(() {
        addingText=    "Completed !";
      });
    }else{
      setState(() {
        addingText=    "Failed !";
      });
    }


    Future.delayed(const Duration(seconds: 2), () {

// Here you can write your code

      setState(() {

          adding=false;

         itemsId.clear();
         itemsName.clear();
         itemsUrl.clear();
         itemsThumb.clear();
         Navigator.pop(context);
      });

    });


  }
  updatePlayList(type,itemsId,itemsName,itemsThumb,itemsUrl) async {
//  showProgress("Processing the entry...");
    setState(() {
      //addingText="Checking...";
      adding=true;
    });
    final  uid = auth.currentUser!.uid;



    for (var i = 0; i < itemsId.length; i++) {

      setState(() {
        addingText=    "Adding " + i.toString()+" / "+itemsId.length.toString();
      });
      var rsp = await    databaseReference.child(widget.path).child((totalPlaylistLength+i).toString()).update({
        'docId': itemsId[i],
        'fileName':  itemsName[i],
        'fileThumb': type=="VIDEO"? itemsThumb[i]:"",

        'fileUrl':  itemsUrl[i],
        'fileType':  type,

      });




    }



    setState(() {
      addingText="Creating..";
    });
    var rsp = await updatePlaylistCountFirestore(widget.doc,(totalPlaylistLength+itemsId.length));

    if(rsp==true){
      setState(() {
        addingText=    "Completed !";
      });
    }else{
      setState(() {
        addingText=    "Failed !";
      });
    }


    Future.delayed(const Duration(seconds: 2), () {

// Here you can write your code

      setState(() {

        adding=false;

        itemsId.clear();
        itemsName.clear();
        itemsUrl.clear();
        itemsThumb.clear();
        Navigator.pop(context);
        Navigator.pop(context);

      });

    });


  }

  void checkAndCreatePlaylist(type,itemsId,itemsName,itemsThumb,itemsUrl,playlistName) async{

        Navigator.pop(context);
    //var code = "060625";
    setState(() {
      addingText="Checking...";
      adding=true;
    });
   databaseReference.child("playlist/"+widget.type).child(uid).child(playlistName).once().then(( snapshot) {
      // print('Connected to second database and read ${snapshot.snapshot.value}');
      if(snapshot.snapshot.value==null){
        createPlayList(type,itemsId,itemsName,itemsThumb,itemsUrl,playlistName);
      }else{
        showToastSuccess("You already made a playlist in this name, try different !");
        setState(() {

          adding=false;
        });
      }

    });

    return response;
  }
  @override
  Widget build(BuildContext context) {

    return  WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                      onTap:(itemsId.isEmpty||adding==true)?null: ()async {

                       if(widget.path!=null){
                         updatePlayList(widget.type,itemsId,itemsName,itemsThumb,itemsUrl);
                       }else{
                         createPlayListBottomSheet();

                       }

                        // setState(() {
                        //   adding=true;
                        //   tap=true;
                        // });
                      //  var rsp =await  createPlayList(widget.type,itemsId,itemsName,itemsThumb,itemsUrl,"NAME");


                       // checkAndCreateSession(context,itemsId);

                        // createPlayListBottomSheet();
                      },
                      child:  Text("Done", style: (itemsId.isEmpty||tap==true)?size14_600Grey:size14_600G))),
            )
          ],
          title:  Text("Select", style: size16_600W),
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

                    Text(addingText, style: size13_600W)
                  ],
                ),
              ):Container(),
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
              // SizedBox(height: 10,),
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
                      onEmpty: emptyList(),
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
                      query: FirebaseFirestore.instance.collection('Media').where('userId',isEqualTo: auth.currentUser!.uid.toString()).where('fileType',isEqualTo: widget.type).orderBy("uploadAt", descending: true),
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
      ),
    );
  }
  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(widget.type=="VIDEO"?"No videos found, Try adding some.":"No audios found, Try adding some.", style: size13_600W),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: (){
            NavigatePage(
                context, ConfirmUploadsScreen(type: widget.type));

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
                  itemsThumb.add(item['fileThumb']==null?null:item['fileThumb']);
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
          controller: playlistController,
          style: size14_500W,
          decoration: const InputDecoration(

            ///
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff404040)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: grey),
              ),
              hintStyle: size14_500W,
              hintText: "Name",



          ),
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


  createPlayListBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff4F4F4F),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("New Playlist", style: size14_700W),
              ),
              h(10),
              TitletxtBox(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: 25, vertical: 10),
              //   child: DropdownButton(
              //       value: dropdownvalue,
              //       elevation: 1,
              //       // isDense: true,
              //       dropdownColor: liteBlack,
              //       style: size14_500Grey,
              //       isExpanded: true,
              //       // underline: Container(),
              //       icon: const Icon(Icons.keyboard_arrow_down),
              //       items: items.map((String items) {
              //         return DropdownMenuItem(
              //             value: items,
              //             child: Text(items, style: size14_500Grey));
              //       }).toList(),
              //       onChanged: (String? newValue) {
              //         setState(() {
              //           dropdownvalue = newValue!;
              //         });
              //       }),
              // ),
              h(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Spacer(),



                    GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },

                    child: const Text("Cancel", style: size14_600G)),
                    w(30),

                    GestureDetector(
                      onTap: ()async{
                        if(playlistController.text.isEmpty){
                          showToastSuccess("Playlist name empty !");
                          return;
                        }

                        checkAndCreatePlaylist(widget.type,itemsId,itemsName,itemsThumb,itemsUrl,playlistController.text);
                      },
                      child: const Text(
                        "Save",
                        style: size14_600G,
                      ),
                    ),
                 //    GestureDetector(
                 //      onTap: ()async{
                 //      if(playlistController.text.isEmpty){
                 //        showToastSuccess("Playlist name empty !");
                 //        return;
                 //      }
                 //
                 // checkAndCreatePlaylist(widget.type,itemsId,itemsName,itemsThumb,itemsUrl,playlistController.text);
                 //      },
                 //      child: const Text(
                 //        "Save",
                 //        style: size16_600G,
                 //      ),
                 //    )
                  ],
                ),
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
}
