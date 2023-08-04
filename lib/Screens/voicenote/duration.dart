/// document will be added
class VoiceDuration {
  /// document will be added
  static String getDuration(int duration) => duration < 60
      ? '00:' + ((duration.toString().length==1?"0"+duration.toString():duration).toString())
      : ((duration ~/ 60).toString().length==1?"0"+(duration ~/ 60).toString():(duration ~/ 60).toString()) + ':' +((duration % 60).toString().length==1?"0"+(duration % 60).toString():(duration % 60).toString()) ;
}


// ///workaayilele ith use akikoo
// class VoiceDuration {
//   /// document will be added
//   static String getDuration(int duration) => duration < 60
//       ? '00:' + (duration.toString())
//       : (duration ~/ 60).toString() + ':' + (duration % 60).toString();
// }
//


String intToTimeLeft(int value) {
  int h, m, s;

  h = value ~/ 3600;

  m = ((value - h * 3600)) ~/ 60;

  s = value - (h * 3600) - (m * 60);

  String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

  String minuteLeft =
  m.toString().length < 2 ? "0" + m.toString() : m.toString();

  String secondsLeft =
  s.toString().length < 2 ? "0" + s.toString() : s.toString();

  String result = "$hourLeft:$minuteLeft:$secondsLeft";

  return result;
}
