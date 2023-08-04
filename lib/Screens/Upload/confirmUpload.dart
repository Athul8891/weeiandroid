import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/cofirmExitAlert.dart';
import 'package:weei/Helper/getFileSize.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Clean_Files/cleanFilesScreen.dart';
import 'package:weei/Screens/UpgradeScreen.dart';
import 'package:weei/Screens/Upload/Data/fetchUrl.dart';
import 'package:weei/Screens/Upload/Data/getServer.dart';
import 'package:weei/Screens/Upload/Data/getStorage.dart';
import 'package:weei/Screens/Upload/Data/uploadFileApi.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weei/Helper/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:weei/Screens/Upload/Data/tst.dart';

class ConfirmUploadsScreen extends StatefulWidget {
  final type;
  ConfirmUploadsScreen({this.type});

  @override
  _UploadsScreenState createState() => _UploadsScreenState();
}

class _UploadsScreenState extends State<ConfirmUploadsScreen> {
  bool tap = false;
  var uploadStatus = [
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false"
        "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false"
  ];
  var directoryPath = [];

  var fileName = [];
  var fileSize = [];
  var fileLength = [];
  var uploadStart = false;
  var currentUploadIndex = 10000;
  var currentUploadPer = "0";

  List<PlatformFile>? _paths;

  @override
  void initState() {
    super.initState();

    // this. createData();
    this._pickFiles();
  }

  void dispose(){
    super.dispose();

  }
  Future<bool> _onBackPressed() {

if(tap==true){
  confirmExitAlert( context);
}else{
  Navigator.pop(context);
}
    return Future<bool>.value(true);
  }
  Future  uploadFileApi2(fileLength,filePath,server,index ) async {
    print("server");
    print(server);

   var convertDataToJson;


    final request = MultipartRequest(
      'POST',
      Uri.parse('https://'+server+'.gofile.io/uploadFile'),
      onProgress: (int bytes, int total) {
        final progress = bytes / total;

        print(progress.toStringAsFixed(2).split(".").last );

        setState(() {

          if(progress.toString()=="1.0"){
            currentUploadPer="100";
          }else{
            currentUploadPer=progress.toStringAsFixed(2).split(".").last.toString();
          }

        });
        print('progress: $progress ($bytes/$total)');
      },
    );

    // request.headers['HeaderKey'] = 'header_value';
    request.fields['token'] = 'G2T0F6TTiNFlct1lc3lG9s7ArhJ3lDre';
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        //contentType: MediaType('image', 'jpeg'),
      ),
    );

    final streamedResponse = await request.send();
    if (streamedResponse.statusCode == 200) {
      var rsp = await streamedResponse.stream.bytesToString();
      convertDataToJson = json.decode(rsp);
      // showToastSuccess(convertDataToJson.toString());
    }
    else {
      convertDataToJson=0;
      print(streamedResponse.reasonPhrase);
    }
    return convertDataToJson;
  }


  void _uploadFile(updateStorage) async {
    setState(() {
      uploadStart = true;
    });
    for (var i = 0; i < directoryPath.length; i++) {

      setState(() {
        currentUploadIndex=i;
        currentUploadPer="0";
      });
      var server = await getServerApi();
      if (server['status'] == "noServer") {
        showToastSuccess(
            "Server under maintenance.\nPlease wait and try again later!");
        setState(() {
          uploadStart = false;
          tap = false;
        });
        return;
      }
      var rsp = await uploadFileApi2(fileSize[i],
          directoryPath[i], server['data']['server'].toString(),i);

           print("ulpooded");
           print(rsp);
      if (rsp != 0) {
        var snd = await fetchUrlApi(rsp['data']['fileId'].toString(),
            widget.type, fileSize[i].toString(), directoryPath[i]);
        setState(() {

          uploadStatus.insert(i, "true");
         // tap = false;
          if(directoryPath.length==i+1){

            // addToStorage(updateStorage);
            currentUploadIndex=10000;
            directoryPath.clear();

            fileName.clear();
            fileSize.clear();
            fileLength.clear();
            uploadStart = false;
            tap = false;
            Navigator.pop(context);
            showToastSuccess("Upload Complete!");
          }
        });
      }
    }
    setState(() {
       // directoryPath.clear();
       //
       // fileName.clear();
       // fileSize.clear();
       // fileLength.clear();
       // uploadStart = false;
       // tap = false;
    });
  }

  void _pickFiles() async {
    //FileType.video
    //directoryPath.clear();

    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: widget.type == "VIDEO" ? FileType.video : FileType.audio,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
        // allowedExtensions: (_extension?.isNotEmpty ?? false)
        //     ? _extension?.replaceAll(' ', '').split(',')
        //     : null,
      ))
          ?.files;

      // String? fileName = _paths.path;

      if (directoryPath.isEmpty && _paths == null) {
        Navigator.pop(context);
      } else {
        var location = _paths!.map((e) => e.path);

        var name = _paths!.map((e) => e.name);
        var size = _paths!.map((e) => e.size);


         if(directoryPath.length <uploadStatus.length){
           setState(() {
             directoryPath.addAll(location);
             fileName.addAll(name);

             fileSize.addAll(size);
             //fileLength.addAll(length);
           });
         }else{
           showToastSuccess("Limit reached!");

         }


        print("directoryPath");
        print(fileSize);
      }
    } on PlatformException catch (e) {
      showToastSuccess(e.code.toString());
    } catch (e) {
      showToastSuccess(e.toString());
    }

    // if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: button(),
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
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                // _onMenuItemSelected(value as int);
                print("value");
                print(value);
                if (value == 0) {

                //  upgradeAlertBox();
                  _pickFiles();
                } else {
                  setState(() {
                    directoryPath.clear();
                    fileName.clear();
                    fileSize.clear();
                    uploadStatus.clear();
                  });
                }
              },
              itemBuilder: (ctx) => [
                _buildPopupMenuItem(' Add More', Icons.add, 0),
                _buildPopupMenuItem(' Clear All', Icons.clear, 1),
                // _buildPopupMenuItem('Copy', Icons.copy, 2),
                // _buildPopupMenuItem('Exit', Icons.exit_to_app, 3),
              ],
            ),
          ],
          title: const Text("Selected", style: size16_600W),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: Color(0xff404040), thickness: 1),
                ),
                shrinkWrap: true,
                itemCount: directoryPath != null ? directoryPath.length : 0,
                itemBuilder: (context, index) {
                  final item =
                      directoryPath != null ? directoryPath[index] : null;

                  return MusicList(item, index);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  MusicList(var item, int index) {
    return Row(
      children: [
        Container(
          height: 33,
          child: const Icon(Icons.image, color: Colors.blue),
          width: 33,
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
              Text(
                fileName[index].toString(),
                style: size14_500W,
                maxLines: 1,
              ),
              h(5),
              Text(getFileSize(fileSize[index], 1), style: size14_500Grey),
            ],
          ),
        ),
        w(10),
        // Icon(CupertinoIcons.clear_circled_solid, color: Colors.red)
        // Icon(CupertinoIcons.clear_circled_solid, color: Colors.red)
        // Icon(Icons.check_circle, color: Colors.green)
        //  uploadProgress()
         currentUploadIndex==index?currentProgress():uploadStatus[index] == "false" ? removeItem(index) : completeItem()
      ],
    );
  }
  //Text(currentUploadPer+"%", style: size14_600W)


  upgradeAlertBox() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff1E1E1E),
        context: context,
        isScrollControlled: true,
        builder: (context) =>Container(


          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: liteBlack),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,

              children: [
                const Text("Alert", style: size14_600W),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Color(0xff404040), thickness: 1),
                ),
                const Text(
                    "Your storage is almost full. Upgrade to add more media files.",
                    style: size14_500Grey),
                h(25),
                Row(
                  children: [
                    Expanded(
                      child: buttons("Later", const Color(0xff333333), () {

                        Navigator.pop(context);
                      }),
                    ),
                    w(10),
                    Expanded(
                      child: buttons("Clean", themeClr, () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const UpgradeScreen()),
                        // );


                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CleanFilesScreen()),
                        );
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
   confirmUpload( ) {




    // DatabaseReference reference =
    // FirebaseDatabase.instance.reference().child('channel');

    String dropdownvalue = 'All';
    var onSubmit = false;
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: liteBlack,
        context: context,
        // isScrollControlled: true,
        builder: (context) => Stack(children: [
          Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: liteBlack),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,

                children: [
                  Row(
                    children: const [
                      Text("Start uploading ?", style: size14_600W),
                      Spacer(),

                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xff404040), thickness: 1),
                  ),
                   Text(fileSize.length.toString()+" files ready to get uploaded", style: size14_500Grey),
                  h(25),
                  Row(
                    children: [
                      Expanded(
                        child: buttons("Upload", const Color(0xff333333), ()async {

                          {


                            setState(() {
                              tap = true;
                            });
                            Navigator.pop(context);
                            var getMem= await getStorage(fileSize);


                            print("memmm");
                            print(getMem);
                            if(getMem==null){
                              showToastSuccess("Something went wrong!");
                              setState(() {tap = false;});
                              return;
                            }

                            if(getMem[0]==true){
                              // var getMem= await getStorage();
                              // print("memmm");
                              // print(getMem);
                              _uploadFile(getMem[1]);
                              // setState(() {tap = false;});
                            }else{
                              upgradeAlertBox();
                              setState(() {tap = false;});
                            }


                            // var getMem= await getStorage();
                            // print("memmm");
                            // print(getMem);
                            // _uploadFile();
                          }
                        }),
                      ),
                      w(10),
                      Expanded(
                        child: buttons("Cancel", themeClr, () async{
                            Navigator.pop(context);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const UpgradeScreen()),
                          // );
                        }),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ]));




  }
  uploadProgress() {
     return Column(children: [
      Text("Pending", style: size10_600W),
      h(5),
       Container(
         width: 50,
         child: StepProgressIndicator(
          totalSteps: 100,
          currentStep: 2,
          size: 5,
          padding: 0,
          roundedEdges: Radius.circular(5),
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
      ),
       )
    ]);
  }
  currentProgress() {
    return Column(children: [
      Text(currentUploadPer+"%", style: size10_600W),
      h(5),
       Container(
         width: 50,
         child: StepProgressIndicator(
          totalSteps: 100,
          currentStep: int.parse(currentUploadPer.toString()),
          size: 5,
          padding: 0,
          roundedEdges: Radius.circular(5),
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
      ),
       )
    ]);
  }

  removeItem(index) {
    return (currentUploadIndex!=index&&uploadStart==true)?uploadProgress():GestureDetector(
      onTap: () {
        //  showToastSuccess(fileName[index].toString() +" removed !");
        setState(() {
          directoryPath.removeAt(index);
          fileName.removeAt(index);
          fileSize.removeAt(index);
          uploadStatus.removeAt(index);
        });
      },
      child: Container(
        height: 25,
        width: 25,
        child: const Icon(
          CupertinoIcons.delete,
          color: Colors.white,
          size: 17,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.redAccent),
      ),
    );
  }

  completeItem() {
    return GestureDetector(
      onTap: () {
        //  showToastSuccess(fileName[index].toString() +" removed !");
      },
      child: Container(
        height: 25,
        width: 25,
        child: const Icon(
          CupertinoIcons.check_mark_circled,
          color: Colors.white,
          size: 17,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.green),
      ),
    );
  }

  Widget button() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap:
        //  (directoryPath.isEmpty||tap == true)  ? null :
              ()async {


            //     setState(() {
            //       tap = true;
            //     });
            // var getMem= await getStorage(fileSize);
            //
            //
            // print("memmm");
            // print(getMem);
            //   if(getMem==null){
            //     showToastSuccess("Something went wrong!");
            //     setState(() {tap = false;});
            //     return;
            //   }
            //
            //   if(getMem[0]==true){
            //     // var getMem= await getStorage();
            //     // print("memmm");
            //     // print(getMem);
            //     _uploadFile(getMem[1]);
            //    // setState(() {tap = false;});
            //   }else{
            //     upgradeAlertBox();
            //     setState(() {tap = false;});
            //   }


                confirmUpload();

                  // var getMem= await getStorage();
                  // print("memmm");
                  // print(getMem);
                  // _uploadFile();
                },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            height: 46,
            width: 216,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: (directoryPath.isEmpty||tap == true) ? grey : themeClr),
            child: tap == true
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text("Upload",
                    style: size14_600W),
          ),
        ),
         SizedBox(height: 5,),
         BannerAds(),
      ],
    );
  }
}
