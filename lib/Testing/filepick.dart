import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';

import '../Helper/getBase64.dart';
import 'package:weei/Testing/utils.dart';
class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();


  final databaseReference = FirebaseDatabase.instance.reference();





  @override
  void initState() {
    super.initState();

   // this. createData();
    _controller.addListener(() => _extension = _controller.text);
  }
  void createData(){
    databaseReference.child("base64").set({
      'base64': '000',

    });
    // databaseReference.child("flutterDevsTeam2").set({
    //   'name': 'Yashwant Kumar',
    //   'description': 'Senior Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam3").set({
    //   'name': 'Akshay',
    //   'description': 'Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam4").set({
    //   'name': 'Aditya',
    //   'description': 'Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam5").set({
    //   'name': 'Shaiq',
    //   'description': 'Associate Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam6").set({
    //   'name': 'Mohit',
    //   'description': 'Associate Software Engineer'
    // });
    // databaseReference.child("flutterDevsTeam7").set({
    //   'name': 'Naveen',
    //   'description': 'Associate Software Engineer'
    // });

  }
  void updateData(base64){
    print("updaate");
    print(base64);
    databaseReference.child('base64').update({
     //'base64': "0".toString(),
     'base64': base64.toString(),
     //'time': base64.toString(),
   });

  }
  void _pickFiles() async {
    _resetState();


    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }


   // if (!mounted) return;




    setState(() {

      _isLoading = false;
      _fileName =
      _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });


  }



  void pick()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String? fileName = result.files.first.path;

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
     // updateData(rsp.toString());

      addToPatients(rsp);
      return;//convert Path to File
      Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
      String base64string = base64.encode(imagebytes);

      //convert bytes to base64 string
      print("base64string");
      print(base64string);
      updateData(base64string.toString());
      print("base64string");

   //   final bytes = Io.File(imagefile.path).readAsBytesSync();

     // String img64 = base64Encode(bytes);

    }
  }
  void _clearCachedFiles() async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();
      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();
    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );
      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: DropdownButton<FileType>(
                        hint: const Text('LOAD PATH FROM'),
                        value: _pickingType,
                        items: FileType.values
                            .map((fileType) => DropdownMenuItem<FileType>(
                          child: Text(fileType.toString()),
                          value: fileType,
                        ))
                            .toList(),
                        onChanged: (value) => setState(() {
                          _pickingType = value!;
                          if (_pickingType != FileType.custom) {
                            _controller.text = _extension = '';
                          }
                        })),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 100.0),
                    child: _pickingType == FileType.custom
                        ? TextFormField(
                      maxLength: 15,
                      autovalidateMode: AutovalidateMode.always,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'File extension',
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                    )
                        : const SizedBox(),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(width: 200.0),
                    child: SwitchListTile.adaptive(
                      title: Text(
                        'Pick multiple files',
                        textAlign: TextAlign.right,
                      ),
                      onChanged: (bool value) =>
                          setState(() => _multiPick = value),
                      value: _multiPick,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => _pickFiles(),
                          child: Text(_multiPick ? 'Pick files' : 'Pick file'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _selectFolder(),
                          child: const Text('Pick folder'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _saveFile(),
                          child: const Text('Save file'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _clearCachedFiles(),
                          child: const Text('Clear temporary files'),
                        ),

                        ElevatedButton(
                         onPressed: () =>  pick(),
                        //  onPressed: () =>  updateData("base64"),
                          child: const Text('pick up'),
                        ),
                      ],
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => _isLoading
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const CircularProgressIndicator(),
                    )
                        : _userAborted
                        ? Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: const Text(
                        'User has aborted the dialog',
                      ),
                    )
                        : _directoryPath != null
                        ? ListTile(
                      title: const Text('Directory path'),
                      subtitle: Text(_directoryPath!),
                    )
                        : _paths != null
                        ? Container(
                      padding:
                      const EdgeInsets.only(bottom: 30.0),
                      height:
                      MediaQuery.of(context).size.height *
                          0.50,
                      child: Scrollbar(
                          child: ListView.separated(
                            itemCount: _paths != null &&
                                _paths!.isNotEmpty
                                ? _paths!.length
                                : 1,
                            itemBuilder: (BuildContext context,
                                int index) {
                              final bool isMultiPath =
                                  _paths != null &&
                                      _paths!.isNotEmpty;
                              final String name =
                                  'File $index: ' +
                                      (isMultiPath
                                          ? _paths!
                                          .map((e) => e.name)
                                          .toList()[index]
                                          : _fileName ?? '...');
                              final path = kIsWeb
                                  ? null
                                  : _paths!
                                  .map((e) => e.path)
                                  .toList()[index]
                                  .toString();

                              return ListTile(
                                title: Text(
                                  name,
                                ),
                                subtitle: Text(path ?? ''),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context,
                                int index) =>
                            const Divider(),
                          )),
                    )
                        : _saveAsFileName != null
                        ? ListTile(
                      title: const Text('Save file'),
                      subtitle: Text(_saveAsFileName!),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}