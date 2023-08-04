import 'package:easy_audio_player/helpers/init_just_audio_background.dart';
import 'package:easy_audio_player/helpers/init_just_audio_background.dart';
import 'package:easy_audio_player/models/models.dart';
import 'package:easy_audio_player/widgets/players/basic_audio_player.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
setupAudio() async{
await initJustAudioBackground(NotificationSettings(androidNotificationChannelId: 'com.example.example')).whenComplete(() => print("audio noti setuped"));
}