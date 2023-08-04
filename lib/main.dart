import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Noti.dart';
import 'package:weei/Helper/Provider.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/setupbgaudio.dart';
import 'package:weei/Helper/sharedPref.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';

import 'package:weei/Screens/splash.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:timezone/data/latest.dart' as tz;

import 'package:provider/provider.dart';
import 'package:background_fetch/background_fetch.dart';





 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}
void main() async {
 // await setupServiceLocator();
  //
//  await initJustAudioBackground(NotificationSettings(androidNotificationChannelId: 'com.example.example'));
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  await setupAudio();
  // _audioHandler = await AudioService.init(
  //   builder: () => AudioPlayerHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
  //     androidNotificationChannelName: 'Audio playback',
  //     androidNotificationOngoing: true,
  //   ),
  // );
  tz.initializeTimeZones();
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.camera.request();
  await Permission.microphone.request();
  if (Platform.isAndroid) {

    var awa = await getInitainlData('android');
  } else if (Platform.isIOS) {
    var awa = await getInitainlData('ios');

  }
  runApp(ChangeNotifierProvider<ProviderModel>(
    create: (_) => ProviderModel(),
    child: MyApp()
  ));
  // runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];
  @override
  void initState(){
    super.initState();
    initPlatformState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!

      print("result");
      print(result.name);

      if(result.name=="none"){
        showToastSuccess("No internet connection!");
      //  getConnection();
      // getConnection();
      }else{

      }

    });
    Noti.initialize(flutterLocalNotificationsPlugin);
    getToken();
    requestPermission();
    listenFCM();
  }
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {  // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    _onClickEnable(true);
    if (!mounted) return;
  }
  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
    });
    if (enabled) {

      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }
  void getToken() async {
    var fcm ;
    await FirebaseMessaging.instance.getToken().then((token) {
      print("fcmtooken");
      print(token);
      print("fcmtooken");
      fcm =token;

    });

    var set= await setSharedPrefrence(FCM, fcm);

  }
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    var settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  void loadFCM() async {
    if (!kIsWeb) {
     var channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }





  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {


        var inChatRoom = await getSharedPrefrence(CURRENTLYINCHAT);
        var inChatName = await getSharedPrefrence(CURRENTCHATNME);
        var noti = await getSharedPrefrence(NOTI);
        print("notificationn regg");
        print(inChatRoom);
        print(inChatName);

        if(noti=="false"){

          return;
        }

        if(inChatName!= notification.title.toString()){
          print("showw cheyyy");

          Noti.showBigTextNotification(title: notification.title.toString(), body: notification.body.toString(), fln: flutterLocalNotificationsPlugin);

        }
        // flutterLocalNotificationsPlugin.show(
        //   notification.hashCode,
        //   notification.title,
        //   notification.body,
        //
        //
        //   NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       channel.id,
        //       channel.name,
        //       // TODO add a proper drawable resource to android, for now using
        //       //      one that already exists in example app.
        //       icon: 'launch_background',
        //     ),
        //   ),
        // );
      }
    });
    print("notificationn regg");

  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderModel>(builder: (context, model, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weei',
      theme: ThemeData(
        canvasColor: Color(0xff1e1e1e),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xff1e1e1e)),
        fontFamily: 'mon',
        primarySwatch: Colors.blue,
      ),
      // home: VideoApp(),
      //  home: EventListenerPage(),
      //  home: FirebaseRealtimeDemoScreen(),
      // home: ControllerControlsPage(),
      //  home: BasicPlayerPage(),
      // home: InAppWebViewPage(),
      home: splashScreen(),
      // home: FilePickerDemo(),
      //home: YoutubePlayerDemoApp(),
    );
    });

  }
  void noConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1e1e1e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        content: StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: const [
                      Text('No connection', style: size14_600W),
                      Spacer(),
                      Icon(Icons.wifi, color: grey, size: 20)
                    ],
                  ),
                  const Divider(
                    color: const Color(0xff2F2E41),
                    thickness: 1,
                  ),
                  const Text(
                      "Please check your internet connection and try again.",
                      style: size14_500Grey),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
        actions:  [GestureDetector(

            onTap: (){
              Navigator.pop(context);
            },
            child: Text("Try again", style: size16_600G))],
        actionsPadding: const EdgeInsets.only(right: 20, bottom: 20),
      ),
    );
  }

}
