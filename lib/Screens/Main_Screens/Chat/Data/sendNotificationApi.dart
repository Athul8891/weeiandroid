import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weei/Helper/Toast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
import 'package:weei/Screens/Upload/Data/tst.dart';


 sendPushMessage(String body, String title,  token) async {



  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'key=AAAAbNFoxZE:APA91bGzFh3P1zLg46h8ZiJo46TRW4t_Y7iR9n-WL1grdl9emWnkxVyX4dGn3IgvE-jLdXpaFgVT5knNH48JZiVANOfRvI6fGZI8azMUARRlkHFtDgXIjyWCFRwE1AWtvgjPI0gatoLa',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
         "to": token,
          //"to": "eQhhcKnLSdWeS3APDbFLWQ:APA91bGM0j6eEgiPNLQQPS0eeShJKNVfFWo3kxx5TBuLMY5txAdx699J7707fcXcaG_ywhRTTdTpHzKXoGEZzhZV7usgFVMxGi4uFGlRrZgAb-X9GOS0MS3ZPyWA-4N6t1xMYoGUfGVw",
        },
      ),
    );
    print('sucess push notification');
  } catch (e) {
    print("error push notification");
  }
}