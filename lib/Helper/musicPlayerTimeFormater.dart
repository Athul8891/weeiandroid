

import 'package:weei/Screens/voicenote/duration.dart';

formatTime(milli){

  print("milli");
  print(milli);
  var sec = ((milli/1000)%60).toStringAsFixed(0);
  print("seccc");
  print(sec);
  //
  // VoiceDuration
  // sec = '${(Duration(seconds: int.parse(sec.toString())))}'.split('.')[0].padLeft(8, '0');


    return VoiceDuration.getDuration(int.parse(sec));
}