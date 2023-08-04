import 'package:intl/intl.dart';


getTime(){
  var tm = DateFormat.yMMMd().format(DateTime.now()).toString() +" at " + (DateTime.now().hour>12?(DateTime.now().hour-12):DateTime.now().hour).toString()+":"+DateTime.now().minute.toString() + (DateTime.now().hour>=12?" PM":" AM");
  return tm;
}