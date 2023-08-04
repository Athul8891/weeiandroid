import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:weei/Testing/constants.dart';

class EventListenerPage extends StatefulWidget {
  @override
  _EventListenerPageState createState() => _EventListenerPageState();
}

class _EventListenerPageState extends State<EventListenerPage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  late BetterPlayerController _betterPlayerController;
  List<BetterPlayerEvent> events = [];
  StreamController<DateTime> _eventStreamController =
      StreamController.broadcast();

  @override
  void initState() {
   // this.createData();
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
            controlsConfiguration:BetterPlayerControlsConfiguration(enableOverflowMenu: false,forwardSkipTimeInMilliseconds: 00000)

    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, Constants.bugBuckBunnyVideoUrl);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.addEventsListener(_handleEvent);

    super.initState();
  }
  void createData(){
    databaseReference.child("channel").set({
      'time': '000',

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
  void updateData(time){
    print("timee");
    print(time);
    databaseReference.child('channel').update({
      'time': time.toString(),
    });

  }

  void readData(){
    databaseReference.child('channel/time').once().then(( snapshot) async {
      print('Data : ${snapshot.snapshot.value.toString()}');
      var sec = int.parse(snapshot.snapshot.value.toString());
      print("seccccccc");
      print(sec);
   _betterPlayerController.seekTo(Duration(milliseconds: (int.parse(sec.toString())+3000)));
    });
  }
  @override
  void dispose() {
    _eventStreamController.close();
    _betterPlayerController.removeEventsListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent(BetterPlayerEvent event) {
  //updateData(_betterPlayerController.videoPlayerController?.value.position.inMilliseconds);
    print("eventttttttt");
    event.betterPlayerEventType == BetterPlayerEventType.progress &&
        event.parameters != null &&
        event.parameters!['progress'] != null &&
        event.parameters!['duration'] != null;
    events.insert(0, event);
    print(event.betterPlayerEventType.name);
    print( _betterPlayerController.videoPlayerController?.value.position);

    ///Used to refresh only list of events
    _eventStreamController.add(DateTime.now());


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: (){
              readData();
            },
            child: Text("Live")),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Better Player exposes events which can be listened with event "
              "listener. Start player to see events flowing.",
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder(
              stream: _eventStreamController.stream,
              builder: (context, snapshot) {
                return ListView(
                  children: events
                      .map(
                        (event) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Event: ${event.betterPlayerEventType} "
                                "parameters: ${(event.parameters ?? <String, dynamic>{}).toString()}"),
                            Divider(),
                          ],
                        ),
                      )
                      .toList(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
