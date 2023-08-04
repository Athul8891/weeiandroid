import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/loadInAppPlayer.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Admob/InterstitialAd.dart';
import 'package:weei/Screens/DirectStream/Data/directLinkHistory.dart';
import 'package:weei/Screens/DirectStream/Data/updateHistory.dart';
import 'package:weei/Screens/DirectStream/LinkFinder.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatRoom.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/createFriend.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkOngoingSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Screens/Main_Screens/Profile/Data/checkPastedUrl.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerLocal.dart';
import 'package:weei/Screens/Search/Data/addBot.dart';
import 'package:weei/Screens/Search/Data/addFreind.dart';
import 'package:weei/Screens/Search/Data/checkReq.dart';
import 'package:weei/Screens/Search/SearchChatRoom.dart';
import 'package:weei/Screens/Search/SearchSentWidget.dart';
import 'package:weei/Screens/VideoSession/videoPlayerLocal.dart';
import '../../../Helper/getBase64.dart';
import 'package:direct_link/direct_link.dart';

class PasteStreamLink extends StatefulWidget {



  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<PasteStreamLink> {
 TextEditingController streamLinkController = TextEditingController();

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  int a =2;
  final FirebaseAuth auth = FirebaseAuth.instance;


  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';
  var onSubmit = false;
  var historyList =[];
  var selectedSession =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

          this.getData();

  }

  getData()async{
    var rsp = await getUrlList();
    setState(() {
      historyList=rsp;
    });
  }

  goToPage(urlType,selectedSession,url,doc){
    showInterstitialAd();
    upadteHistory(url,urlType,doc);
    switch (urlType) {
      case "URL":
      // do something


        if(selectedSession==0)
        {
        var packedData=[{'docId': url, 'fileName':  url, 'fileThumb':  thumbanilbs6, 'fileUrl':  url, 'fileType':  "AUDIO",}];
         // var packedData={'docId': streamLinkController.text.toString().trim(), 'fileName':  streamLinkController.text.toString().trim(), 'fileThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'fileUrl':   streamLinkController.text.toString().trim(), 'fileType':  "AUDIO",};


         NavigatePage(context, audioPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"AUDIO",isPlaylist:false,url: url));
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => loadInAppPlayer(
        //           type: "AUDIO",
        //           private: true,
        //           isPlaylist: false,
        //           item: packedData,
        //         )),
        //   );
        }
        else
        {

           var packedData=[{'docId': url, 'fileName':  url, 'fileThumb':  thumbanilbs6, 'fileUrl':   url, 'fileType':  "AUDIO",}];
          //
          //
         NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"VIDEO",isPlaylist:false,url:url));

       //   var packedData={'docId': streamLinkController.text.toString().trim(), 'fileName':  streamLinkController.text.toString().trim(), 'fileThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'fileUrl':   streamLinkController.text.toString().trim(), 'fileType':  "AUDIO",};


          // NavigatePage(context, audioPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"AUDIO",isPlaylist:false,url: streamLinkController.text.toString().trim()));
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => loadInAppPlayer(
          //         type: "VIDEO",
          //         private: true,
          //         isPlaylist: false,
          //         item: packedData,
          //       )),
          // );

        }










        break;
      case "YTPLAYLIST":
      // do something else

        if(selectedSession==0){
          var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':  url, 'fileType':  "YTAUDIO",};

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => loadInAppPlayer(
                  type: "YTAUDIO",
                  private: true,
                  isPlaylist:true,
                  item: packedData,
                  path: null,
                )),
          );
        }else{
          var packedData={'docId': url, 'mediaName': url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':   url, 'fileType':  "YTVIDEO",};

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => loadInAppPlayer(
                  type: "YTVIDEO",
                  private: true,
                  isPlaylist:true,
                  item: packedData,
                  path: null,
                )),
          );
        }


        break;

        case "YT":
      // do something else


          if(selectedSession==0){
            var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':   url, 'fileType':  "YTAUDIO",};

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => loadInAppPlayer(
                    type: "YTAUDIO",
                    private: true,
                    isPlaylist:false,
                    item: packedData,
                    path: null,
                  )),
            );
          }else{
            var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':  url, 'fileType':  "YTVIDEO",};

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => loadInAppPlayer(
                    type: "YTVIDEO",
                    private: true,
                    isPlaylist:false,
                    item: packedData,
                    path: null,
                  )),
            );
          }
        break;



      case "INSTA":
      // do something

        if(selectedSession==0){
          var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':   url, 'fileType':  "YTAUDIO",};

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => loadInAppPlayer(
                  type: "INSTA_AUDIO",
                  private: true,
                  isPlaylist:false,
                  item: packedData,
                  path: null,
                )),
          );
        }else{
          var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':  url, 'fileType':  "YTVIDEO",};

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => loadInAppPlayer(
                  type: "INSTA_VIDEO",
                  private: true,
                  isPlaylist:false,
                  item: packedData,
                  path: null,
                )),
          );
        }






        break;


      case "FB":
      // do something

        if(selectedSession==0){
          var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':   url, 'fileType':  "YTAUDIO",};

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => loadInAppPlayer(
                  type: "FB_AUDIO",
                  private: true,
                  isPlaylist:false,
                  item: packedData,
                  path: null,
                )),
          );
        }else{
          var packedData={'docId': url, 'mediaName':  url, 'mediaThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'url':  url, 'fileType':  "YTVIDEO",};

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => loadInAppPlayer(
                  type: "FB_VIDEO",
                  private: true,
                  isPlaylist:false,
                  item: packedData,
                  path: null,
                )),
          );
        }






        break;
    }

  }
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

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
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         NavigatePage(context, LinkFinder());
        //         // NavigatePage(context, PictureInPicturePage());
        //       },
        //       icon: Icon(CupertinoIcons.zoom_in))
        // ],
        title: const Text("Network Stream", style: size16_600W),
      ),

      body:SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: liteBlack),
                child: Row(
                  children: [

                    SizedBox(
                      height: 20,
                      width: 20,
                    ),

                    Expanded(
                      child: TextFormField(
                        controller: streamLinkController,
                      //  keyboardType: TextInputType.number,
                        style: size16_600W,

                        onChanged: (value){

                        },
                        decoration: const InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff808080),
                                fontFamily: 'mon'),
                            hintText: "Paste the URL"),
                      ),
                    ),

                    IconButton(
                      icon: new Icon(Icons.arrow_forward,size: 20,color: Colors.white,),

                      onPressed:()async{

                        //
                        // var check = await DirectLink.check(streamLinkController.text); // add your url
                        //
                        // if (check == null) {
                        //   // null condition
                        //   print("linkkk");
                        //   print(streamLinkController.text);
                        // }else{
                        //   for (var element in check!) {
                        //     print("element.quality");
                        //     print(element.quality);
                        //     print(element.link);
                        //   }
                        // }
                        //
                        // return;
                        if (streamLinkController.text.isEmpty) {
                          showToastSuccess("URL empty!");
                        }else{
                          var rsp = await checkUrl(streamLinkController.text.toString());
                          print("rspppp");
                          print(rsp);
                          newSessionBottomSheet(streamLinkController.text.toString(),rsp,null);
                        }

                      },
                    )
                  ],
                ),
              ),
            ),
            h(30),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Row(children: [
                Text("History",
                    style: size16_600Wt),
                Spacer(),

                // TextButton(
                //   child: Text("Clear", style: size14_600Grey),
                //   // style: TextButton.styleFrom(
                //   //   backgroundColor: themeClr,
                //   // ),
                //   onPressed: historyList.isEmpty?null:()async {
                //     removeAllAlert();
                //
                //   },
                // ),

              ],),
            ),
         //   historyList.isEmpty?emptyList():


            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
              child: PaginateFirestore(
                physics: NeverScrollableScrollPhysics(),
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
                  final item = documentSnapshots[index].data() as Map?;
                  final docId = documentSnapshots[index].id;
                  return item != null
                      ?  GestureDetector(
                    onTap: (){
                      newSessionBottomSheet(item['url'].toString(),item['type'],docId);
                      // goToPage(item['type'],selectedSession,url);
                    },
                        child: ListTile(
                    title:  Text(item['url'].toString(), style: size14_500W),


                    trailing:IconButton(
                        padding: EdgeInsets.all(0),
                        icon:  Icon(CupertinoIcons.clear, size: 20,color: Colors.white),
                        onPressed: (){

                          deleteHistory(docId,);
                        },
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                      )
                      : Container(
                    child: Center(
                      child: Text("No Entries Found!", style: size14_600W),
                    ),
                  );
                },
                // orderBy is compulsory to enable pagination
                query: FirebaseFirestore.instance
                    .collection('StreamHistory')
                    .where('uid', isEqualTo: auth.currentUser!.uid.toString()) .orderBy("stamp", descending: true),
                //  .where('fileType', isEqualTo: "VIDEO")

                // to fetch real-time data
                listeners: [
                  refreshChangeListener,
                ],

                isLive: true,
              ),
            ),

            // h(50),
            // const Text("Invite your friends and have fun together",
            //     style: size14_500Grey),
            // h(30),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: const [
            //     CircleAvatar(
            //       backgroundColor: liteBlack,
            //       radius: 24,
            //       child: Icon(Icons.copy, color: Color(0xffE6E6E6)),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.symmetric(horizontal: 18),
            //       child: CircleAvatar(
            //         backgroundColor: themeClr,
            //         radius: 24,
            //         child: Icon(FontAwesomeIcons.whatsapp, color: Colors.white),
            //       ),
            //     ),
            //     CircleAvatar(
            //       backgroundColor: Color(0xff3282B7),
            //       radius: 24,
            //       radius: 24,
            //       child: Icon(Icons.message, color: Colors.white),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

   removeAlert(index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgClr,
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: const Text('Confirm Delete ?',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'mon',
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Are you sure to delete this item?",
                      style: size14_600W)
                ],
              );
            }),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No", style: size14_600White)),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                var rsp = await removeUrlItem(index);
                  getData();
              },
              child: const Text("Yes", style: size14_600White))
        ],
      ),
    );
  }
  Widget emptyList() {
    return Center( child:  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height:50 ,),
        Text("No history found, Try adding some.", style: size13_600W),
      ],
    ),);

  }
  removeAllAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgClr,
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: const Text('Confirm Delete ?',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'mon',
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Are you sure to delete this item?",
                      style: size14_600W)
                ],
              );
            }),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No", style: size14_600White)),
          TextButton(
              onPressed: () async {
                Navigator.pop(context);
                 var rsp = await rmvSharedPrefrence(URLSTORAGE);
                 setState(() {
                   historyList.clear();

                 });
              },
              child: const Text("Yes", style: size14_600White))
        ],
      ),
    );
  }

  newSessionBottomSheet(url,type,doc) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff4F4F4F),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children:  [
                      Text('Open media', style: size14_600W),
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(CupertinoIcons.xmark_circle_fill,
                            color: grey, size: 25),
                      )
                    ],
                  ),
                  h(5),

                  Divider(
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  h(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSession = 0;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const Icon(CupertinoIcons.music_note_2,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(color: selectedSession==0?themeClr:grey),
                              color: selectedSession == 0 ? themeClr : grey),
                        ),
                      ),
                      w(15),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSession = 1;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const Icon(CupertinoIcons.video_camera_solid,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selectedSession == 1 ? themeClr : grey),
                        ),
                      ),
                    ],
                  ),
                  h(15),
                  GestureDetector(
                    onTap: () async{


                      goToPage(type,selectedSession,url,doc);
                         //
                         // if(selectedSession==0)
                         // {
                         //   var packedData=[{'docId': url, 'fileName':  url, 'fileThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'fileUrl':   url, 'fileType':  "AUDIO",}];
                         //
                         //
                         //   NavigatePage(context, audioPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"AUDIO",isPlaylist:false,url:url));
                         //
                         // }
                         // else
                         //   {
                         //
                         //     var packedData=[{'docId': url, 'fileName':  url, 'fileThumb':  "https://d33v4339jhl8k0.cloudfront.net/docs/assets/591c8a010428634b4a33375c/images/5ab4866b2c7d3a56d8873f4c/file-MrylO8jADD.png", 'fileUrl':   url, 'fileType':  "AUDIO",}];
                         //
                         //
                         //     NavigatePage(context, VideoPlayerLocal(id: 00,type: "CREATE",path: null ,data: packedData  ,index: 0, playingType:"VIDEO",isPlaylist:false,url:url));
                         // }
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => SessionScreen()),
                      // );


                         // var rsp = await addLinkToDb(url);
                         // getData();
                    },
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: themeClr),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10,),
                          Text(
                              "Open",
                              style: size16_600W),

                          SizedBox(width: 5,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 19),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 10),
                  ),
                ],
              ),
            );
          });
        });
  }
}
