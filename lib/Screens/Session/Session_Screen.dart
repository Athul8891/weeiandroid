import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
class SessionScreen extends StatefulWidget {
  final path;
  SessionScreen({this.path});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {

  late Query _ref;
  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child('channel').child(widget.path.toString()+"/joins");

    print(widget.path);

  }
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: const Icon(
      //         Icons.arrow_back_ios,
      //         color: Colors.white,
      //         size: 18,
      //       )),
      //   centerTitle: true,
      //   title: const Text("Session", style: size16_600W),
      // ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 5),
          child: GestureDetector(
            onTap: () {
              leaveSessionAlert();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: red),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Leave Session", style: size14_600W),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Session Creator", style: size16_600G),
            div(),
            Row(
              children: [
                const Icon(CupertinoIcons.person_alt_circle_fill,
                    size: 55, color: grey),
                w(15),
                const Text("Name", style: size14_500W)
              ],
            ),
            h(ss.height * 0.05),
            const Text("Participants", style: size14_600W),
            div(),
            Expanded(
              child: Scrollbar(
                // child: ListView.separated(
                //   scrollDirection: Axis.vertical,
                //   separatorBuilder: (context, index) => h(10),
                //   shrinkWrap: true,
                //   itemCount: 50,
                //   itemBuilder: (context, index) {
                //     // final item = arrOrderDetail != null
                //     //     ? arrOrderDetail[index]
                //     //     : null;
                //
                //     return participantsList(index);
                //   },
                // ),
                child: FirebaseAnimatedList(

                  query: _ref,

                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                   // Object? contact = snapshot.value;
                   // contact['key'] = snapshot.key;
                    return participantsList( snapshot.value,index);
                  },
                ),
              ),
              ),

          ],
        ),
      ),
    );
  }

  participantsList(var item,int index) {
    return Row(
      children: [
        const Icon(CupertinoIcons.person_alt_circle_fill,
            size: 55, color: grey),
        w(15),
         Text(item['name'], style: size14_500W),
        Spacer(),
        Text("Remove", style: size14_600Red)
      ],
    );
  }

  div() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: Color(0xff404040), thickness: 1),
    );
  }

  void leaveSessionAlert() {
    var ss = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: liteBlack,
        alignment: Alignment.bottomCenter,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 10,
        // title: const Text("Alert", style: size14_600W),
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text("Leave Session", style: size14_600W),
                      Spacer(),
                      Icon(
                        CupertinoIcons.clear_thick_circled,
                        color: grey,
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: Color(0xff404040), thickness: 1),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            "Are you sure you want to leave this session?",
                            style: size14_500Grey),
                      ),
                    ],
                  ),
                  h(ss.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child: buttons("No", red, () {})),
                      w(15),
                      Expanded(child: buttons("Yes", themeClr, () {})),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
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
}
