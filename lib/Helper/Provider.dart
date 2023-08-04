
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weei/Helper/sharedPref.dart';

// void main() {
//   runApp(
//       ChangeNotifierProvider<MyHomePageModel>(
//         create: (_) => MyHomePageModel(),
//         child: MyApp(),
//       )
//   );
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<MyHomePageModel>(builder: (context, model, child) {
//       int _counter = model.getCounter();
//
//       return Scaffold(
//           appBar: AppBar(
//             title: Text('FlutteR Demo Home Page'),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   'You have pushed the button this many times:',
//                 ),
//                 Text(
//                   '$_counter',
//                   style: Theme.of(context).textTheme.headline4,
//                 ),
//               ],
//             ),
//           ),
//           floatingActionButton: Button());
//     });
//   }
// }
//
// class Button extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<MyHomePageModel>(context, listen: false);
//     return FloatingActionButton(
//       onPressed: () => model.addCounter(),
//       tooltip: 'Increment',
//       child: Icon(Icons.add),
//     );
//   }
// }

class ProviderModel extends ChangeNotifier {
  var _lang = 'en';


  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(loginBtTp, _lang);
  }



  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString(loginBtTp) ?? 'false';
    notifyListeners();
  }








  void setLang(lang) {


    _lang = lang;

    _setPrefItems();
    notifyListeners();
  }

   getLang() {
    _getPrefItems();
    return _lang;
  }


}