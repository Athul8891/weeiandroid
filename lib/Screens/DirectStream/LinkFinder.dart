import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weei/Helper/Const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/DirectStream/Data/directLinkHistory.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatRoom.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/createFriend.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkOngoingSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Screens/MusicPlayer/musicPlayerLocal.dart';
import 'package:weei/Screens/Search/Data/addBot.dart';
import 'package:weei/Screens/Search/Data/addFreind.dart';
import 'package:weei/Screens/Search/Data/checkReq.dart';
import 'package:weei/Screens/Search/SearchChatRoom.dart';
import 'package:weei/Screens/Search/SearchSentWidget.dart';
import 'package:weei/Screens/VideoSession/videoPlayerLocal.dart';
import '../../../Helper/getBase64.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class LinkFinder extends StatefulWidget {



  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<LinkFinder> {
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



  }
  scrapHtml(url)async{
    final parser = await Chaleno().load(url);


    //final contents = parser?.querySelector('.content-card').text;


    var text =parser!.html.toString();
    RegExp exp = new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    if(matches==null){
      showToastSuccess("No results found.");
    }
    matches.forEach((match) {

      var  link =text.substring(match.start, match.end);
      //if(link.toString().toUpperCase().contains('MKV')||link.toString().toUpperCase().contains('MP4')||link.toString().toUpperCase().contains('AVI')){
        setState(() {
          historyList.add(link);
        });
     // }

    });
  }

  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return Scaffold(
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
        actions: [
          // IconButton(
          //     onPressed: () {
          //      // NavigatePage(context, Search());
          //       // NavigatePage(context, PictureInPicturePage());
          //     },
          //     icon: Icon(CupertinoIcons.zoom_in))
        ],
        title: const Text("URL Finder", style: size16_600W),
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

                        if (streamLinkController.text.isEmpty) {
                          showToastSuccess("URL empty!");
                        }else{

                          scrapHtml(streamLinkController.text);
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
                historyList.isNotEmpty?Text("Results",
                    style: size16_600Wt):Container(),
                Spacer(),



              ],),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child:
                  Divider(color: Color(0xff404040), thickness: 1),
                ),
                shrinkWrap: true,
                itemCount: historyList != null ? historyList.length : 0,
                itemBuilder: (context, index) {
                  final item =
                  historyList != null ? historyList[index] : null;

                  return    GestureDetector(
                    onTap: (){
                      FlutterWebBrowser.openWebPage(
                        url: item,
                        customTabsOptions: const CustomTabsOptions(
                          colorScheme: CustomTabsColorScheme.dark,
                          toolbarColor: Colors.deepPurple,
                          secondaryToolbarColor: Colors.green,
                          navigationBarColor: Colors.amber,
                          shareState: CustomTabsShareState.on,
                          instantAppsEnabled: true,
                          showTitle: true,
                          urlBarHidingEnabled: true,
                        ),
                        safariVCOptions: const SafariViewControllerOptions(
                          barCollapsingEnabled: true,
                          preferredBarTintColor: Colors.green,
                          preferredControlTintColor: Colors.amber,
                          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
                          modalPresentationCapturesStatusBarAppearance: true,
                        ),
                      );
                    //  newSessionBottomSheet(item['url'].toString());
                     // NavigatePage(context, PasteStreamLink());
                    },
                    child: ListTile(
                      title:  Text(item.toString(), style: size14_500W),


                      trailing:IconButton(
                        padding: EdgeInsets.all(0),
                        icon:  Icon(Icons.copy, size: 20,color: Colors.white,),
                        onPressed: ()async{
                          await Clipboard.setData(ClipboardData(text: item));

                        },
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  );
                },
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


}
