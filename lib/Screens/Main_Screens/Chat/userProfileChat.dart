import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Auth/Data/logout.dart';
import 'package:weei/Screens/Auth/EnterNumberScreen.dart';
import 'package:weei/Screens/Clean_Files/cleanFilesScreen.dart';
import 'package:weei/Screens/Friends/BlockedList.dart';
import 'package:weei/Screens/Friends/Data/blockContact.dart';
import 'package:weei/Screens/Friends/Data/removeContact.dart';
import 'package:weei/Screens/Main_Screens/Chat/SavedChat.dart';
import 'package:weei/Screens/Main_Screens/Chat/roomAlertBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Screens/Main_Screens/Profile/shareProfileBottomSht.dart';

class userProfileChat extends StatefulWidget {
  final data;
  final path;
  final friendUid;
  final chatPath;
  final myData;
  userProfileChat({this.data,this.path,this.friendUid,this.chatPath,this.myData});
  @override
  _Profile_HomeState createState() => _Profile_HomeState();
}

class _Profile_HomeState extends State<userProfileChat> {
  final FirebaseAuth auth = FirebaseAuth.instance;
   var noti =true;
  var bio;



  var  name;



  var profile;



  var username;

  var data;
  var myData;

  var updateChatData =false;
  var notification =true;
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading =true;
  @override
  void initState() {
    print("widget.dataaaa");
    print(widget.friendUid);
    print(widget.data['profileType']);
    setState(() {
      bio = widget.data['bio']!=null?widget.data['bio']:"";
      name=widget.data['name']!=null?widget.data['name']:"";
      profile=widget.data['profile']!=null?widget.data['profile']:"";
      username=widget.data['username']!=null?widget.data['username']:"";
      myData=widget.myData;


        notification=widget.data['sendNoti'].toString()!="null"?widget.data['sendNoti']:false;



      isLoading=false;
    });
    print("widget.data");
    getData();

    print(widget.friendUid);
  }
  getData() async {


    var rsp = await databaseReference.child('Users').child(widget.friendUid).once().then(( snapshot) async {

      setState(() {



      var   bi=snapshot.snapshot.child('bio').value.toString();
    var   nam=snapshot.snapshot.child('name').value.toString();
       var profil=snapshot.snapshot.child('profile').value.toString();
        var  usernam=snapshot.snapshot.child('username').value.toString();


        if(bi!=bio){
          bio=bi;
         updateChatData=true;
        }
        if(nam!=name){
          name=nam;
          updateChatData=true;

        }
        if(profil!=profile){
          profile=profil;
          updateChatData=true;

        }
        if(usernam!=username){
          username=usernam;
          updateChatData=true;

        }

        if(updateChatData=true){

          upadteChat();


        }







      });


      // ignore: void_checks
    });



  }

  upadteChat(){

    _firestore.collection("Chat").doc(widget.chatPath).update({
      widget.friendUid+".bio": bio,
      widget.friendUid+".name": name,
      widget.friendUid+".profile": profile,
      widget.friendUid+".username": username,

    }).then((_) {
      print("success!");
    });
  }
  upadteNoti(){

    _firestore.collection("Chat").doc(widget.chatPath).update({

      widget.myData['uid']+".sendNoti": notification,

    }).then((_) {
      print("success!");
    });
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
              CupertinoIcons.back,
              color: Colors.white,
              size: 25,
            )),
        automaticallyImplyLeading: false,
        centerTitle: true,
        // title: const Text("Profile", style: size16_600W),
      ),
      body: isLoading==true?Loading():Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topSection(),
              h(20),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text("Actions", style: size15_600W),
              //   ],
              // ),



              // profileTiles(),
              // profileItems("View profile", () {
              //   roomAlert(
              //       context,
              //       "CLEAR",
              //       widget.path,
              //       auth.currentUser!.uid,
              //       widget.data['friendUid']);
              //
              // }),

              profileItems("Saved", () {
              NavigatePage(context,SavedChat(messagePath: widget.chatPath,));

              }),
              profileItems("Clear Chat", () { 
                roomAlert(
                    context,
                    "CLEAR",
                    widget.chatPath,
                    auth.currentUser!.uid,
                    widget.chatPath,
                    widget. data,
                    "userprof"
                );

              }),
              profileItems("Send message", () {

                Navigator.pop(context);
                // roomAlert(
                //     context,
                //     "CLEAR",
                //     widget.chatPath,
                //     auth.currentUser!.uid,
                //     widget.chatPath);

              }),

              profileItems("Remove",  () async{
                roomAlert(
                    context,
                    "REMOVE",
                    widget.chatPath,
                    auth.currentUser!.uid,
                    widget.friendUid,
                    widget. data,
                    "userprof"
                );

              }),
              profileItems("Block",  ()async {

                roomAlert(
                    context,
                    "BLOCK",
                    widget.chatPath,
                    auth.currentUser!.uid,
                    widget.friendUid,
                    widget. data,
                    "userprof"
                );
                // roomAlert(
                //     context,
                //     "BLOCK",
                //     widget.data['messagePath'],
                //     auth.currentUser!.uid,
                //     widget.friendUid);
              }),

              profileItems("Share Profile",  ()async {
                shareProfileBottom( context,   widget.data);

                // roomAlert(
                //     context,
                //     "BLOCK",
                //     widget.data['messagePath'],
                //     auth.currentUser!.uid,
                //     widget.friendUid);
              }),
              profileItems("Report",
                  () {

                showToastSuccess("This profile has been reported!");

                  }),

              ListTile(

                title:  Text("Notification", style: size14_500W),
                subtitle:  Text(notification==true?"Mute notification for this chat":"Enabel notification for this chat",
                    style: size12_400grey),
                trailing: CupertinoSwitch(value: notification, onChanged: (v) {setState(() {
                  notification=v;

                  upadteNoti();
                });}),
                contentPadding: EdgeInsets.zero,
              ),
              h(20),
            ],
          ),
        ),
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
              child: const Text("No", style: size14_600G)),
          TextButton(
              onPressed: () async {
                var rsp = await signOut();

                NavigatePage(context, const EnterNumber());
              },
              child: const Text("Yes", style: size14_600Red))
        ],
      ),
    );
  }

  storageIndicator() {
    return const StepProgressIndicator(
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
    );
  }

  div() {
    return Container(margin:EdgeInsets.only(top: 2,bottom: 2),child: Divider(color: Color(0xff404040), thickness: 1));
  }

  // topSection() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 21),
  //     child: Column(
  //       children: [
  //         Column(
  //           // crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Container(
  //               height: 40,
  //               child: CircleAvatar(
  //                 radius: 50,
  //                 backgroundImage:
  //                 MemoryImage(dataFromBase64String(widget.data['profile'])),
  //                 //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
  //               ),
  //               width: 40,
  //             ),
  //             w(16),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children:  [
  //                   Text(widget.data['name'], style: size16_600W),
  //
  //                 ],
  //               ),
  //             ),
  //
  //           ],
  //         ),
  //         h(20),
  //
  //
  //         Row(
  //           children: [
  //
  //             GestureDetector(
  //                 onTap: () {
  //
  //                   roomAlert(
  //                       context,
  //                       "BLOCK",
  //                       widget.path,
  //                       auth.currentUser!.uid,
  //                       widget.data['friendUid']);
  //                   // Navigator.push(
  //                   //     context,
  //                   //     MaterialPageRoute(
  //                   //         builder: (context) => const CleanFilesScreen()));
  //                 },
  //                 child: const Text("Block", style: size18_500W)),
  //             Spacer(),
  //             GestureDetector(
  //                 onTap: () {
  //
  //                   roomAlert(
  //                       context,
  //                       "REMOVE",
  //                       widget.path,
  //                       auth.currentUser!.uid,
  //                       widget.data['friendUid']);
  //                   // Navigator.push(
  //                   //     context,
  //                   //     MaterialPageRoute(
  //                   //         builder: (context) => const CleanFilesScreen()));
  //                 },
  //                 child: const Text("Remove", style: size18_500W)),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }



  topSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(
        children: [
          Container(
            height: 100,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
             // maxRadius: 100,
              backgroundImage:
              MemoryImage(dataFromBase64String(profile)),
              //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
            ),
            width: 100,

          ),
          h(16),
          Text(name, style: size16_600W),

          h(5),
          Text(bio, style: size14_200GR),

          // Row(
          //   children: [
          //
          //     GestureDetector(
          //         onTap: () {
          //
          //           roomAlert(
          //               context,
          //               "BLOCK",
          //               widget.path,
          //               auth.currentUser!.uid,
          //               widget.data['friendUid']);
          //           // Navigator.push(
          //           //     context,
          //           //     MaterialPageRoute(
          //           //         builder: (context) => const CleanFilesScreen()));
          //         },
          //         child: const Text("Block", style: size18_500W)),
          //     Spacer(),
          //     GestureDetector(
          //         onTap: () {
          //
          //           roomAlert(
          //               context,
          //               "REMOVE",
          //               widget.path,
          //               auth.currentUser!.uid,
          //               widget.data['friendUid']);
          //           // Navigator.push(
          //           //     context,
          //           //     MaterialPageRoute(
          //           //         builder: (context) => const CleanFilesScreen()));
          //         },
          //         child: const Text("Remove", style: size18_500W)),
          //   ],
          // )
        ],
      ),
    );
  }
  Widget profileTiles() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: liteBlack),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your files", style: size16_600W),
            const Divider(color: Color(0xff404040), thickness: 1),
            filesItem(Icons.upload_sharp, "Uploads", () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const UploadsScreen()));
            }),
            filesItem(Icons.play_arrow, "Videos", () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const MyVideosList()));
            }),
            filesItem(CupertinoIcons.music_note_2, "Music", () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const MyMusicList()));
            }),
          ],
        ),
      ),
    );
  }

  filesItem(IconData icon, String txt, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              child: Icon(icon, size: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xffE6E6E6)),
            ),
            w(10),
            Text(txt, style: size14_500W)
          ],
        ),
      ),
    );
  }
  Widget profileItems(String title, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
       // tileColor: liteBlack,
        title: Text(title, style: size14_500W),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 17,
          color: Colors.white,
        ),
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
                  Container(
                    height: 40,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                      MemoryImage(dataFromBase64String(widget.data['profile'])),
                      //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
                    ),
                    width: 40,
                  ),
                  nameTextBox(),
                  // emailTextBox(),
                  // phoneTextBox(),
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
          decoration:  InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xff404040)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: grey),
              ),
              hintStyle: size14_500Grey,
              hintText: widget.data['name']),
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
