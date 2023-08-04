import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weei/Helper/sharedPref.dart';

void main() {
  runApp(
      ChangeNotifierProvider<MyHomePageModel>(
        create: (_) => MyHomePageModel(),
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MyHomePageModel>(builder: (context, model, child) {
      int _counter = model.getCounter();

      return Scaffold(
          appBar: AppBar(
            title: Text('FlutteR Demo Home Page'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: Button());
    });
  }
}

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MyHomePageModel>(context, listen: false);
    return FloatingActionButton(
      onPressed: () => model.addCounter(),
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}

class MyHomePageModel extends ChangeNotifier {
  int _counter = 0;


  void _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(COUNTER, _counter);
  }



  void addCounter() {
    _counter = 1;
    _setPrefItems();
    notifyListeners();
  }

  void minusCounter() {
    _counter = 0;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }

  void _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt(COUNTER) ?? 0;
    notifyListeners();
  }
}