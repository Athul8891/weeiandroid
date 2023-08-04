import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_store/open_store.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatScreen.dart';
import 'package:weei/Screens/Main_Screens/Library/Library_Home.dart';
// import '../Main_Screens/Lib/Library_Home.dart';
import '../Main_Screens/Profile/Profile_Home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Main_Screens/Home/Home_Session.dart';
import 'package:package_info/package_info.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var uid;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getVersion();
    showApology();
    setState(() {});
  }

  int _currentIndex = 0 ;
  final GlobalKey _bottomNavigationKey = GlobalKey();

  final List<Widget> viewContainer = [
    //  ChatScreen(),

    const Session_Home(),

    const Library_Home(),

    const Profile_Home(),
  ];


  showApology()async{
    uid = auth.currentUser!.uid;
    if( uid=="8Q76Af0KiJfS0TzbGnqyC190P0j1"){
      return;
    }



    var aplogy = await getSharedPrefrence(APLOGY);
    var alertShow = await getSharedPrefrence(STARTALERTSHOW);
    var alertDiss = await getSharedPrefrence(STARTALERTDISSMISS);
    var alertTxt = await getSharedPrefrence(STARTALERT_TXT);
    var alertTitle = await getSharedPrefrence(STARTALERT_TITLE);

    if(aplogy!="true"||alertShow=='true'){
      apologySheet(alertDiss,alertTxt,alertTitle);
    }
  }






  Future<bool> _onBackPressed() async {
    bool goBack = false;

    if (_currentIndex != 0) {
      print("aaaaaaaaaaaaaa");
      setState(() {
        _currentIndex = 0;
        print(_currentIndex);
      });
    } else {
      print("Exit?");
      exitSheet();
    }
    return goBack;
  }




  getVersion() async {

    var version = await getSharedPrefrence(CURRENTVERSION);
    var txt = await getSharedPrefrence(UPDATETEXT);
    var mandatory = await getSharedPrefrence(MANDATORY);
    var build = await getSharedPrefrence(BUILDVERSION);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    var currentVersion = packageInfo.buildNumber;

    print("verssssion");
    print(version);
    print(build);

    print("verssssion");

    if(currentVersion!=version){

      newUpdateSheet(mandatory,txt,build);
    }



  }

  exitSheet()async {

    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: liteBlack,
        context: context,
        // enableDrag:mandatory=='true'? false:true,
        // isDismissible:mandatory=='true'? false:true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Container(
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(20), color: liteBlack),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children:  [
                        Text("Exiting?", style: size14_600W),
                        Spacer(),

                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Color(0xff404040), thickness: 1),
                    ),
                    Text("Do you really want to exit?", style: size14_500Grey),
                    h(25),
                    Row(
                      children: [
                        Expanded(
                          child: buttons("Exit", themeClr, ()async {

                            SystemNavigator.pop();
                            // if (Platform.isAndroid) {
                            //   // Android-specific code
                            //   // final Uri _url = Uri.parse(ANDROIDURL);
                            //   //
                            //   // if (!await launchUrl(_url)) {
                            //   //   throw Exception('Could not launch $_url');
                            //   // }
                            //
                            //
                            // } else if (Platform.isIOS) {
                            //   // iOS-specific code
                            //   final Uri _url = Uri.parse(IOSURL);
                            //
                            //   if (!await launchUrl(_url)) {
                            //     throw Exception('Could not launch $_url');
                            //   }
                            // }

                          }

                          ),
                        ),
                        SizedBox(width: 5,),
                        Expanded(
                          child: buttons("Cancel", grey, ()async {

                            Navigator.pop(context);
                            // if (Platform.isAndroid) {
                            //   // Android-specific code
                            //   // final Uri _url = Uri.parse(ANDROIDURL);
                            //   //
                            //   // if (!await launchUrl(_url)) {
                            //   //   throw Exception('Could not launch $_url');
                            //   // }
                            //
                            //
                            // } else if (Platform.isIOS) {
                            //   // iOS-specific code
                            //   final Uri _url = Uri.parse(IOSURL);
                            //
                            //   if (!await launchUrl(_url)) {
                            //     throw Exception('Could not launch $_url');
                            //   }
                            // }

                          }

                          ),
                        ),



                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
  apologySheet(alertDiss,alertTxt,alertTitle)async {
    var set= await setSharedPrefrence(APLOGY,"true");
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: liteBlack,
        context: context,
        // enableDrag:mandatory=='true'? false:true,
        // isDismissible:mandatory=='true'? false:true,
        enableDrag:alertDiss=='true'? true:false,
        isDismissible:alertDiss=='true'? true:false,
        isScrollControlled: true,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => alertDiss=='true'? true:false,
            child: StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Container(
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20), color: liteBlack),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children:  [
                          Text(alertTitle.toString().isEmpty?"Welcome , Sorry for the AD's":alertTitle, style: size14_600W),
                          Spacer(),

                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: Color(0xff404040), thickness: 1),
                      ),
                      Text(alertTxt.toString().isEmpty?"Currently we're in a struggling stage as a startup company, to run the system ad revenue is used. We are trying to improve and remove AD's in upcomimg updates. \n If we some how interrupt your user experience  *APOLOGIES*":alertTxt, style: size14_500Grey),
                      h(25),
                      Row(
                        children: [
                          alertDiss=='true'?Expanded(
                            child: buttons("Close", themeClr, ()async {

                              Navigator.pop(context);
                              // if (Platform.isAndroid) {
                              //   // Android-specific code
                              //   // final Uri _url = Uri.parse(ANDROIDURL);
                              //   //
                              //   // if (!await launchUrl(_url)) {
                              //   //   throw Exception('Could not launch $_url');
                              //   // }
                              //
                              //
                              // } else if (Platform.isIOS) {
                              //   // iOS-specific code
                              //   final Uri _url = Uri.parse(IOSURL);
                              //
                              //   if (!await launchUrl(_url)) {
                              //     throw Exception('Could not launch $_url');
                              //   }
                              // }

                            }

                            ),
                          ):Container(),




                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
  newUpdateSheet(mandatory,txt,build) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: liteBlack,
        context: context,
        enableDrag:mandatory=='true'? false:true,
        isDismissible:mandatory=='true'? false:true,
        isScrollControlled: true,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => mandatory=='true'? false:true,
            child: StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Container(
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20), color: liteBlack),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children:  [
                          Text("Update available", style: size14_600W),
                          Spacer(),
                          Text("v "+build, style: size12_400grey),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: Color(0xff404040), thickness: 1),
                      ),
                      Text(txt, style: size14_500Grey),
                      h(25),
                      Row(
                        children: [
                          Expanded(
                            child: buttons("Update", themeClr, ()async {

                              OpenStore.instance.open(
                                  appStoreId: '284815942', // AppStore id of your app for iOS
                                  appStoreIdMacOS: '284815942', // AppStore id of your app for MacOS (appStoreId used as default)
                                  androidAppBundleId: "com.atlabs.weeiapp", // Android app bundle package name
                                  windowsProductId: '9NZTWSQNTD0S' // Microsoft store id for Widnows apps
                              );
                              // if (Platform.isAndroid) {
                              //   // Android-specific code
                              //   // final Uri _url = Uri.parse(ANDROIDURL);
                              //   //
                              //   // if (!await launchUrl(_url)) {
                              //   //   throw Exception('Could not launch $_url');
                              //   // }
                              //
                              //
                              // } else if (Platform.isIOS) {
                              //   // iOS-specific code
                              //   final Uri _url = Uri.parse(IOSURL);
                              //
                              //   if (!await launchUrl(_url)) {
                              //     throw Exception('Could not launch $_url');
                              //   }
                              // }

                            }

                            ),
                          ),
                          w(10),
                          mandatory=="false"?Expanded(
                            child: buttons("Later", const Color(0xff333333), () {
                              Navigator.pop(context);

                            }),
                          ):Container(),


                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        });
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: viewContainer[_currentIndex],
        bottomNavigationBar: SizedBox(
          height: 50,
          child: CustomNavigationBar(
            scaleFactor: 0.1,
            unSelectedColor: Colors.grey,
            strokeColor: themeClr,
            elevation: 0,
            iconSize: 22,
            blurEffect: false,
            selectedColor: Colors.white,
            backgroundColor: const Color(0xff2b2b2b),
            key: _bottomNavigationKey,
            currentIndex: _currentIndex,
            onTap: (index) async {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              // CustomNavigationBarItem(
              //     icon: const Icon(CupertinoIcons.chat_bubble_2_fill,
              //         color: Colors.grey),
              //     selectedIcon: const Icon(CupertinoIcons.chat_bubble_2_fill,
              //         color: Colors.white)),


              CustomNavigationBarItem(
                  icon: Icon(CupertinoIcons.share,
                    color: Colors.grey,size: 24,),
                  selectedIcon:Icon(CupertinoIcons.share,
                    color: Colors.white,size: 24,)),
              CustomNavigationBarItem(
                  icon: SvgPicture.asset("assets/svg/library.svg", color: grey),
                  selectedIcon: SvgPicture.asset("assets/svg/library.svg",
                      color: Colors.white)),


              CustomNavigationBarItem(
                  icon: SvgPicture.asset("assets/svg/profile.svg", color: grey),
                  selectedIcon: SvgPicture.asset("assets/svg/profile.svg",
                      color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
