import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';

class AddMediaScreen extends StatefulWidget {
  const AddMediaScreen({Key? key}) : super(key: key);

  @override
  _AddMediaScreenState createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
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
        centerTitle: true,
        title: const Text("Add Media", style: size16_600W),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Add music or playlist", style: size14_500Grey),
            h(MediaQuery.of(context).size.height * 0.05),
            button()
          ],
        ),
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        newSessionBottomSheet();
      },
      child: Container(
        alignment: Alignment.center,
        height: 46,
        width: 216,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: themeClr),
        child: Text("Add Music", style: size16_600W),
      ),
    );
  }

  newSessionBottomSheet() {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xff1E1E1E),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: const [
                      Text('Add media to session', style: size14_600W),
                      Spacer(),
                      Icon(CupertinoIcons.xmark_circle_fill,
                          color: grey, size: 25)
                    ],
                  ),
                  const Divider(
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  h(10),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        child: const Icon(CupertinoIcons.music_note_2,
                            color: Colors.white),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: grey),
                      ),
                      w(15),
                      Container(
                        height: 50,
                        width: 50,
                        child: const Icon(CupertinoIcons.video_camera_solid,
                            color: Colors.white),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: grey),
                      ),
                    ],
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
}
