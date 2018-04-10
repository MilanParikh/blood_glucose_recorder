import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:blood_glucose_recorder/utils/authentication.dart' as authUtils;

String userID = authUtils.userID;
final firebaseReference =
FirebaseDatabase.instance.reference().child('users');

class LogPage extends StatefulWidget {
  LogPage({Key key}) : super(key: key);

  @override
  _LogPageState createState() => new _LogPageState();
}

class _LogPageState extends State<LogPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Log"),
        ),
        body: new Column(
          children: <Widget>[
            new Flexible(
                child: new FirebaseAnimatedList(
                    query: firebaseReference.child(userID).orderByChild("id"),
                    reverse: false,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return new ListTile(
                        leading: new Text(_notNull(
                            snapshot.value["concentration"],
                            "concentration")),
                        title: new Text(snapshot.value["time"]),
                        subtitle: new Text(
                            _notNull(snapshot.value["comment"], "comment")),
                        trailing: new Text(_convertDate(
                            DateTime.parse(snapshot.value["date"]))),
                        onLongPress: () {
                          firebaseReference.child(userID)
                              .child(snapshot.key.toString())
                              .remove();
                        },
                      );
                    }))
          ],
        ));
  }

  String _notNull(String rawString, String type) {
    String value;
    if (type == "concentration") {
      if (rawString == null) {
        value = "N/A";
      } else {
        value = rawString;
      }
    } else if (type == "comment") {
      if (rawString == null) {
        value = "No comment";
      } else {
        value = rawString;
      }
    }
    return value;
  }

  String _convertDate(DateTime date) {
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    return "$month/$day/$year";
  }

}