import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/streamMessageBar.dart';
import 'package:weei/Screens/Admob/BannerAdsVidStr.dart';
import 'package:weei/Screens/Main_Screens/Chat/sessionChatList.dart';
var context;
chatBottomSheet1(context) {
  showModalBottomSheet(
      context: context,

      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(

            builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
              return Stack(children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        height: 60,
                        decoration: const BoxDecoration(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,right: 10),
                          child: Row(
                            children: [

                              Spacer(),
                              IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.fullscreen_exit,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        ),
                      ),
                      BannerAdsVidStr(),
                      //  const Divider(color: Color(0xff404040), thickness: 1),
                      sessionChatList(),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MessageBar(),
                      )
                    ],
                  ),
                ),
              ]);
            });
      });


}