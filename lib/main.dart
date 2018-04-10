import 'package:flutter/material.dart';

import 'ui/home_page.dart';
import 'ui/log_page.dart';
import 'ui/login_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Blood Glucose Recorder',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginPage(),
      routes: <String, WidgetBuilder> {
        '/home_page': (BuildContext context) => new HomePage(),
        '/log_page': (BuildContext context) => new LogPage(),
      }
    );
  }
}
