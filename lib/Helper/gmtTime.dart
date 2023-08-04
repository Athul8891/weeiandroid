import 'package:timezone/standalone.dart' as tz;

gmtCurrentTime()async{
  var detroit = tz.getLocation('Indian/Reunion');
  var now = tz.TZDateTime.now(detroit);

  print("indiannn");
  print(now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString()+"  -  "+now.hour.toString() +":"+now.minute.toString());
  print(now.millisecondsSinceEpoch);
  return now.millisecondsSinceEpoch.toString();
}

gmtDiffrenceTime(adminTime,adminGmt)async{

  //
  // var startTime = DateTime(2020, 02, 20, 10, 30); // TODO: change this to your DateTime from firebase
  // var currentTime = DateTime.now();
  // var diff = currentTime.difference(startTime).inMilliseconds;
  var detroit = tz.getLocation('Indian/Reunion');
 // var startTime = DateTime(other);
  var now = tz.TZDateTime.now(detroit).millisecondsSinceEpoch;


  var diff = now-adminGmt;
  print("daaaaaaaaate1");
  print(diff);
  print((adminTime+diff));


  print("daaaaaaaaate1");

    //now.difference(startTime);
  // print("indiannn");
  // print(now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString()+"  -  "+now.hour.toString() +":"+now.minute.toString());
  // print(now.millisecondsSinceEpoch);
   return   (adminTime+diff);
}