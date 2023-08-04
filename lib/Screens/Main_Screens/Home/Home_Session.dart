import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weei/Helper/ButtonLoading.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/gmtTime.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatScreen.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendNotificationApi.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkSessionExist.dart';
import 'package:weei/Screens/VideoSession/addVideoForSession.dart';
import 'package:weei/webpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../../Helper/navigate.dart';
import '../../Search/Search.dart';

class Session_Home extends StatefulWidget {
  const Session_Home({Key? key}) : super(key: key);

  @override
  _Session_HomeState createState() => _Session_HomeState();
}

class _Session_HomeState extends State<Session_Home> {
  TextEditingController sessionIdController = TextEditingController();
  var selectedSession = 0;
  var private = true;
  var create = true;
  var btTap = false;

  @override
  void initState() {
    super.initState();


    getConnection();
  }


  getConnection()async{
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == false)  {
      noConnectionPopUp();
      return 0;

    }

  }
  void noConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1e1e1e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Text('No connection', style: size14_600W),
                      Spacer(),
                      Icon(Icons.wifi, color: grey, size: 20)
                    ],
                  ),
                  const Divider(
                    color: const Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  const Text(
                      "Please check your internet connection and try again.",
                      style: size14_500Grey),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
        actions:  [GestureDetector(

            onTap: (){
              Navigator.pop(context);
            },
            child: Text("Try again", style: size16_600G))],
        actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      bottomNavigationBar:  BannerAds(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        // leading:Stack(
        //   children: <Widget>[
        //     IconButton(onPressed: () {
        //
        //       NavigatePage(context, ChatScreen());
        //
        //     }, icon: Icon(CupertinoIcons.bubble_left)),
        //     // Positioned(
        //     //   right: 15,
        //     //   top: 10,
        //     //   child: new Container(
        //     //     padding: EdgeInsets.all(1),
        //     //     decoration: new BoxDecoration(
        //     //       color: Colors.red,
        //     //       borderRadius: BorderRadius.circular(6),
        //     //     ),
        //     //     constraints: BoxConstraints(
        //     //       minWidth: 12,
        //     //       minHeight: 12,
        //     //     ),
        //     //     child: SpinKitDoubleBounce(
        //     //       color: Colors.white,
        //     //       size: 7,
        //     //     ),
        //     //   ),
        //     // )
        //   ],
        // )
        //   ,
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //       NavigatePage(context, Search());
        //        // NavigatePage(context, PictureInPicturePage());
        //       },
        //       icon: Icon(CupertinoIcons.search))
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SvgPicture.asset("assets/svg/logo.svg", width: ss.width),
          h(ss.height * 0.1),
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
                      controller: sessionIdController,
                      keyboardType: TextInputType.number,
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
                          hintText: "Enter room code to join"),
                    ),
                  ),

                  IconButton(
                    icon: new Icon(Icons.arrow_forward,size: 20,color: Colors.white,),

                    onPressed:btTap==true?null: () async{

                      if (sessionIdController.text.isEmpty) {
                        showToastSuccess("Room code empty!");
                      } else {

                        setState(() {
                          btTap=true;
                        });
                        print("btTap");
                        print(btTap);
                        var rsp = await checkSessionExist(
                            context, sessionIdController.text.trim());

                        setState(() {
                          btTap=false;
                        });

                        print("btTap");
                        print(btTap);
                        //  NavigatePage(context, VideoPlayerScreen2(id: sessionIdController.text,type: "JOIN",));
                      }

                    },
                  )
                ],
              ),
            ),
          ),
          h(30),

          button(),
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
    );
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: btTap==true? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 3
        ),
      ):GestureDetector(
        onTap: () async {
          // var snd= await sendPushMessage( "Hooooooi",  "hi",  "token");
          //scrapHtml("https://upvid.cc/z3Fb40g0zf");
         // scrapHtml("https://gofile.io/d/9D13Fo");
       //   scrapHtml("https://xhamster20.desi/videos/sudipa-bhabhi-ko-kapre-badal-ke-dekh-chota-debar-ji-ka-chota-land-khara-ho-jayega-full-movie-xh4wfHH");
          //scrapHtml("https://dood.re/d/hl6vzasxmru7");
          newSessionBottomSheet();



          // NavigatePage(context, VideoPlayerScreen(id: sessionIdController.text,));
        },
        child: Container(
          height: 46,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: themeClr),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [

              Text("Create a room", style: size16_600W),
              SizedBox(width: 5,),
              Icon(Icons.add_to_photos_outlined, color: Colors.white,size: 15,),
            ],
          ),
        ),
      ),
    );
  }



  newSessionBottomSheet() {
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
                      Text('Create your session', style: size14_600W),
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (private == true) {
                            setState(() {
                              private = false;
                            });
                          } else {
                            setState(() {
                              private = true;
                            });
                          }
                        },
                        child: Text(
                            private == true ? "Private Session" : "Public Session",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff5484FF),
                                fontFamily: 'mon')),
                      ),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white,size: 15,),
                    ],
                  ),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => addVideoToSession(
                                  type:
                                      selectedSession == 0 ? "AUDIO" : "VIDEO",
                                  private: private,
                                )),
                      );

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => SessionScreen()),
                      // );
                    },
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: themeClr),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.add_to_photos_outlined,
                                color: Colors.white),
                          ),
                          Text(
                              selectedSession == 0
                                  ? "Start music session"
                                  : "Start video session",
                              style: size16_600W)
                        ],
                      ),
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
            );
          });
        });
  }
}
