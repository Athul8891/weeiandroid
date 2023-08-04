import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weei/Helper/Const.dart';
import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Screens/VideoSession/Data/createSessionList.dart';
import 'package:weei/Testing/constants.dart';
class VideoPlayerScreen extends StatefulWidget {

  final id;
  final path;
  final type;

  VideoPlayerScreen({this.id,this.path,this.type}) ;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  var yourTime= 00000;
  var adminTime= 00000;
  final databaseReference = FirebaseDatabase.instance.reference();

  late BetterPlayerController _betterPlayerController;
  List<BetterPlayerEvent> events = [];
  StreamController<DateTime> _eventStreamController = StreamController.broadcast();
  var loading=true;
  var playList;
  var path;
  var url;
  var control="play";
  bool ctrl=true;
  @override
  void initState() {

    print("widget.id");
    print(widget.id);


   this.getPlayListPath();


    super.initState();
  }


  void getPlayListPath(){


    databaseReference.child('channel').child(widget.id.toString()+"/"+"playlist").once().then(( snapshot) async {
      var _path = snapshot.snapshot.value.toString();
     setState(() {
        path =_path;
      });
      getPlayList(_path);
    });
  }
  void getPlayList(_path){
    databaseReference.child(_path).once().then(( snapshot) async {
      var data = snapshot.snapshot.value;
      playList=data;
     print("datass");
     print(playList[0]['fileUrl']);


    }).whenComplete((){

      if(widget.type.toString()=="CREATE"){
        updateUrl(0);
      }else{
        setUpChannel();
      }

    //  setUpChannel("playList[0][0]['fileUrl']");
    });
  }

  void updateUrl(index){

    databaseReference.child('channel').child(widget.id).update({
      'url': playList[index]['fileUrl'].toString(),
      'index': index.toString(),
    }).whenComplete((){

      setUpChannel();
    });

  }

  void setUpChannel()async{
 //   var rsp = await createSessionList(widget.data,widget.id);
    videoInitilize();
  }
  void videoInitilize(){
    databaseReference.child('channel').child(widget.id.toString()+"/"+"url").once().then(( snapshot) async {

       url = snapshot.snapshot.value.toString();


    }).whenComplete(() {
      BetterPlayerConfiguration betterPlayerConfiguration =
      BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fit: BoxFit.contain,
          autoPlay: true,
          controlsConfiguration:BetterPlayerControlsConfiguration(enableOverflowMenu: false,forwardSkipTimeInMilliseconds: 00000)

      );
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, url);
      _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
      _betterPlayerController.setupDataSource(dataSource);
      _betterPlayerController.addEventsListener(_handleEvent);
      setState(() {
        loading=false;
      });
    });






  }
  void createData(){
    databaseReference.child("channel").child(widget.id).set({
      'time': '00000',

    });
    

  }

  void updateData(time){
    print("timee");
    print(time);
    databaseReference.child('channel').child(widget.id).update({
      'time': time.toString(),
    });

  }

  void readData(){
    databaseReference.child('channel').child(widget.id.toString()+"/"+"time").once().then(( snapshot) async {
      print('Data : ${snapshot.snapshot.value.toString()}');
      var sec = int.parse(snapshot.snapshot.value.toString());
      print("seccccccc");
      print(sec);

      setState(() {
        adminTime =sec;
      });


    });





  }



  void getControls(){

    if(widget.type=="JOIN"){
      databaseReference.child('channel').child(widget.id.toString()+"/"+"controller").once().then(( snapshot) async {
        print('Data : ${snapshot.snapshot.value.toString()}');
        var sec = snapshot.snapshot.value.toString();

        print('controll');
        print(sec);
        setState(() {
          control =sec;
        });

        if(control=="progress"){

          // setState(() {
          //   _betterPlayerController. videoPlayerController?.play();
          // });
        }
        if(control=="pause"){
          setState(() {
            _betterPlayerController. videoPlayerController?.pause();
          });

        }
        if(control=="next"){
          _betterPlayerController. videoPlayerController?.dispose();
          videoInitilize();
        }



      });
    }else{
      databaseReference.child('channel').child(widget.id.toString()+"/"+"controller").once().then(( snapshot) async {
        print('Data : ${snapshot.snapshot.value.toString()}');
        var sec = snapshot.snapshot.value.toString();


        setState(() {
          control =sec;
        });


        if(control=="NEXT"){
          _betterPlayerController. videoPlayerController?.pause();
          setUpChannel();
        }



      });
    }
  }

  void setControls(event){

    databaseReference.child('channel').child(widget.id).update({
      'controller': event.toString(),
    });
  }

  void goLive(){

    _betterPlayerController. videoPlayerController?.pause();
    //
    _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(adminTime.toString()) + 1500))).whenComplete(() {
      setState(() {
        _betterPlayerController. videoPlayerController?.play();

      });
    });


    // _betterPlayerController.play();
    // _betterPlayerController.play();

  }

  @override
  void dispose() {
    _eventStreamController.close();
    _betterPlayerController.removeEventsListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent(BetterPlayerEvent event) {
    var current =_betterPlayerController.videoPlayerController?.value.position.inMilliseconds;
    setState(() {
      yourTime = current!;
    });

    if(widget.type.toString()=="CREATE"){

      updateData(_betterPlayerController.videoPlayerController?.value.position.inMilliseconds);
      setControls(event.betterPlayerEventType.name.toString());

    }else{
      readData();
      getControls();

    }

   // if(current!<=yourTime){
   //  // _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(time.toString()))));
   // }
    print("eventttttttt");
    print(event.betterPlayerEventType.name);
    // event.betterPlayerEventType == BetterPlayerEventType.progress &&
    //     event.parameters != null &&
    //     event.parameters!['progress'] != null &&
    //     event.parameters!['duration'] != null;
    // events.insert(0, event);
    // print(event.betterPlayerEventType.name);
    // print( _betterPlayerController.videoPlayerController?.value.position);
    //
    // ///Used to refresh only list of events
    // _eventStreamController.add(DateTime.now());


  }

  @override
  Widget build(BuildContext context) {
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
        centerTitle: false,
        title: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Text("#" +widget.id.toString(), style: size14_500W),
                w(5),
                const CircleAvatar(
                  backgroundColor: grey,
                  child: Icon(Icons.copy, size: 10),
                  radius: 10,
                )
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color(0xff333333)),
        ),
        actions: [

          IconButton(
              onPressed: () {
                // requestBottomSheet();
                goLive();
              },
              icon: const Icon(
                Icons.live_tv,
              )),
          IconButton(
              onPressed: () {
             requestBottomSheet();

               // readData();
              },
              icon: const Icon(
                Icons.menu,
              )),
          IconButton(
              onPressed: () {
                shareBottomSheet();
              },
              icon: const Icon(
                Icons.share,
              )),
        ],
      ),
      body:loading==true?Loading(): Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              color: Colors.grey,

              child:  BetterPlayer(controller: _betterPlayerController),
            ),
            div(),
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => h(10),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // final item = arrOrderDetail != null
                    //     ? arrOrderDetail[index]
                    //     : null;

                    return chat(index);
                  },
                ),
              ),
            ),
            h(5),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xff333333),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        autofocus: false,
                        style: size14_600W,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: size14_500Grey,
                          hintText: "Type your message here",
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                w(9),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: themeClr),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Send", style: size14_600W),
                  ),
                )
              ],
            ),
            h(10)
          ],
        ),
      ),
    );
  }

  div() {
    return const Divider(color: Color(0xff404040), thickness: 1);
  }

  chat(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 12,
              backgroundColor: grey,
              child: Icon(Icons.person, size: 20, color: liteBlack),
            ),
            w(10),
            const Text("You", style: size14_600W),
            w(8),
            const Text("• " + "06:25", style: size12_400grey)
          ],
        ),
        h(10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 9),
            child: Text("Lorem Ipsum Dolar", style: size14_500W),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23), color: blueClr),
        )
      ],
    );
  }

  requestBottomSheet() {
    return showModalBottomSheet(

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,

        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return   Stack(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                const Text("Your Playlist", style: size14_500W),
                                const Spacer(),
                                IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.clear_circled_solid,
                                      color: Color(0xff363636),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                        ),
                        const Divider(color: Color(0xff404040), thickness: 1),
                        playList==null?emptyPlaylist():
                        Expanded(
                          child: Scrollbar(
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                                separatorBuilder: (context, index) => const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Divider(color: Color(0xff404040), thickness: 1),
                                ),

                              shrinkWrap: true,
                              itemCount: playList != null ? playList.length : 0,
                              itemBuilder: (context, index) {
                                final item = playList != null ? playList[index] : null;

                                return videoList(item,index);
                              },
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
                  ),
                ]);
              });
        });
  }
  videoList(var item,int index) {
    return GestureDetector(
      onTap: (){
   if(widget.type=="CREATE"){
     _betterPlayerController. videoPlayerController?.dispose();
     updateUrl(index);
     setControls("next");
   }
      },
      child: Row(
        children: [
          Container(
            height: 69,
            child: Image.memory( dataFromBase64String(item['fileThumb'])),
            width: 101,
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

                //  const Text("510.5k Views  5 Days ago", style: size14_500Grey),
              ],
            ),
          ),
          w(10),

        ],
      ),
    );
  }
  shareBottomSheet() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        isScrollControlled: true,
        builder: (context) => Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            const Text("Share", style: size14_500W),
                            const Spacer(),
                            IconButton(
                                icon: const Icon(
                                  CupertinoIcons.clear_circled_solid,
                                  color: Color(0xff363636),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: Color(0xff404040), thickness: 1),
                    h(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset("assets/svg/whatsapp-logo.svg"),
                        SvgPicture.asset("assets/svg/messenger-logo.svg"),
                        SvgPicture.asset("assets/svg/instagram-logo.svg"),
                        SvgPicture.asset("assets/svg/sms-logo.svg"),
                      ],
                    ),
                    h(10),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          top: 10),
                    ),
                  ],
                ),
              ),
            ]));
  }

  emptyPlaylist() {
    var ss = MediaQuery.of(context).size;

    return Column(
      children: [
        h(ss.height * 0.3),
        const Text("You have not added any videos", style: size14_500Grey),
        h(ss.height * 0.03),
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: themeClr),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text("Add Video", style: size14_600W),
            ),
          ),
        ),
        h(ss.height * 0.3),
      ],
    );
  }
}
