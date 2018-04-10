import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blood_glucose_recorder/utils/authentication.dart' as authUtil;

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    super.initState();

    authUtil.auth.onAuthStateChanged
      .firstWhere((user) => user != null)
      .then((user) {
        Navigator.of(context).pushNamed('/home_page');
    });
    
    new Future.delayed(new Duration(seconds: 1)).then((_) => authUtil.authentication.signInWithGoogle());

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Login"),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new SizedBox(width: 20.0),
                new Text("Signing in with Google..."),
              ],
            ),
          ],
        )
    );
  }
}