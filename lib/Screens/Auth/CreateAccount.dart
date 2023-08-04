import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/ButtonLoading.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Texts.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/getBase64.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Auth/Data/createUser.dart';
import 'package:weei/Screens/Auth/Data/logout.dart';
import 'package:weei/Screens/Clean_Files/cleanFilesScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weei/Screens/Main_Widgets/BottomNav.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
class CreateAccount extends StatefulWidget {
  final number;
  final email;
  const CreateAccount({this.number,this.email}) ;

  @override
  _Profile_HomeState createState() => _Profile_HomeState();
}

class _Profile_HomeState extends State<CreateAccount> {
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController unameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var _croppedFile;
  var profileUri ;
  var tap =false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {

   numberController.text=widget.number!=null?widget.number:"";
   emailController.text=widget.email!=null?widget.email:"";


    super.initState();
  }
  Future<bool> _onBackPressed() async {
    bool goBack = false;

    Navigator.pop(context);
    //signOut();


    return goBack;
  }
  _getImage(BuildContext context, ImageSource source) async {
    ImagePicker.platform.getImage(
      source: source,
       imageQuality: 70,
       // maxWidth: 400.0,
       // maxHeight: 400.0,
      // imageQuality: 0,
    ).then(( image) async {
      if (image != null) {
        setState(() {

          print("_imageFile : ${image}");
          print("filePath : ${image.path}");

          _cropImage(image);

          /*String filePath = image.path;
          Uri fileURI = image.uri;*/
        });
      }


    });
  }
  Future<void> _cropImage(_pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        maxWidth: 400,
        maxHeight: 400,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
       // uiSettings: buildUiSettings(context),
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
      print("_croppedFile");
      print(_croppedFile);

    //  Uint8List? fileBytes = _croppedFile.files.first.bytes;
      String? fileName = _croppedFile.path;

      //   File imgfile = File(fileName!);
      //   String path = imgfile.path;
      //   Uint8List imgbytes1 = imgfile.readAsBytesSync();
      //   String bs4str = await base64.encode(imgbytes1);
      // // String img64 = base64Encode(fileBytes!);
      //   // Upload file
      //
      //   updateData(bs4str);
      //   print("fileName");
      //   print(bs4str);


      File imagefile = File(fileName!);
      var rsp = await  getBase64(imagefile);
      print("rsp");
      print(rsp);
setState(() {
  profileUri=rsp;
});

    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: BannerAds(),
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                _onBackPressed();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 22,
              )),
          centerTitle: true,
          actions: [
            Center(
                child:   TextButton(
                  child: tap==true?SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      // valueColor: th,
                      //  strokeWidth: 10,
                      color: Colors.white,
                    ),
                  ) :Text("Done", style: size14_600G),
                  // style: TextButton.styleFrom(
                  //   backgroundColor: themeClr,
                  // ),
                  onPressed:tap==true?null: ()async {


                    if(unameController.text.isEmpty){
                      customSnackBarError(context,"Username empty !",_scaffoldKey,);
                      return;
                    }
                    // if(nameController.text.isEmpty){
                    //   customSnackBarError(context,"Name empty !",_scaffoldKey,);
                    //   return;
                    // }
                    // if(emailController.text.isEmpty){
                    //   customSnackBarError(context,"Email empty !",_scaffoldKey,);
                    //   return;
                    // }
                    if(numberController.text.isEmpty){
                      customSnackBarError(context,"Number empty !",_scaffoldKey,);
                      return;
                    }

                    setState(() {

                      tap=true;
                    });

                   var rsp = await createUser(unameController.text,unameController.text,emailController.text,numberController.text,profileUri,context);


                    setState(() {

                      tap=false;
                    });
                    // checkAndCreateSession(context,itemsId);

                    // createPlayListBottomSheet();
                  },
                ),




                // GestureDetector(
                //     onTap:tap==true?null: ()async {
                //
                //
                //
                //       setState(() {
                //
                //         tap=true;
                //       });
                //       //var rsp =await  createSessionList("VIDEO",itemsId,itemsName,itemsThumb,itemsUrl);
                //   //    var rsp = await createUser(unameController.text,nameController.text,emailController.text,numberController.text,profileUri,context);
                //
                //
                //       setState(() {
                //
                //         tap=false;
                //       });
                //       // checkAndCreateSession(context,itemsId);
                //
                //       // createPlayListBottomSheet();
                //     },
                //     child: tap==true?SizedBox(
                //       height: 20,
                //       width: 20,
                //       child: CircularProgressIndicator(
                //         strokeWidth: 2,
                //         // valueColor: th,
                //         //  strokeWidth: 10,
                //         color: Colors.white,
                //       ),
                //     ) :SizedBox(height:35,child: Text("Done", style: size14_600G)))),
            )],
          title: const Text("Account", style: size16_600W),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child:Column(
              children: [
                // h(37),
                // Center(child: SvgPicture.asset("assets/svg/weei.svg")),

               // h(37),

                h(10),
                GestureDetector(
                  onTap: (){
                    newSessionBottomSheet();
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          height: 120,
                          child: CircleAvatar(
                            radius: 100,

                            backgroundImage:
                            MemoryImage(dataFromBase64String(profileUri==null?PROFILEB64:profileUri)),
                            //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
                          ),
                          width: 120,
                        ),
                       //  CircleAvatar(
                       //    radius: 55,
                       //    backgroundColor: Colors.grey[200],
                       // //   child: profileUri==null?Container():Image.memory(dataFromBase64String(profileUri)),
                       //    child: Container(
                       //      decoration: BoxDecoration(
                       //        shape: BoxShape.circle,
                       //      ),
                       //      child:  profileUri==null?Image.memory(dataFromBase64String(PROFILEB64)):Image.memory(dataFromBase64String(profileUri)),
                       //    )
                       //  ),
                         Positioned(
                            bottom: 0,
                            right: 5,
                            child: CircleAvatar(
                              backgroundColor: Color(0xff363636),
                              radius: 16,
                              child: Icon(Icons.edit, color: Colors.white, size: 15),
                            ))
                      ],
                    ),
                  ),
                ),
                h(25),
                unameTextBox(),
                // nameTextBox(),
                // emailTextBox(),
                phoneTextBox(),
                h(20),

             //   button(),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      top: 10),
                ),
                h(15),
              ],
            )



          ),
        ),
      ),
    );
  }



  div() {
    return Divider(color: Color(0xff404040), thickness: 1);
  }


  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () async{
          //  newSessionBottomSheet();
          setState(() {
            tap = true;
          });
          var rsp = await createUser(unameController.text,nameController.text,emailController.text,numberController.text,profileUri,context);

          setState(() {
            tap = false;
          });
          // if(rsp==true){
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => BottomNav()),
          //   );
          // }else{
          //   showToastSuccess(ERRORCODE);
          // }
          // NavigatePage(context, VideoPlayerScreen(id: sessionIdController.text,));

        },
        child: Container(
          height: 46,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: themeClr),
          child: tap==true?SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3
            ),
          ):Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [

              Text("Create account", style: size16_600W)
            ],
          ),
        ),
      ),
    );
  }




  Widget unameTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child:    Row(
        children: <Widget>[
          SizedBox(width:100,child: Text("Username", style: size14_200W)),
           w(8),
           Container(
            child: Flexible(
              child:  TextFormField(
                style: size14_500W,
                controller: unameController,

                decoration:  InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff404040)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: grey),
                    ),
                    hintStyle: size14_500Grey,
                    hintText: "Eg : WeeiApp_thebest",



                ),
              ),
            ),
            ),//flexible



        ],//widget
      ),












    );
  }


  Widget nameTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: <Widget>[
          SizedBox(width:100,child: Text("Name", style: size14_200W)),
          w(8),
          Container(
            child: Flexible(
              child:   TextFormField(
                style: size14_500W,
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {


                    return 'Please enter some text';
                  }
                  return null;
                },

                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff404040)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: grey),
                    ),
                    hintStyle: size14_500Grey,
                    hintText: "Eg : WeeiApp",

                    //hintText: "Name"
                ),
              ),
            ),
          ),//flexible



        ],//widget
      ),
    );
  }

  Widget emailTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child:  Row(
        children: <Widget>[
          SizedBox(width:100,child: Text("Email", style: size14_200W)),
          w(8),
          Container(
            child: Flexible(
              child:   TextFormField(
                style: size14_500W,
                controller: emailController,
                enabled: widget.email!=null?false:true,
                keyboardType: TextInputType.emailAddress,

                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff404040))),
                    focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: grey)),
                    hintStyle: size14_500Grey,
                    hintText: "Eg : demo@mail.com"


                ),
              ),
            ),
          ),//flexible



        ],//widget
      ),






    );
  }

  Widget phoneTextBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: <Widget>[
          SizedBox(width:100,child: Text("Mobile", style: size14_200W)),
          w(8),
          Container(
            child: Flexible(
              child:   TextFormField(
                style: size14_500W,
                controller: numberController,
                enabled: widget.number!=null?false:true,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff404040))),
                    focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: grey)),
                    hintStyle: size14_500Grey,
                    hintText: "Eg : CODE + 0000000"

                  //  hintText: "Add Phone Number"
                ),
              ),
            ),
          ),//flexible



        ],//widget
      )


    );
  }


  newSessionBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff4F4F4F),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children:  [
                  Text('Choose your image', style: size14_600W),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.xmark_circle_fill,
                        color: grey, size: 25,),
                  )
                ],
              ),
              // h(5),
              // const Text("Private Session",
              //     style: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //         color: Color(0xff5484FF),
              //         fontFamily: 'mon')),
              const Divider(
                color: Color(0xff2F2E41),
                thickness: 1,
              ),
              h(10),
              Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      _getImage( context, ImageSource.gallery);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Icon(Icons.add_photo_alternate,
                          color: Colors.white),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey),
                    ),
                  ),
                  w(15),
                  GestureDetector(
                    onTap: (){
                      _getImage( context, ImageSource.camera);

                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Icon(CupertinoIcons.camera,
                          color: Colors.white),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey),
                    ),
                  ),
                  w(15),
                  profileUri!=null?GestureDetector(
                    onTap: (){

                      setState(() {
                        profileUri=null;

                      });

                      Navigator.pop(context);

                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      child: const Icon(CupertinoIcons.delete,
                          color: Colors.white),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: grey),
                    ),
                  ):Container(),
                ],
              ),
              h(15),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //       builder: (context) => SessionScreen()),
              //     // );
              //   },
              //   child: Container(
              //     height: 46,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: themeClr),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       children: const [
              //         Padding(
              //           padding: EdgeInsets.symmetric(horizontal: 16),
              //           child: Icon(Icons.add_to_photos_outlined,
              //               color: Colors.white),
              //         ),
              //         Text("Start session", style: size16_600W)
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    top: 10),
              ),
            ],
          ),
        ));
  }
}
