import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/forwardToFriendBottom.dart';
import 'package:weei/Helper/loadInAppPlayer.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Helper/openSingleMusicVideoBottom.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Auth/CreateAccount.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/createMessagePath.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/enterSessionInChat.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/saveFromChat.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendMessageToFriend.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/sendNotificationApi.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/unsendMessage.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/verifyMessagePath.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/verifyMessagePathNew.dart';
import 'package:weei/Screens/Main_Screens/Chat/addYTForSession.dart';
import 'package:weei/Screens/Main_Screens/Chat/chatMessageBar.dart';
import 'package:weei/Screens/Main_Screens/Chat/roomAlertBox.dart';
import 'package:weei/Screens/Main_Screens/Chat/signleVideoForSession.dart';
import 'package:weei/Screens/Main_Screens/Chat/userProfileChat.dart';
import 'package:weei/Screens/Main_Screens/Chat/voiceNote.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkSessionExist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Helper/getBase64.dart';

class SearchChatRoom extends StatefulWidget {

  final friendData;

  SearchChatRoom({ this.friendData,});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SearchChatRoom> with WidgetsBindingObserver {
  var selectedSession = 0;
  var private = true;
  var rqSended = false;
  var requesting = false;
   var chatPath ;
   var startTime ;

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();
  TextEditingController messageController = TextEditingController();
  TextEditingController voiceNotePlayingListner = TextEditingController();

  int a = 2;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';
  var isLoading = true;
  // var isBlocked = true;
  // var isBlocked = true;

  var bothAccept= false ;
  var blocked= false ;
  var acceptPending ;
  var blockedBy ;
  var friendData ;
  bool _isInForeground = true;
  var myData ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print("daata");

    print(widget.friendData);

    checkStatus();
    //
    // if(widget.messagePath==null){
    //   checkStatus();
    //
    // }else{
    //     setState(() {
    //       chatPath =  widget.messagePath;
    //       startTime =  widget.chatStartTime;
    //       isLoading=false;
    //     });
    // }
  }

  checkStatus()async{

    var rsp = await verifyMessagePathNew(auth.currentUser!.uid,widget.friendData['uid']);

    if(rsp!=null){


       setState(() {
         chatPath=rsp;
       });



         getMessagePathData(chatPath);
    }else{
         print("noo paath");
      setState(() {
        isLoading=false;
      });
    }

    print("rssssp");
    print(chatPath);
  }

  Future getMessagePathData(path) async {


    try {
      // Get reference to Firestore collection
      var collectionRef1 = await _firestore.collection('Chat').doc(path).get().then((snapshot) async{


        setState(() {
          bothAccept=snapshot.get('bothAccept');
          acceptPending=snapshot.get('acceptPending');
          blockedBy=snapshot.get('blockedBy');
          blocked=snapshot.get('blocked');
          friendData = snapshot.get( widget.friendData['uid']);
          myData=snapshot.get(auth.currentUser!.uid);

          isLoading=false;
          requesting=false;
        });
        //  createPath(id1,id2,data);




      });
      listenFromDb();

    } catch (e) {

      showToastSuccess(e.toString());
      throw e;
    }


  }
  listenFromDb()async{
    DocumentReference reference = FirebaseFirestore.instance.collection('Chat').doc(chatPath);
    reference.snapshots().listen((querySnapshot) {
      print("querySnapshot.exists");
      print(querySnapshot.exists);

      if(querySnapshot.exists==false){
        Navigator.pop(context);
        return;
      }

      // field =querySnapshot.get("field");

      setState(() {
        bothAccept=querySnapshot.get('bothAccept');
        acceptPending=querySnapshot.get('acceptPending');
        blockedBy=querySnapshot.get('blockedBy');
        blocked=querySnapshot.get('blocked');
        friendData = querySnapshot.get( widget.friendData['uid']);
        myData = querySnapshot.get( auth.currentUser!.uid);
      });

    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    _isInForeground = state == AppLifecycleState.resumed;
    print("statussss");

    switch (state) {
      case AppLifecycleState.resumed:
        print("statussss");
        print("app in resumed");

        upadteChatNotifier(true,widget.friendData);
        // checkActivity();

        //  print(timer1.cancel);
        break;
      case AppLifecycleState.inactive:
        print("statussss");




        break;
      case AppLifecycleState.paused:
        print("app in paused");
        upadteChatNotifier(false,widget.friendData);

        break;
      case AppLifecycleState.detached:
        print("app in detached");



        break;
    }
  }
  @override
  void dispose() {
    super.dispose();
    upadteChatNotifier(false,widget.friendData);
    print("exitttt");
  }

  upadteChatNotifier(value,data)async{

    if(value==true){
      print("setttt");
      print(data);
      var setName = await setSharedPrefrence(CURRENTCHATNME,data['username']);
      var inchat = await setSharedPrefrence(CURRENTLYINCHAT,value.toString());
    }else{
      var setName = await rmvSharedPrefrence(CURRENTCHATNME);
      var inchat = await rmvSharedPrefrence(CURRENTLYINCHAT);
    }

  }
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    ProgressDialog pd = ProgressDialog(context: context);
    return Scaffold(


      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          (blocked==true||bothAccept==false)?Container(
            margin: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.more_vert,
              color: Colors.grey,
            ),
          ):  PopupMenuButton(
            onSelected: (value) async {
              // _onMenuItemSelected(value as int);
              print("value");
              print(value);
              if (value == 0) {

                //  var rsp = await blockUser(chatPath,auth.currentUser!.uid);


                roomAlert(
                  context,
                  "BLOCK",
                  chatPath,
                  auth.currentUser!.uid,
                  widget.friendData['uid'],
                  widget.friendData,
                    "chatroom"
                );
              }


              if (value == 1) {

                //var rsp = await clearChat(chatPath,auth.currentUser!.uid,widget.friendData['uid'],widget.friendData);
                roomAlert(
                  context,
                  "CLEAR",
                  chatPath,
                  auth.currentUser!.uid,
                  chatPath,
                  widget.friendData,
                  "chatroom"

                );

                // var rsp = await clearMessages((auth.currentUser!.uid +"-"+widget.friendUid));
                //  Navigator.pop(context);
              }
              if (value == 2) {

                NavigatePage(context, userProfileChat(data: widget.friendData,friendUid:widget.friendData['uid'],chatPath:chatPath,myData: myData,));
                // var rsp = await clearMessages((auth.currentUser!.uid +"-"+widget.friendUid));
                //  Navigator.pop(context);
              }
            },
            itemBuilder: (ctx) => [
              _buildPopupMenuItem(' Block', Icons.add, 0),
              _buildPopupMenuItem(' Clear All', Icons.clear, 1),
              _buildPopupMenuItem(' View ', Icons.clear, 2),
              // _buildPopupMenuItem('Copy', Icons.copy, 2),
              // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
            ],
          ),
        ],


        //backgroundColor: liteBlack,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                SizedBox(width: 2,),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);

                      //  NavigatePage(context, userProfileChat(data: widget.friendData,));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                SizedBox(width: 1,),

                GestureDetector(
                  onTap: (blocked==true||bothAccept==false)?null:() {
                    NavigatePage(context, userProfileChat(data: widget.friendData,friendUid:widget.friendData['uid'],chatPath:chatPath,myData: myData,));

                    // NavigatePage(context, userProfileChat(data: widget.friendData,friendUid:widget.friendUid,chatPath:chatPath));
                  },
                  child: Row(children: [

                    CircleAvatar(
                      maxRadius: 20,
                      backgroundColor: grey,
                      backgroundImage: Image.memory(
                          dataFromBase64String(widget.friendData['profile'].toString()),
                          fit: BoxFit.cover)
                          .image,
                      // child: Icon(Icons.person, size: 20, color: liteBlack),
                    ),
                    SizedBox(width: 12,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.friendData['name'].toString(),style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600,color: Colors.white),),
                        //SizedBox(height: 6,),
                        //Text("",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),

                  ],),
                ),


               // Icon(Icons.settings,color: Colors.black54,),
              ],
            ),
          ),
        ),
      ),



      // bottomNavigationBar: isLoading==true?Container():Container(
      //   color: liteBlack,
      //   height: 50,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 10),
      //     child: Row(
      //       children: [
      //         Expanded(
      //           child: Container(
      //             height: 40,
      //             decoration: BoxDecoration(
      //                 color: const Color(0xff333333),
      //                 borderRadius: BorderRadius.circular(10)),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(horizontal: 20),
      //               child: TextFormField(
      //                 controller: messageController,
      //                 cursorColor: Colors.white,
      //                 autofocus: false,
      //                 style: size14_600W,
      //                 decoration: const InputDecoration(
      //                   border: InputBorder.none,
      //                   hintStyle: size14_500Grey,
      //                   hintText: "Type your message here",
      //                   focusedBorder: InputBorder.none,
      //                   enabledBorder: InputBorder.none,
      //                   errorBorder: InputBorder.none,
      //                   disabledBorder: InputBorder.none,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //         w(9),
      //         GestureDetector(
      //           onTap: ()async{
      //
      //             FocusManager.instance.primaryFocus?.unfocus();
      //
      //
      //             sendMeassageToFriend((auth.currentUser!.uid +"-"+widget.friendUid),messageController.text,"TEXT",widget.friendUid,widget.friendData);
      //             setState(() {
      //               messageController.clear();
      //
      //             });
      //           },
      //           child: Container(
      //             alignment: Alignment.center,
      //             height: 40,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(10), color: themeClr),
      //             child: const Padding(
      //               padding: EdgeInsets.symmetric(horizontal: 20),
      //               child: Text("Send", style: size14_600W),
      //             ),
      //           ),
      //         )
      //       ],
      //     )
      //   ),
      // ),
      body:  Stack(
              children: [
                BannerAds(),
                chatPath!=null? Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5,bottom: 50),
                  child: Scrollbar(
                    child: PaginateFirestore(

                      shrinkWrap: true,
                      reverse: true,

                    //  physics: NeverScrollableScrollPhysics(),

                     // onEmpty: (blocked==true||bothAccept==false)?Container():emptyList(),
                      onEmpty: emptyList(),
                      itemBuilderType: PaginateBuilderType.listView,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.65),
                      // Change types accordingly
                      itemBuilder: (context, documentSnapshots, index) {
                        final data = documentSnapshots[index].data() as Map?;
                        return data != null
                            ? Padding(
                                padding: EdgeInsets.only(right: 10, bottom: 10),
                                child: chat(
                                    documentSnapshots[index].id, data, index,pd))
                            : Container(
                                child: Center(
                                  child: Text("No Freinds Found!"),
                                ),
                              );
                      },
                      // orderBy is compulsory to enable pagination
                      query: FirebaseFirestore.instance
                          .collection('Chat')
                          .doc(chatPath)
                          .collection(
                          chatPath)

                          .orderBy("stamp", descending: true),
                      // to fetch real-time data
                      listeners: [
                        refreshChangeListener,
                      ],

                      isLive: true,
                    ),
                  ),
                ):Container(),




                isLoading==true?Container(): chatPath==null? chatPathNull(): blocked==true?blockWidget():(bothAccept==false)?acceptWidget() : Align(
                  alignment: Alignment.bottomCenter,
                  child:  ChatMessageBar(width: width,chatPath:chatPath,friendUid:widget.friendData['uid'],friendData:friendData,startTime:startTime),
                ),

              ],
            ),
    );
  }

  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No conversations found.", style: size13_600W),
        SizedBox(height: 15,),






      ],),);

  }
  chatPathNull(){
    return   Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap:requesting==true?null: ()async{
          setState(() {
            requesting=true;
          });
          var rsp;
          if(widget.friendData['profileType']=="Human"){

            if(widget.friendData['fcmToken'].toString()!="null"&&widget.friendData['sendNoti'].toString()!="false"){
              var name= await getSharedPrefrence(UNAME);
              sendPushMessage(name + " has sended a chat request",  "New chat request 💬",  widget.friendData['fcmToken'].toString());
            }
            rsp = await createPathNew(auth.currentUser!.uid,widget.friendData['uid'],widget.friendData);

          }else{
            rsp = await createPathRobo(auth.currentUser!.uid,widget.friendData['uid'],widget.friendData);
          }

          print("rsssssssp");
          print(rsp);
          getMessagePathData(rsp);
          setState(() {
            chatPath =rsp;
           // requesting=false;

          });



        },
        child: Container(
          height: 40,

          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: themeClr),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [

              Text(requesting==true?"Requested":"Send message request", style: size16_600W),
              // SizedBox(width: 7,),
              //
              // Icon(Icons.send, color: Colors.white,size: 15,),
            ],
          )
        ),
      )

    );
  }

  blockWidget(){
    return blockedBy==auth.currentUser!.uid ?Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child:Container(
            height: 40,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: bgClr),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                TextButton(

                    onPressed:()async{
                      var rsp = await unblockUser(chatPath,auth.currentUser!.uid);


                      print("xx");
                    }, child:  Text("Unblock", style: size16_600W)

                )

                // SizedBox(width: 7,),
                //
                // Icon(Icons.send, color: Colors.white,size: 15,),
              ],
            ),
          )

          ),
          Expanded(child:Container(
            height: 40,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [

                TextButton(

                    onPressed:()async{
                      var rsp = await deleteRquest(chatPath);


                      print("xx");
                    }, child:  Text("Remove", style: size16_600W)

                )
                // SizedBox(width: 7,),
                //
                // Icon(Icons.send, color: Colors.white,size: 15,),
              ],
            ),
          )

          ),
        ],),
    ):Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 25,
        child: Text("You cant replay to this conversation", style: size14_500W),),
    );

  }

  acceptWidget(){
    return acceptPending==auth.currentUser!.uid ?Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child:Container(
            height: 40,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: bgClr),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                TextButton(

                    onPressed:()async{

                      if(widget.friendData['fcmToken'].toString()!="null"&&widget.friendData['sendNoti'].toString()!="false"){
                        var name= await getSharedPrefrence(UNAME);
                        sendPushMessage(name + " has accepted chat request",  "Chat request accepted 💬",  widget.friendData['fcmToken'].toString());
                      }
                      var rsp = await acceptMessage(chatPath);


                      print("xx");
                    }, child:  Text("Accept", style: size16_600W)

                )

                // SizedBox(width: 7,),
                //
                // Icon(Icons.send, color: Colors.white,size: 15,),
              ],
            ),
          )

          ),
          Expanded(child:Container(
            height: 40,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: red),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [

                TextButton(

                    onPressed:()async{
                      var rsp = await deleteRquest(chatPath);

                      print("xx");
                    }, child:  Text("Decline", style: size16_600W)

                )
                // SizedBox(width: 7,),
                //
                // Icon(Icons.send, color: Colors.white,size: 15,),
              ],
            ),
          )

          ),
        ],),
    ):Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: ()async{

          var rsp = await deleteRquest(chatPath);





        },
        child: Container(
            height: 40,

            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: themeClr),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [

                Text("Cancel request", style: size16_600W),
                // SizedBox(width: 7,),
                //
                // Icon(Icons.send, color: Colors.white,size: 15,),
              ],
            )
        ),
      ),
    );

  }
  chat1(var docId, var item, int index) {
    return item['message'].toString().isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: auth.currentUser!.uid == item['uId'].toString()
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            //mainAxisAlignment:  auth.currentUser!.uid==item['uId'].toString()?MainAxisAlignment.end:MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment:
                    auth.currentUser!.uid == item['uId'].toString()
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.center,
                mainAxisAlignment:
                    auth.currentUser!.uid == item['uId'].toString()
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: grey,
                    backgroundImage: Image.memory(
                            dataFromBase64String(item['thumb'].toString()),
                            fit: BoxFit.cover)
                        .image,
                    // child: Icon(Icons.person, size: 20, color: liteBlack),
                  ),
                  w(10),
                  Text(
                      auth.currentUser!.uid == item['uId']
                          ? "You"
                          : item['name'].toString(),
                      style: size14_600W),
                  w(8),
                  Text("• " + item['time'].toString(), style: size12_400grey)
                ],
              ),
              h(10),
              item['type'] == "TEXT"
                  ? GestureDetector(
                      onLongPress: () {
                        if (auth.currentUser!.uid == item['uId']) {
                          moreBottomSheet(item['messagePath'], docId,
                              item['type'], item['uId'], item);
                        } else {
                          print("hisss");

                          moreBottomSheetPartner(item['messagePath'], docId,
                              item['type'], item['uId'], item);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                          child: Text(item['message'].toString(),
                              style: auth.currentUser!.uid == item['uId'] ?size14_500B:size14_500W),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(23),
                            color: auth.currentUser!.uid == item['uId']
                                ? Colors.grey[100]
                                : blueClr),
                      ),
                    )
                  : item['type'] == "ROOMIN"
                      ? GestureDetector(
                          onLongPress: () {
                            if (auth.currentUser!.uid == item['uId']) {
                              moreBottomSheet(item['messagePath'], docId,
                                  item['type'], item['uId'], item);
                            } else {
                              moreBottomSheetPartner(item['messagePath'], docId,
                                  item['type'], item['uId'], item);
                            }
                          },
                          onTap: () async {
                            var rsp = await checkSessionExist(
                                context, item['message']);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "A session going on room " +
                                              item['message'],
                                  style: auth.currentUser!.uid == item['uId'] ?size14_500B:size14_500W,

                                       maxLines: 2,
                                          overflow: TextOverflow.ellipsis),
                                      h(5),
                                      div(),

                                      Text("JOIN",
                                          style: size18_500W,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
                                    ],
                                  ),
                                ),
                                w(10),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: auth.currentUser!.uid == item['uId']
                                    ? Colors.grey[100]
                                    : blueClr),
                          ),
                        )
                      : item['type'] == "FILEMUSIC"
                          ? GestureDetector(
                              onLongPress: () {
                                if (auth.currentUser!.uid == item['uId']) {
                                  moreBottomSheet(item['messagePath'], docId,
                                      item['type'], item['uId'], item);
                                } else {
                                  moreBottomSheetPartner(item['messagePath'],
                                      docId, item['type'], item['uId'], item);
                                }
                              },
                              onTap: () {
                                // singleMediaBottomSheet( item, "AUDIO");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => loadInAppPlayer(
                                        type: "AUDIO",
                                        private: private,
                                        isPlaylist: item['isPlaylist'],
                                        item: item,
                                      )),
                                );
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 69,
                                      child: Image.network(
                                          "https://www.clipartmax.com/png/middle/259-2592401_musical-notes-images-musical-note-icon-png.png"),
                                      width: 101,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    w(10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item['mediaName'].toString(),
                                              style: auth.currentUser!.uid == item['uId'] ?size14_500B:size14_500W,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                          h(5),

                                          //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
                                        ],
                                      ),
                                    ),
                                    w(10),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: auth.currentUser!.uid == item['uId']
                                        ? Colors.grey[100]
                                        : blueClr),
                              ),
                            )
                          : item['type'] == "FILEVIDEO"
                              ? GestureDetector(
                                  onLongPress: () {
                                    if (auth.currentUser!.uid == item['uId']) {
                                      moreBottomSheet(
                                          item['messagePath'],
                                          docId,
                                          item['type'],
                                          item['uId'],
                                          item);
                                    } else {
                                      moreBottomSheetPartner(
                                          item['messagePath'],
                                          docId,
                                          item['type'],
                                          item['uId'],
                                          item);
                                    }
                                  },
                                  onTap: () {

                                    print("taaaaap");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => loadInAppPlayer(
                                            type: "VIDEO",
                                            private: private,
                                            isPlaylist: item['isPlaylist'],
                                            item: item,
                                            path: null,
                                          )),
                                    );
                                 //   singleMediaBottomSheet( item, "VIDEO");
                                  },
                                  child: Container(
                                    height: 50,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 69,
                                          child:item['mediaThumb']==null?Container(): Image.memory(
                                              dataFromBase64String(
                                                  item['mediaThumb'])),
                                          width: 101,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        w(10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item['mediaName'].toString(),
                                                  style: auth.currentUser!.uid == item['uId'] ?size14_500B:size14_500W,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                              h(5),

                                              //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
                                            ],
                                          ),
                                        ),
                                        w(10),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            auth.currentUser!.uid == item['uId']
                                                ? Colors.grey[100]
                                                : blueClr),
                                  ),
                                )
                              :  GestureDetector(
                onLongPress: () {

                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                    child: Text("Message unavailable",
                        style: auth.currentUser!.uid == item['uId'] ?size14_500B:size14_500W),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      color: auth.currentUser!.uid == item['uId']
                          ? Colors.grey[100]
                          : blueClr),
                ),
              )
            ],
          );
  }


  chat(var docId, var item, int index,pd) {
    return item['message'].toString().isEmpty
        ? Container()
        : Column(
      crossAxisAlignment: auth.currentUser!.uid==item['uId']?CrossAxisAlignment.end:CrossAxisAlignment.start,
      children: [
        //h(10),1678123525126 ==>enigma
        //h(10),1669189846368 ==>me bot

              h(5),
              item['type'] == "TEXT"
                  ? GestureDetector(
                      onLongPress: () {

                        // print("hisss");
                        // print(item['stamp']);
                        if (auth.currentUser!.uid == item['uId']) {
                          moreBottomSheet(item['messagePath'], docId,
                              item['type'], item['uId'], item);
                        } else {


                          moreBottomSheetPartner(item['messagePath'], docId,
                              item['type'], item['uId'], item);
                        }
                      },
                      child: Container(
                     //   margin: EdgeInsets.symmetric(horizontal: 25),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                          child: Text(item['message'].toString(), style:auth.currentUser!.uid!=item['uId']?size14_500B: size14_500W),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft:
                              auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                              bottomRight:
                              auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),



                            color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                      ),
                    )
                  : item['type'] == "ROOMIN"
                      ? GestureDetector(
                          onLongPress: () {
                            if (auth.currentUser!.uid == item['uId']) {
                              moreBottomSheet(item['messagePath'], docId,
                                  item['type'], item['uId'], item);
                            } else {
                              moreBottomSheetPartner(item['messagePath'], docId,
                                  item['type'], item['uId'], item);
                            }
                          },
                          onTap: () async {
                            print("staaaaaart");

                            pd.show(max: 100, msg: 'Opening room ' +item['message'],);
                            var rsp = await enterSessionInChat(
                                context, item['message']);

                        
                          },
                          child: Container(
                          //  alignment: Alignment.center,
                            margin: EdgeInsets.only(left: auth.currentUser!.uid==item['uId'] ?15:0,right:auth.currentUser!.uid==item['uId'] ?0:15 ),
                            height: 40,
                            decoration: BoxDecoration(
                                // borderRadius:
                                // BorderRadius.circular(5),

                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft:
                                  auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                                  bottomRight:
                                  auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                color: themeClr),
                            child:  Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20),
                              child:Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // SizedBox(height:100,child: SvgPicture.asset("assets/svg/live.svg",)),
                                  // w(5),
                                  Text("Room started - Tap to join", style: size14_500W),
                                ],
                              ),
                            ),
                          ),
                        )
                      : item['type'] == "FILEMUSIC"
                          ? GestureDetector(
                              onLongPress: () {
                                if (auth.currentUser!.uid == item['uId']) {
                                  moreBottomSheet(item['messagePath'], docId,
                                      item['type'], item['uId'], item);
                                } else {
                                  moreBottomSheetPartner(item['messagePath'],
                                      docId, item['type'], item['uId'], item);
                                }
                              },
                              onTap: () {
                                // singleMediaBottomSheet( item, "AUDIO");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => loadInAppPlayer(
                                        type: "AUDIO",
                                        private: private,
                                        isPlaylist: item['isPlaylist'],
                                        item: item,
                                      )),
                                );
                              },
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.only(left: auth.currentUser!.uid==item['uId'] ?15:0,right:auth.currentUser!.uid==item['uId'] ?0:15 ),
                              //  padding: EdgeInsets.only(top: 15),
                                child: Row(
                               //   mainAxisAlignment: MainAxisAlignment.start,
                                 // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    w(10),
                                    Container(
                                      height: 30,
                                      child: const Icon(Icons.music_note_rounded, color: Colors.pink),
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: auth.currentUser!.uid==item['uId']?Colors.grey[200]:Colors.blue[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    w(10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['mediaName'].toString(),
                                              //textAlign: TextAlign.start,
                                              style:auth.currentUser!.uid==item['uId']?size14_500W: size14_500B,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                          h(2),
                                          Text("Music file",
                                              //textAlign: TextAlign.start,
                                              style:auth.currentUser!.uid==item['uId']?size10_600W: size10_400grey,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                    w(10),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft:
                                      auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                                      bottomRight:
                                      auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),



                                    color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                              ),
                            )
                          : item['type'] == "FILEVIDEO"
                              ? GestureDetector(
                                  onLongPress: () {
                                    if (auth.currentUser!.uid == item['uId']) {
                                      moreBottomSheet(
                                          item['messagePath'],
                                          docId,
                                          item['type'],
                                          item['uId'],
                                          item);
                                    } else {
                                      moreBottomSheetPartner(
                                          item['messagePath'],
                                          docId,
                                          item['type'],
                                          item['uId'],
                                          item);
                                    }
                                  },
                                  onTap: () {

                                    print("taaaaap");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => loadInAppPlayer(
                                            type: "VIDEO",
                                            private: private,
                                            isPlaylist: item['isPlaylist'],
                                            item: item,
                                            path: null,
                                          )),
                                    );
                                 //   singleMediaBottomSheet( item, "VIDEO");
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.only(left: auth.currentUser!.uid==item['uId'] ?15:0,right:auth.currentUser!.uid==item['uId'] ?0:15 ),

                                    child: Row(
                                      children: [
                                        w(10),
                                        Container(
                                          height: 30,
                                          child:item['mediaThumb']==null?Container(): Image.memory(
                                              dataFromBase64String(
                                                  item['mediaThumb'])),
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        w(10),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item['mediaName'].toString(),
                                                  //textAlign: TextAlign.start,
                                                  style:auth.currentUser!.uid==item['uId']?size14_500W: size14_500B,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis),
                                              h(2),
                                              Text("Video file",
                                                  //textAlign: TextAlign.start,
                                                  style:auth.currentUser!.uid==item['uId']?size10_600W: size10_400grey,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis),
                                            ],
                                          ),
                                        ),
                                        w(10),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft:
                                          auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                                          bottomRight:
                                          auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),



                                        color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                                  ),
                                )
                          : item['type'] == "YMUSICBOT"
                                ? GestureDetector(
                onLongPress: () {
                  if (auth.currentUser!.uid == item['uId']) {
                    moreBottomSheet(item['messagePath'], docId,
                        item['type'], item['uId'], item);
                  } else {
                    moreBottomSheetPartner(item['messagePath'],
                        docId, item['type'], item['uId'], item);
                  }
                },
                onTap: () {
                  // singleMediaBottomSheet( item, "AUDIO");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => loadInAppPlayer(
                          type: "YTAUDIO",
                          private: private,
                          isPlaylist: item['isPlaylist'],
                          item: item,
                          path: null,
                        )),
                  );
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: auth.currentUser!.uid==item['uId'] ?15:0,right:auth.currentUser!.uid==item['uId'] ?0:15 ),
                  //  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      w(10),
                      Container(
                        height: 30,
                        child:item['isPlaylist']==true? Container(
                          height: 30,
                          child: const Icon(Icons.video_collection, color: Color(0xff808080)),
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ):Image.network(
                            item['mediaThumb'].toString()),
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                      w(10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['mediaName'].toString(),
                                //textAlign: TextAlign.start,
                                style:auth.currentUser!.uid==item['uId']?size14_500W: size14_500B,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            h(2),
                            Text(item['isPlaylist']==true?"Music playlist":"Music file",
                                //textAlign: TextAlign.start,
                                style:auth.currentUser!.uid==item['uId']?size10_600W: size10_400grey,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      w(10),
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                        bottomRight:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),



                      color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                ),
              )         ///bot music

                  : item['type'] == "YVIDEOBOT"
                  ? GestureDetector(
                onLongPress: () {
                  if (auth.currentUser!.uid == item['uId']) {
                    moreBottomSheet(item['messagePath'], docId,
                        item['type'], item['uId'], item);
                  } else {
                    moreBottomSheetPartner(item['messagePath'],
                        docId, item['type'], item['uId'], item);
                  }
                },
                onTap: () {
                  // singleMediaBottomSheet( item, "AUDIO");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => loadInAppPlayer(
                          type: "YTVIDEO",
                          private: private,
                          isPlaylist: item['isPlaylist'],
                          item: item,
                          path: null,
                        )),
                  );
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: auth.currentUser!.uid==item['uId'] ?15:0,right:auth.currentUser!.uid==item['uId'] ?0:15 ),
                  //  padding: EdgeInsets.only(top: 15),
                  child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      w(10),
                      Container(
                        height: 30,
                        child: item['isPlaylist']==true? Container(
                          height: 30,
                          child: const Icon(Icons.video_collection, color: Color(0xff808080)),
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ):Image.network(
                            item['mediaThumb'].toString()),
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                      w(10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['mediaName'].toString(),
                                //textAlign: TextAlign.start,
                                style:auth.currentUser!.uid==item['uId']?size14_500W: size14_500B,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                           h(2),
                            Text(item['isPlaylist']==true?"Video playlist":"Video file",
                                //textAlign: TextAlign.start,
                                style:auth.currentUser!.uid==item['uId']?size10_600W: size10_400grey,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      w(10),
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                        bottomRight:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),



                      color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                ),
              )
                  : item['type'] == VOICENOTE
                  ? voiceNote(item:item,uid:auth.currentUser!.uid,index:index,voiceNotePlayingListner:voiceNotePlayingListner)
                  : item['type'] == "PROFILE"?
              GestureDetector(
                onLongPress: () {
                  if (auth.currentUser!.uid == item['uId']) {
                    moreBottomSheet(
                        item['messagePath'],
                        docId,
                        item['type'],
                        item['uId'],
                        item);
                  } else {
                    moreBottomSheetPartner(
                        item['messagePath'],
                        docId,
                        item['type'],
                        item['uId'],
                        item);
                  }
                },
                onTap: () {



                  NavigatePage(context, SearchChatRoom(friendData: item['message'],));

                  //   singleMediaBottomSheet( item, "VIDEO");
                },
                child: Container(
                  height: 50,
                  margin: EdgeInsets.only(left: auth.currentUser!.uid==item['uId'] ?15:0,right:auth.currentUser!.uid==item['uId'] ?0:15 ),

                  child: Row(
                    children: [
                      w(10),

                      Container(
                        height: 30,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          MemoryImage(dataFromBase64String(item['mediaThumb'])),
                          //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
                        ),
                        width: 30,
                      ),

                      w(10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['mediaName'].toString(),
                                //textAlign: TextAlign.start,
                                style:auth.currentUser!.uid==item['uId']?size14_500W: size14_500B,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            h(2),
                            Text(item['url'].toString(),
                                //textAlign: TextAlign.start,
                                style:auth.currentUser!.uid==item['uId']?size10_600W: size10_400grey,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      w(10),
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                        bottomRight:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),



                      color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                ),
              ):
              GestureDetector(
                onLongPress: () {

                  // print("hisss");
                  // print(item['stamp']);

                },
                child: Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 23, vertical: 9),
                    child: Text("Message not available", style:auth.currentUser!.uid!=item['uId']?size14_500B: size14_500W),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(20) : Radius.circular(10),
                        bottomRight:
                        auth.currentUser!.uid==item['uId'] ? Radius.circular(6) : Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),



                      color: auth.currentUser!.uid!=item['uId']?Colors.grey[100]:blueClr),
                ),
              ),
            h(5),
        auth.currentUser!.uid==item['uId']?Row(
          mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [

            // Text(auth.currentUser!.uid==item['uId']?"You":item['name'].toString(), style: size12_400wht),
            // w(8),
            Text( item['time'].toString(), style: size10_400grey)
          ],
        ):Row(
          mainAxisAlignment: auth.currentUser!.uid==item['uId']?MainAxisAlignment.end:MainAxisAlignment.start,
          //  crossAxisAlignment: auth.currentUser!.uid==item['uid']?CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [
            Text( item['time'].toString() , style: size10_400grey),



          ],
        ),
            ],
          );
  }

  div() {
    return  Divider(color: Color(0xff404040), thickness: 1);
  }


  moreBottomSheet(item, docid, type, uid, data) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () async {
                        if (type == "TEXT") {
                          await Clipboard.setData(
                              ClipboardData(text: data['message']));
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        type == "TEXT" ? "Copy" : 'Cancel',
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        fwdToFriendBottom(context, data,chatPath);
                      },
                      child: Text(
                        'Forward',
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        unsendMessage(
                            chatPath,
                            docid);
                      },
                      child: Text(
                        'Unsend',
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: ()async {
                        showToastSuccess("Saved");
                        Navigator.pop(context);
                        var rsp = await saveMessage(chatPath,docid);

                        //
                        // unsendMessage(
                        //     chatPath,
                        //     docid);
                      },
                      child: Text(
                        'Save',
                        style: size14_600W,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }


  moreBottomSheetPartner(item, docid, type, uid, data) {
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () async {
                        if (type == "TEXT") {
                          await Clipboard.setData(
                              ClipboardData(text: data['message']));
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        type == "TEXT" ? "Copy" : 'Cancel',
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        fwdToFriendBottom(context, data,chatPath);
                      },
                      child: Text(
                        'Forward',
                        style: size14_600W,
                      ),
                    ),
                  ),
                  div(),
                  Container(
                    height: 40,
                    child: TextButton(
                      onPressed: ()async {
                        showToastSuccess("Saved");
                        Navigator.pop(context);
                        var rsp = await saveMessage(chatPath,docid);
                        //
                        // unsendMessage(
                        //     chatPath,
                        //     docid);
                      },
                      child: Text(
                        'Save',
                        style: size14_600W,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }



  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          //  Icon(iconData, color: Colors.black,size: 10,),
          Text(title),
        ],
      ),
    );
  }



  singleMediaBottomSheet(item,type) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff4F4F4F),
        context: context,
        isScrollControlled: true,

        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: const [
                          Text('Open media', style: size14_600W),
                          Spacer(),
                          Icon(CupertinoIcons.xmark_circle_fill,
                              color: grey, size: 25)
                        ],
                      ),
                      h(5),
                      selectedSession==1?GestureDetector(
                        onTap: (){
                          if(private==true){
                            setState(() {
                              private=false;
                            });
                          }else{
                            setState(() {
                              private=true;
                            });
                          }
                        },
                        child: Text(private==true?"Private Session":"Public Session",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff5484FF),
                                fontFamily: 'mon')),
                      ):Container(),
                      Divider(
                        color: Color(0xff2F2E41),
                        thickness: 1,
                      ),
                      h(10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedSession=0;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: type=="AUDIO"? Icon(CupertinoIcons.music_note_2,
                                  color: Colors.white):Icon(CupertinoIcons.video_camera_solid,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // border: Border.all(color: selectedSession==0?themeClr:grey),
                                  color: selectedSession==0?themeClr:grey),
                            ),
                          ),
                          w(15),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                selectedSession=1;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: const Icon(Icons.meeting_room,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: selectedSession==1?themeClr:grey),
                            ),
                          ),
                        ],
                      ),
                      h(15),
                      GestureDetector(
                        onTap: () {


                          if(selectedSession==0&&type=="AUDIO"){


                            return;
                          }
                          if(selectedSession==0&&type=="VIDEO"){



                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loadInAppPlayer(
                                    type: "VIDEO",
                                    private: private,
                                    isPlaylist: item['isPlaylist'],
                                    item: item,
                                    path: null,
                                  )),
                            );


                            return;
                          }
                          if(selectedSession==1&&type=="AUDIO"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => singleSession(type: "AUDIO",private: private,isPlaylist: false ,item: item,)),
                            );

                            return;

                          }
                          if(selectedSession==1&&type=="VIDEO"){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => singleSession(type: "VIDEO",private: private,isPlaylist: false ,item: item,)),
                            );

                            return;

                          }



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
                            children:  [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(Icons.add_to_photos_outlined,
                                    color: Colors.white),
                              ),
                              Text(selectedSession==0?"Start playing":"Start playing in room", style: size16_600W)
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
