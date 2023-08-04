import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/AdManger.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/MyMusicList.dart';
import 'package:weei/Screens/MyVideosList.dart';
import 'package:weei/Screens/Playlist/addPlayListMedia.dart';
import 'package:weei/Screens/Playlist/audioPlayList.dart';
import 'package:weei/Screens/Playlist/videoPlayList.dart';
import 'package:weei/Screens/UpgradeScreen.dart';
import 'package:weei/Screens/Upload/confirmUpload.dart';
import 'package:weei/Screens/VideoSession/videoPlayerScreen.dart';

import '../../Upload/uploadsScreen.dart';

class Library_Home extends StatefulWidget {
  const Library_Home({Key? key}) : super(key: key);

  @override
  _Library_HomeState createState() => _Library_HomeState();
}

class _Library_HomeState extends State<Library_Home> {
  final yourScrollController = ScrollController();
  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  String dropdownvalue = 'All';

  var allList;
  var videoList;
  var audioList;

  var items = ['All', 'Video', 'Audio'];
  var filterKey = "ALL";

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:   BannerAds(androidID: LYBRARYADANDROID,iosId:LYBRARYIOSID ,),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text("Library",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            child: GestureDetector(
              onTap: () {
                uploadBottomSheet();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const AddMediaScreen()),
                // );

                //NavigatePage(context,FilePickerDemo());
              },
              child: Container(
                width: 40,
                // height: 30,
                decoration: BoxDecoration(
                    color: themeClr, borderRadius: BorderRadius.circular(5)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Wrap(
            runSpacing: 15,
            children: [
              // updateAlertBox(),
              // upgradeAlertBox(),
              // recentContainer(),
             // BannerAds(androidID: LYBRARYADANDROID,iosId:LYBRARYIOSID ,),
              yourFiles(),
              playList()
            ],
          ),
        ),
      ),
    );
  }

  recentList(int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VideoPlayerScreen()));
          },
          child: Container(
            height: 86,
            width: 145,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    image: NetworkImage(tstImg), fit: BoxFit.cover)),
          ),
        ),
        h(10),
        SizedBox(
          width: 145,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(
                child: Text("The Enduring Mystery of Jack the Ripper",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: size12_500W),
              ),
              Icon(Icons.more_vert, color: Colors.white, size: 20)
            ],
          ),
        )
      ],
    );
  }

  Widget recentContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: liteBlack),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Row(
              children: const [
                Text("Recent", style: size14_600W),
                Spacer(),
                Text("View All", style: size14_500W),
              ],
            ),
          ),
          div(),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, top: 10, right: 2, bottom: 30),
            child: SizedBox(
              height: 130,
              child: Scrollbar(
                controller: yourScrollController,
                // isAlwaysShown: true,
                // trackVisibility: true,
                child: ListView.separated(
                  controller: yourScrollController,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => w(10),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // final item = arrOrderDetail != null
                    //     ? arrOrderDetail[index]
                    //     : null;

                    return recentList(index);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget yourFiles() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: liteBlack),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your files", style: size16_600W),
            const Divider(color: Color(0xff404040), thickness: 1),
            filesItem(Icons.upload_sharp, "Uploads", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadsScreen()));
            }),
            filesItem(Icons.play_arrow, "Videos", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyVideosList()));
            }),
            filesItem(CupertinoIcons.music_note_2, "Music", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyMusicList()));
            }),
          ],
        ),
      ),
    );
  }

  Widget playList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: liteBlack),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                children: [
                  const Text("Playlists", style: size14_600W),
                  const Spacer(),
                  DropdownButton(
                      value: dropdownvalue,
                      elevation: 1,
                      dropdownColor: liteBlack,
                      style: size14_500Grey,
                      underline: Container(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(items, style: size14_500Grey));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          if (dropdownvalue == "Video" ||
                              dropdownvalue == "Audio") {
                            filterKey = "playlistType";
                            dropdownvalue = newValue!;
                          } else {
                            print("all");
                            filterKey = "ALL";
                            dropdownvalue = newValue!;
                          }
                        });
                      }),
                ],
              ),
            ),
            div(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: GestureDetector(
                  onTap: () {
                    playlistBottomSheet();
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AddNewVideoScreen()));
                  },
                  child: const Text("+ New Playlist", style: size14_600G)),
            ),
            h(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child:
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15),
                  //   child: GridView.builder(
                  //     physics: const BouncingScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: 5,
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //         crossAxisCount: 2,
                  //         crossAxisSpacing: 15,
                  //         mainAxisSpacing: 10,
                  //         childAspectRatio: 0.65),
                  //     itemBuilder: (BuildContext context, int index) {
                  //       // final item = arrOrderDetail != null
                  //       //     ? arrOrderDetail[index]
                  //       //     : null;
                  //       return VideosGrid(index);
                  //     },
                  //   ),
                  // ),

                  dropdownvalue == "All"
                      ? PaginateFirestore(
                          // Use SliverAppBar in header to make it sticky
                          // header: SliverToBoxAdapter(child: Text('HEADER')),
                          // footer: SliverToBoxAdapter(child: Text('FOOTER')),
                          // item builder type is compulsory.
                          // separator: Padding(
                          //   padding: EdgeInsets.symmetric(vertical: 8),
                          //   child: Divider(color: Color(0xff404040), thickness: 1),
                          // ),
                          key: ValueKey(dropdownvalue),
                    physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
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
                            final data =
                                documentSnapshots[index].data() as Map?;
                            return data != null
                                ? playlistItems(
                                    documentSnapshots[index].id, data, index)
                                : const Center(
                                    child: Text("No Entries Found!",
                                        style: size14_600W),
                                  );
                          },
                          // orderBy is compulsory to enable pagination
                          query: FirebaseFirestore.instance
                              .collection('Playlist')
                              .where('userId',
                                  isEqualTo: auth.currentUser!.uid.toString())
                              .where("ALL", isEqualTo: "ALL")
                              .orderBy("uploadAt", descending: true),
                          // to fetch real-time data
                          listeners: [
                            refreshChangeListener,
                          ],

                          isLive: true,
                        )
                      : dropdownvalue == "Video"
                          ? PaginateFirestore(
                              // Use SliverAppBar in header to make it sticky
                              // header: SliverToBoxAdapter(child: Text('HEADER')),
                              // footer: SliverToBoxAdapter(child: Text('FOOTER')),
                              // item builder type is compulsory.
                              // separator: Padding(
                              //   padding: EdgeInsets.symmetric(vertical: 8),
                              //   child: Divider(color: Color(0xff404040), thickness: 1),
                              // ),
                              key: ValueKey(dropdownvalue),
                    physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilderType: PaginateBuilderType.listView,
                               onEmpty: emptyList(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.65),
                              // Change types accordingly
                              itemBuilder:
                                  (context, documentSnapshots, index) {
                                final data =
                                    documentSnapshots[index].data() as Map?;
                                return data != null
                                    ? playlistItems(
                                        documentSnapshots[index].id,
                                        data,
                                        index)
                                    : const Center(
                                        child: Text("No Entries Found!",
                                            style: size14_600W),
                                      );
                              },
                              // orderBy is compulsory to enable pagination
                              query: FirebaseFirestore.instance
                                  .collection('Playlist')
                                  .where('userId',
                                      isEqualTo:
                                          auth.currentUser!.uid.toString())
                                  .where("playlistType", isEqualTo: "VIDEO")
                                  .orderBy("uploadAt", descending: true),
                              // to fetch real-time data
                              listeners: [
                                refreshChangeListener,
                              ],

                              isLive: true,
                            )
                          : dropdownvalue == "Audio"
                              ? PaginateFirestore(
                                  // Use SliverAppBar in header to make it sticky
                                  // header: SliverToBoxAdapter(child: Text('HEADER')),
                                  // footer: SliverToBoxAdapter(child: Text('FOOTER')),
                                  // item builder type is compulsory.
                                  // separator: Padding(
                                  //   padding: EdgeInsets.symmetric(vertical: 8),
                                  //   child: Divider(color: Color(0xff404040), thickness: 1),
                                  // ),
                                  //key: ValueKey(dropdownvalue),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilderType:
                                      PaginateBuilderType.listView,
                                     onEmpty: emptyList(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 0.65),
                                  // Change types accordingly
                                  itemBuilder:
                                      (context, documentSnapshots, index) {
                                    final data = documentSnapshots[index]
                                        .data() as Map?;
                                    return data != null
                                        ? playlistItems(
                                            documentSnapshots[index].id,
                                            data,
                                            index)
                                        : const Center(
                                            child: Text("No Entries Found!",
                                                style: size14_600W),
                                          );
                                  },
                                  // orderBy is compulsory to enable pagination
                                  query: FirebaseFirestore.instance
                                      .collection('Playlist')
                                      .where('userId',
                                          isEqualTo: auth.currentUser!.uid
                                              .toString())
                                      .where("playlistType",
                                          isEqualTo: "AUDIO")
                                      .orderBy("uploadAt", descending: true),
                                  // to fetch real-time data
                                  listeners: [
                                    refreshChangeListener,
                                  ],

                                  isLive: true,
                                )
                              : Container(),
            ),
            h(20),
          ],
        ),
      ),
    );
  }
  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text("No playlists found, Try adding some.", style: size13_600W),
        SizedBox(height: 15,),
        GestureDetector(
          onTap: (){
            playlistBottomSheet();

          },
          child: Container(

            alignment: Alignment.center,

            height: 30,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: themeClr),
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Add", style: size14_600White),
            ),
          ),
        )





      ],),);

  }
  div() {
    return const Divider(
        color: Color(0xff404040), thickness: 1, indent: 20, endIndent: 20);
  }

  filesItem(IconData icon, String txt, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child:


      Padding(
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
            Text(txt, style: size14_500W),

          ],
        ),
      ),
    );
  }

  playlistItems(var doc, var items, int index) {
    print("item");
    print(items);
    return  GestureDetector(
      onTap: () {
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => audioPlayerScreen()));
        if (items['playlistType'] == "VIDEO") {
          NavigatePage(
              context,
              MyVideoPlayList(
                path: items['playlistPath'],
                count: items['playlistSize'].toString(),
                name: items['playlistName'].toString(),
                doc: doc,
              ));
        } else {
          NavigatePage(
              context,
              MyAudioPlayList(
                path: items['playlistPath'],
                count: items['playlistSize'].toString(),
                name: items['playlistName'].toString(),
                doc: doc,
              ));
        }
      },
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 5),
          child: Row(
            children: [
              Container(
                height: 49,
                child: const Icon(Icons.video_collection, color: Color(0xff808080)),
                width: 49,
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
                      ///.split(':').first.toString()
                      Text(items['playlistName'].toString(), style: size14_500W),
                      Text(
                          items['playlistSize'].toString() +
                              " " +
                              items['playlistType'].toString().toLowerCase(),
                          style: size14_500Grey),
                    ],
                  ))
            ],
          ),
        ),
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        contentPadding: EdgeInsets.zero,
      ),
    )

     ;
  }

  upgradeAlertBox() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: liteBlack),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: buttons("Later", const Color(0xff333333), () {}),
                ),
                w(10),
                Expanded(
                  child: buttons("Upgrade", themeClr, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpgradeScreen()),
                    );
                  }),
                ),
              ],
            )
          ],
        ),
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

  uploadBottomSheet() {
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Text('Add media', style: size14_600W),
                        Spacer(),
                        Icon(CupertinoIcons.xmark_circle_fill,
                            color: grey, size: 25)
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  h(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          NavigatePage(
                              context,
                              ConfirmUploadsScreen(
                                type: "AUDIO",
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const Icon(CupertinoIcons.music_note_2,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: grey),
                        ),
                      ),
                      w(15),
                      GestureDetector(
                        onTap: () {
                          NavigatePage(
                              context, ConfirmUploadsScreen(type: "VIDEO"));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const Icon(CupertinoIcons.video_camera_solid,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: grey),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 10),
                  ),
                  BannerAds(),
                ],
              ),
            ));
  }

  playlistBottomSheet() {
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: const [
                        Text('Playlist type', style: size14_600W),
                        Spacer(),
                        Icon(CupertinoIcons.xmark_circle_fill,
                            color: grey, size: 25)
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  h(10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          NavigatePage(
                              context,
                              const addMediaToPlaylist(
                                type: "AUDIO",
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const Icon(CupertinoIcons.music_note_2,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: grey),
                        ),
                      ),
                      w(15),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          NavigatePage(
                              context, const addMediaToPlaylist(type: "VIDEO"));
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: const Icon(CupertinoIcons.video_camera_solid,
                              color: Colors.white),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: grey),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 10),
                  ),
                BannerAds(),
                ],
              ),
            ));
  }
}
