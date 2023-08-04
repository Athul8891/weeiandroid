import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/loadInAppPlayer.dart';
import 'package:weei/Screens/Main_Screens/Chat/signleVideoForSession.dart';


var selectedSession=0;
var private =true;


singleMeediaBottomSheet(ctx,item,type) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xff4F4F4F),
      context: ctx,
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