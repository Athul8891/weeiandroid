import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Loading.dart';
import 'package:weei/Helper/cofirmExitAlert.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Screens/Clean_Files/clean_Music.dart';
import 'package:weei/Screens/Clean_Files/clean_video.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
class CleanFilesScreen extends StatefulWidget {
  const CleanFilesScreen({Key? key}) : super(key: key);

  @override
  _CleanFilesScreenState createState() => _CleanFilesScreenState();
}

class _CleanFilesScreenState extends State<CleanFilesScreen> {


  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController alertController = TextEditingController();

  var isLoading = true;


  var  uid;
  var  purchased;

  var storage;

  var used;


  var total=0;
  var left=0;


  @override
  void initState() {



    this.getData();
    this.listenDataFromFireBase();

    // _controller.addListener(_scrollListener);
    super.initState();
  }
  getData() async {

    uid = auth.currentUser!.uid;

    var rsp = await databaseReference.child('Users').child(uid.toString()).once().then(( snapshot) async {


      setState(() {



        purchased=snapshot.snapshot.child('purchased').value.toString();

        storage=snapshot.snapshot.child('storage').value.toString();

        used=snapshot.snapshot.child('used').value.toString();


        storageCalc();
        isLoading=false;
      });











      // ignore: void_checks
    });



  }
  listenDataFromFireBase() {

    var db = FirebaseDatabase.instance.reference().child("Users");
    db.child(uid.toString()).onChildChanged.listen((data) {
      //  openFullscreen  , hideFullscreen



      switch (data.snapshot.key.toString()) {








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
  Future<bool> _onBackPressed() {

    if(alertController.text.isEmpty||alertController.text=="NILL"){
      Navigator.pop(context);

    }else{
      confirmExitAlert( context);
    }
    return Future<bool>.value(true);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  _onBackPressed();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18,
                )),
            centerTitle: true,
            title: const Text("Clean Files", style: size16_600W),
          ),
          body: isLoading==true?Loading(): Column(
            children: [

              (alertController.text.isEmpty||alertController.text=="NILL")  ?Container(): Container(
                height: 25,
                decoration: BoxDecoration(

                    color: themeClr),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [

                    Text( alertController.text, style: size13_600W)
                  ],
                ),
              ),
              h(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
                children: [
                   Text(getFileSize(left, 1), style: size14_600W),
                  w(5),
                   Text("used", style: size14_500W),
                   Spacer(),
                   Text(getFileSize(total, 1), style: size14_600W),
                  w(5),
                  // Text("total", style: size14_500W),
                ],
              )),
              h(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: storageIndicator()),
              h(30),
              TabBar(
                  isScrollable: true,
                  unselectedLabelStyle: size14_500Grey,
                  labelStyle: size14_600W,
                  tabs: const [Text("Music"), Text("Video")],
                  labelPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  indicator: BoxDecoration(
                      color: liteBlack,
                      borderRadius: BorderRadius.circular(10))),
              h(20),
               Expanded(
                child: TabBarView(children: [
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: cleanMusic(alert: alertController,)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: cleanVideo(alert: alertController,)),
                ]),
              )
            ],
          ),
        ),
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
}
