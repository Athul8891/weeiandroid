import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Helper/roomExitBox.dart';
import 'package:weei/Helper/roomExitBoxNav.dart';
import 'package:weei/Helper/roomExitJoinAlertNav.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Home/confirmRemoveUserBox.dart';


class VideoDrawerWidget extends StatefulWidget {
  final type ;
  final room ;

  final id ;
  final uid ;
  final controller ;

  final private ;
  final disableComment ;
  final disableJoinAlert ;
  final disableAdminControls ;
  final controlJoins ;

  final chatSound ;
  final chatPopup ;
  final chatVibrate ;
  final context ;

  VideoDrawerWidget({this.type,this.room,this.id,this.uid,this.controller,this.private,this.disableComment,this.disableJoinAlert,this.disableAdminControls,this.controlJoins,this.chatSound,this.chatPopup,this.chatVibrate,this.context,});
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<VideoDrawerWidget> {

  late Query _ref;

  var pvtSession = false;
  var disableComment = true;
  var chatSound = true;
  var chatPopup = true;
  var chatVibrate = true;
  var disableJoinAlert = true;
  var disableAdminControls = true;
  var controlJoins = true;

  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {



    print("xxxxxxxxxx");
    print(widget.private);
     setState(() {
       if(widget.private=="true"){
         pvtSession=true;
       }else{
         pvtSession=false;

       }
     });

    setState(() {
      if(widget.disableComment.toString()=="true"){
        disableComment=true;
      }else{
        disableComment=false;

      }
    });


    setState(() {
      if(widget.disableJoinAlert.toString()=="true"){
        disableJoinAlert=true;
      }else{
        disableJoinAlert=false;

      }
    });

    setState(() {
      if(widget.disableAdminControls.toString()=="true"){
        disableAdminControls=true;
      }else{
        disableAdminControls=false;

      }
    });

    setState(() {
      if(widget.controlJoins.toString()=="true"){
        controlJoins=true;
      }else{
        controlJoins=false;

      }
    });

    setState(() {
      chatVibrate=widget.chatVibrate;
      chatSound=widget.chatSound;
      chatPopup=widget.chatPopup;
    });
    super.initState();
  }

  Future<bool> _onBackPressed(context) async {
    bool goBack = false;


    if(widget.type=="JOIN"){
      roomExitJoinAlertNav( context,widget.id,widget.uid);
    }else{
      roomExitAlertNav(context,widget.id,widget.uid);

    }
    return goBack;
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Drawer(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[


                // _createDrawerItem(
                //     icon: Icons.favorite_border,
                //     text: 'Favourites',
                //     onTap: () {}
                //     //     Navigator.push(
                //     //   context,
                //     //   MaterialPageRoute(builder: (context) => WishListScreen()),
                //     // )
                //     ),


                SizedBox(height: 45,),

                widget.type=="CREATE"?Container(

                  alignment: Alignment.bottomLeft,
                  //    color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                          value: pvtSession,
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          onChanged: (bool value1) {

                            databaseReference.child('channel').child(widget.id).update({
                              'private': value1.toString(),
                            });
                            setState(() {
                              pvtSession= value1;
                              if(pvtSession==true){
                               widget.controller.text="PVT_SESSION";
                              }else{
                                widget.controller.text="PUBLIC_SESSION";

                              }
                            });

                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Private",
                            style: size14_600W,
                          ),
                        )
                      ],
                    ),
                  ),
                ):Container(),
                Container(

                  alignment: Alignment.bottomLeft,
                  //    color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                          value: disableComment,
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          onChanged: (bool value1) {
                            setState(() {
                              disableComment= value1;
                              if(disableComment==true){
                                widget.controller.text="CHATALERT_TRUE";
                                widget.controller.text="CHATSOUND_TRUE";

                                widget.controller.text="CHATPOPUP_TRUE";
                                widget.controller.text="CHATVIBRATE_TRUE";
                                chatPopup=true;
                                chatSound=true;
                                chatVibrate=true;
                              }else{
                                widget.controller.text="CHATALERT_FALSE";
                                widget.controller.text="CHATSOUND_FALSE";

                                widget.controller.text="CHATPOPUP_FALSE";
                                widget.controller.text="CHATVIBRATE_FALSE";
                                chatPopup=false;
                                chatSound=false;
                                chatVibrate=false;
                              }
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Chat alert",
                            style: size14_600W,
                          ),
                        )
                      ],
                    ),
                  ),
                ),///complete disable chat alert
                ///
                ///
                // Container(
                //
                //   alignment: Alignment.bottomLeft,
                //   //    color: Colors.black54,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 15.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Switch(
                //           value: chatSound,
                //           activeColor: Colors.white,
                //           inactiveThumbColor: Colors.white,
                //           onChanged:disableComment==false?null: (bool value1) {
                //             setState(() {
                //               chatSound= value1;
                //               if(chatSound==true){
                //                 widget.controller.text="CHATSOUND_TRUE";
                //               }else{
                //                 widget.controller.text="CHATSOUND_FALSE";
                //
                //               }
                //             });
                //           },
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(left: 15.0),
                //           child: Text(
                //             "Chat alert sound",
                //             style: size14_600W,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),///complete disable chat sound only
                // Container(
                //
                //   alignment: Alignment.bottomLeft,
                //   //    color: Colors.black54,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 15.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Switch(
                //           value: chatPopup,
                //           activeColor: Colors.white,
                //           inactiveThumbColor: Colors.white,
                //           onChanged: disableComment==false?null:(bool value1) {
                //             setState(() {
                //               chatPopup= value1;
                //               if(chatPopup==true){
                //                 widget.controller.text="CHATPOPUP_TRUE";
                //               }else{
                //                 widget.controller.text="CHATPOPUP_FALSE";
                //
                //               }
                //             });
                //           },
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(left: 15.0),
                //           child: Text(
                //             "Chat alert popup",
                //             style: size14_600W,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),///complete disable chat pop only
                // Container(
                //
                //   alignment: Alignment.bottomLeft,
                //   //    color: Colors.black54,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 15.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Switch(
                //           value: chatVibrate,
                //           activeColor: Colors.white,
                //           inactiveThumbColor: Colors.white,
                //           onChanged: disableComment==false?null:(bool value1) {
                //             setState(() {
                //               chatVibrate= value1;
                //               if(chatVibrate==true){
                //                 widget.controller.text="CHATVIBRATE_TRUE";
                //               }else{
                //                 widget.controller.text="CHATVIBRATE_FALSE";
                //
                //               }
                //             });
                //           },
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(left: 15.0),
                //           child: Text(
                //             "Chat alert vibrate",
                //             style: size14_600W,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),///complete disable chat vibrate

                widget.type=="CREATE"?Container(

                  alignment: Alignment.bottomLeft,
                  //    color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                          value: disableJoinAlert,
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          onChanged: (bool value1) {
                            setState(() {
                              disableJoinAlert= value1;
                              if(disableJoinAlert==true){
                                widget.controller.text="JOINALERT_TRUE";
                              }else{
                                widget.controller.text="JOINALERT_FALSE";
                              }
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Join Alert",
                            style: size14_600W,
                          ),
                        )
                      ],
                    ),
                  ),
                ):Container(),
                widget.type=="JOIN"?Container(

                  alignment: Alignment.bottomLeft,
                  //    color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                          value: disableAdminControls,
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          onChanged: (bool value1) {
                            setState(() {
                              disableAdminControls= value1;
                              if(disableAdminControls==true){
                                widget.controller.text="ADMINCONTROLS_TRUE";

                              }else{
                                widget.controller.text="ADMINCONTROLS_FALSE";

                              }
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Creator Controls",
                            style: size14_600W,
                          ),
                        )
                      ],
                    ),
                  ),
                ):Container(),
                widget.type=="CREATE"?Container(

                  alignment: Alignment.bottomLeft,
                  //    color: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Switch(
                          value: controlJoins,
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white,
                          onChanged: (bool value1) {
                            setState(() {
                              controlJoins= value1;
                              if(controlJoins==true){
                                widget.controller.text="JOINCONTROLS_TRUE";



                              }else{
                                widget.controller.text="JOINCONTROLS_FALSE";

                              }
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Control Joins",
                            style: size14_600W,
                          ),
                        )
                      ],
                    ),
                  ),
                ):Container(),

                Padding(
                  padding: EdgeInsets.only(left: 20.0,top: 10),
                  child: Text(
                    "Session on going ",
                    style: size14_600G,
                  ),
                ),


                GestureDetector(
                  onTap: (){
                    print("exttt");
                    // setState(() {
                    //   widget.navigationExitListner.text= DateTime.fromMillisecondsSinceEpoch.toString();
                    //
                    // });
                   _onBackPressed(widget.context);
                  //  roomExitJoinAlert( context,widget.id,auth.currentUser!.uid);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), color: red),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          SizedBox(width: 15,),
                          Icon(Icons.arrow_back_ios, color: Colors.white ,size: 15,),
                          SizedBox(width: 15,),
                          Text("Leave Session", style: size14_600W),
                          Spacer(),

                        ],
                      ),
                    ),
                  ),
                ),
                BannerAds()
                // Container(
                //   height:  double.maxFinite,
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 20.0,top: 10),
                //     child: FirebaseAnimatedList(
                //       query: _ref,
                //       // reverse: true,
                //       itemBuilder: (BuildContext context, DataSnapshot snapshot,
                //           Animation<double> animation, int index) {
                //         // Object? contact = snapshot.value;
                //         // contact['key'] = snapshot.key;
                //         return participantsList( snapshot.value,index);
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  participantsList(var item,int index) {
    return GestureDetector(
      onTap: widget.uid==item['uid']?null:(){


      },
      child: Column(
        children: [
          Row(
            children: [

              CircleAvatar(
                radius: 15,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                      child:  Container(
                        height: 30,
                        color: Colors.black,
                        child:Image.memory( dataFromBase64String(item['img']),gaplessPlayback: true,),
                        width: 30,

                      ),
                    ),


                  ],
                ),
              ),

              w(10),
              Text(item['name'], style: size14_600White,maxLines: 1, overflow: TextOverflow.ellipsis,),
              w(15),
             widget.uid==item['uid']?Text("Creator", style: size12_600Gold): Text("", style: size14_600Red)
            ],
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
  reqList(int index) {
    return Row(
      children: [
        const Icon(CupertinoIcons.person_alt_circle_fill,
            color: grey, size: 50),
        w(15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Name", style: size14_600W),
              Text("Email", style: size12_400grey)
            ],
          ),
        ),
        // accepted(),
        // rejected()
        IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.clear_thick_circled,
                color: red, size: 30)),
        IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.check_mark_circled_solid,
                color: Colors.green, size: 30)),
      ],
    );
  }

  Widget accepted(txt) {
    return  Text(txt, style: size14_600G);
  }

  Widget rejected(txt) {
    return  Text(txt, style: size14_600Red);
  }

  Widget _createDrawerItem(
      { required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          CupertinoSwitch(
            value:  false,
            onChanged: (value) async {
              //  pr.show();
              // var chk = await checkCircle();
              //
              // if(chk==true){
              //   pr.hide();
              //
              //   return;
              // }



              //  pr.hide();
            },
            activeColor: themeClr,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              text,
              style: size12_500W,
            ),
          )
        ],
      ),

    );
  }
}




