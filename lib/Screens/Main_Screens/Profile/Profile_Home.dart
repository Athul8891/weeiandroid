import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Auth/CreateAccount.dart';
import 'package:weei/Screens/Auth/CreateRobot.dart';
import 'package:weei/Screens/Auth/Data/logout.dart';
import 'package:weei/Screens/Auth/EditAccount.dart';
import 'package:weei/Screens/Auth/EnterNumberScreen.dart';
import 'package:weei/Screens/Clean_Files/cleanFilesScreen.dart';
import 'package:weei/Screens/DirectStream/pasteStreamLink.dart';
import 'package:weei/Screens/Friends/BlockedList.dart';
import 'package:weei/Screens/Friends/FirendList.dart';
import 'package:weei/Screens/Friends/FirendRequest.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:open_store/open_store.dart';

import 'package:weei/Screens/Main_Screens/Chat/ChatRequests.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatScreen.dart';
import 'package:weei/Screens/Main_Screens/Chat/blockedChats.dart';
import 'package:weei/Testing/cheiwmusicplayer.dart';

class Profile_Home extends StatefulWidget {
  const Profile_Home({Key? key}) : super(key: key);

  @override
  _Profile_HomeState createState() => _Profile_HomeState();
}

class _Profile_HomeState extends State<Profile_Home> {





  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = true;
  var uid;
  var createdDate;

  var  email;

  var  name;

  var number;

  var profile;

  var  profileType;

  var  purchased;

  var storage;

  var used;

  var username;

  var data;
  var total=0;
  var left=0;

 var notification = true;
  @override
  void initState() {



    this.getData();
    this.listenDataFromFireBase();

    // _controller.addListener(_scrollListener);
    super.initState();
  }
  getData() async {

      uid = auth.currentUser!.uid;
      var noti = await getSharedPrefrence(NOTI);
      print("uidd");
      print(uid);

      if(noti=="false"){
        setState(() {
          notification=false;
        });
      }

    var rsp = await databaseReference.child('Users').child(uid.toString()).once().then(( snapshot) async {


      setState(() {

        data = snapshot;
        createdDate=snapshot.snapshot.child('createdDate').value.toString();

        email=snapshot.snapshot.child('email').value.toString();

        name=snapshot.snapshot.child('name').value.toString();

        number=snapshot.snapshot.child('number').value.toString();

        profile=snapshot.snapshot.child('profile').value.toString();

        profileType=snapshot.snapshot.child('profileType').value.toString();

        purchased=snapshot.snapshot.child('purchased').value.toString();

        storage=snapshot.snapshot.child('storage').value.toString();

        used=snapshot.snapshot.child('used').value.toString();


         print("used");
         print(used);
        username=snapshot.snapshot.child('username').value.toString();
        isLoading=false;
        storageCalc();

      });











      // ignore: void_checks
    });



  }
  listenDataFromFireBase() {

    var db = FirebaseDatabase.instance.reference().child("Users");
    db.child(uid.toString()).onChildChanged.listen((data) {
      //  openFullscreen  , hideFullscreen



      switch (data.snapshot.key.toString()) {
        case "createdDate":
        // do something

          var rsp = data.snapshot.value.toString();

          setState(() {
            createdDate=rsp;
          });
          break;
        case "email":
          var rsp = data.snapshot.value.toString();
          setState(() {
            email=rsp.toString();
          });
          break;
        case "name":
          var rsp = data.snapshot.value.toString();
          setState(() {
            name=rsp.toString();
          });
          break;

        case "number":
          var rsp = data.snapshot.value.toString();
          setState(() {
            number=rsp.toString();
          });
          break;
        case "profile":
          var rsp = data.snapshot.value.toString();
          setState(() {
            profile=rsp;
          });
          break;
        case "profileType":
          var rsp = data.snapshot.value.toString();
          setState(() {
            profileType=rsp.toString();
          });
          break;

        case "purchased":
          var rsp = data.snapshot.value.toString();

          setState(() {
            purchased=rsp.toString();
          });
          storageCalc();
          break;


        case "storage":
          var rsp = data.snapshot.value;
          setState(() {
            storage=rsp.toString();
          });
          storageCalc();

          break;
        case "used":
          var rsp = data.snapshot.value.toString();
          setState(() {
            used=rsp.toString();
          });
          storageCalc();

          break;

        case "username":
          var rsp = data.snapshot.value;

          setState(() {
            username=rsp.toString();
          });
          break;



      }


    });


  }

  storageCalc(){
    setState(() {
      total = (int.parse(storage.toString())+int.parse(purchased.toString()));
    left = (int.parse(used.toString()));
   //   left = used;

      print("left");
      print(left);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BannerAds(),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        //title: const Text("Profile", style: size16_600W),
      ),
      body:isLoading==true?Center(child: CircularProgressIndicator(color: themeClr,)): Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // BannerAds(),
             // h(7),

              topSection(),
              h(10),
              ListTile(
                title: const Text("Notification", style: size14_500W),
                subtitle: const Text("Configure your notification",
                    style: size12_400grey),

                trailing: CupertinoSwitch(value: notification, onChanged: (v)async {
                     setState(() {
                      notification=v;

                     });
                     var set = await setSharedPrefrence(NOTI,notification.toString());
                }),
                contentPadding: EdgeInsets.zero,
              ),
              // uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?  GestureDetector(
              //   onTap: (){
              //     NavigatePage(context, PasteStreamLink());
              //   },
              //   child: ListTile(
              //     title: const Text("Network Stream", style: size14_500W),
              //     subtitle: const Text("Stream directly from open url's",
              //         style: size12_400grey),
              //
              //     trailing: Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white, size: 25),
              //     contentPadding: EdgeInsets.zero,
              //   ),
              // ):Container(),
              uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container():GestureDetector(
                onTap: (){
                  NavigatePage(context, PasteStreamLink());
                },
                child: ListTile(
                  title: const Text("Network Stream", style: size14_500W),
                  subtitle: const Text("Stream directly from open url's",
                      style: size12_400grey),

                  trailing: Icon(CupertinoIcons.antenna_radiowaves_left_right, color: Colors.white, size: 25),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              // profileItems("Requests", "View all", () {
              //   NavigatePage(context, ChatRequestes());
              // }),

              // profileItems("Chats", "View all", () {
              //   NavigatePage(context, ChatScreen());
              // }),
              // profileItems("Blocked", "View all", () {
              //   NavigatePage(context, BlockedChatScreen());
              // }),
              profileItems("Invite your buddy",
                  "Invite your buddies and have fun together", () {
                    if (Platform.isAndroid) {

                      FlutterShare.share(
                        title: "Hey!",
                        text: "Let's chat and stream media together on Weei! , it's a fast, simple, and secure app we can use to message and stream media together for free.",
                        linkUrl: ANDROIDURL,
                        // chooserTitle: 'Example Chooser Title'
                      );
                    } else if (Platform.isIOS) {
                      FlutterShare.share(
                        title: "Hey!",
                        text: "Let's chat and stream media together on Weei! , it's a fast, simple, and secure app we can use to message and stream media together for free.",

                        linkUrl: IOSURL,
                        // chooserTitle: 'Example Chooser Title'
                      );
                    }


                  }),
              profileItems("Rate us", "Help us improve this app", ()async {


                OpenStore.instance.open(
                    appStoreId: '284815942', // AppStore id of your app for iOS
                    appStoreIdMacOS: '284815942', // AppStore id of your app for MacOS (appStoreId used as default)
                    androidAppBundleId: "com.atlabs.weeiapp", // Android app bundle package name
                    windowsProductId: '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
                );
               // NavigatePage(context,CreateAccount());
              }),
              uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container():profileItems("Upgrade Storage",
                  "Check out", () async{
                    showToastSuccess("We're working on this, will be available shortly");
                  }),

              uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container():profileItems("Remove AD's",
                  "Check out", () async{
                    showToastSuccess("We're working on this, will be available shortly");
                  }),
              profileItems("Terms and conditions",
                  "Check out", ()async {

                var url = await getSharedPrefrence(TERMSAND);
                    final Uri _url = Uri.parse(url);

                    if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                    }
                  }),

              profileItems("About",
                  "Check out", () async{
                    var url = await getSharedPrefrence(ABOUT);

                    final Uri _url = Uri.parse(url);

                    if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                    }
                  }),

              profileItems("Privacy",
                  "Check out", () async{
                    var url = await getSharedPrefrence(PRIVACYPOLICY);

                    final Uri _url = Uri.parse(url);

                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }
                  }),
              profileItems("Logout account", "See you next time",
                  () async {
               logoutAccountAlert();
                //signOut();
              }),

              profileItems("Delete account", "Close this account",
                      () async {
                    deleteAccountAlert();
                    //signOut();
                 }),

              profileItems("BgPlay", "See you next time",
                      () async {
                // NavigatePage(context, MyApp());
                    //signOut();
                  }),
              h(20),
            ],
          ),
        ),
      ),
    );
  }

  void logoutAccountAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgClr,
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: const Text('Confirm Logout?',
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
                  Text("Are you sure you want to logout this account?",
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
                var rsp = await signOut();

                NavigatePage(context, const EnterNumber());
              },
              child: const Text("Yes", style: size14_600White))
        ],
      ),
    );
  }
  void deleteAccountAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgClr,
        shape:
        RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
        elevation: 10,
        title: const Text('Confirm Delete?',
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
                  Text("Are you sure you want to delete this account?",
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
                var rsp = await signOut();

                NavigatePage(context, const EnterNumber());
              },
              child: const Text("Yes", style: size14_600White))
        ],
      ),
    );
  }
  storageIndicator() {
    return  StepProgressIndicator(
      totalSteps: (int.parse(storage.toString())+int.parse(purchased.toString())),
      currentStep: int.parse(used.toString()),
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
    );
  }

  div() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Divider(color: Color(0xff404040), thickness: 1),
    );
  }

  topSection() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: liteBlack),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 21),
        child: Column(
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  child: CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.white,
                    backgroundImage:
                    MemoryImage(dataFromBase64String(profile)),
                    //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
                  ),
                  width: 40,
                ),
                w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Text(username, style: size16_600W),
                      Text(number,
                          maxLines: 1, style: size12_500W)
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    NavigatePage(context, EditAccount(number: "",));
                  //  editProfileBottomSheet();
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xff363636),
                    radius: 16,
                    child: Icon(Icons.edit, color: Colors.white, size: 15),
                  ),
                )
              ],
            ),
            h(20),

            uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container():GestureDetector(
             onTap: (){

               Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => const CleanFilesScreen()));
             }
             ,
             child: ListTile(
               title: Column(
                 children: [

                   uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container(): Row(
                     children: [
                       Text( getFileSize(left, 1), style: size14_600W),
                       w(5),
                       Text("used", style: size14_500W),
                       Spacer(),
                       Text( getFileSize(total, 1), style: size14_600W),
                       w(5),
                       // Text("total", style: size14_500W),
                     ],
                   ),
                   uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container():h(15),
                   uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container(): storageIndicator(),
                   //  uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container(): div(),
                   // uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"?Container():Row(
                   //   children: [
                   //     const Spacer(),
                   //     GestureDetector(
                   //         onTap: () {
                   //           Navigator.push(
                   //               context,
                   //               MaterialPageRoute(
                   //                   builder: (context) => const CleanFilesScreen()));
                   //         },
                   //         child: const Text("Clean", style: size16_500Red)),
                   //     w(20),
                   //     const Text(
                   //       "Upgrade",
                   //       style: size16_600G,
                   //     )
                   //   ],
                   // )

                   // GestureDetector(
                   //   onTap: () {
                   //     Navigator.push(
                   //         context,
                   //         MaterialPageRoute(
                   //             builder: (context) => const CleanFilesScreen()));
                   //   },
                   //
                   //   child: Container(
                   //     alignment: Alignment.center,
                   //     decoration: BoxDecoration(
                   //         borderRadius: BorderRadius.circular(10), color: themeClr),
                   //     height: 35,
                   //     child: Text("Clean Files", style: size14_600W),
                   //   ),
                   // )


                 ],
               ),
              // subtitle: Text(subtitle, style: size12_400grey),
               contentPadding: EdgeInsets.zero,
             )



           )

          ],
        ),
      ),
    );
  }

  Widget profileItems(String title, String subtitle, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        title: Text(title, style: size14_500W),
        subtitle: Text(subtitle, style: size12_400grey),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  editProfileBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey[900],
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.grey[200],
                        ),
                        const Positioned(
                            bottom: 0,
                            right: 5,
                            child: CircleAvatar(
                              backgroundColor: Color(0xff363636),
                              radius: 16,
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 15),
                            ))
                      ],
                    ),
                  ),
                  nameTextBox(),
                  emailTextBox(),
                  phoneTextBox(),
                  h(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Spacer(),
                        const Text("Cancel", style: size16_500Red),
                        w(30),
                        const Text(
                          "Save",
                          style: size16_600G,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 10),
                  ),
                ],
              ),
            ));
  }

  Widget nameTextBox() {
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

  Widget phoneTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          style: size16_600W,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff404040))),
              focusedBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: grey)),
              hintStyle: size14_500Grey,
              hintText: "Add Phone Number"),
        ),
      ),
    );
  }
}
