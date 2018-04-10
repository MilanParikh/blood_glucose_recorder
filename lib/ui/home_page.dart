import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:blood_glucose_recorder/model/data_entry.dart';
import 'package:blood_glucose_recorder/utils/authentication.dart' as authUtils;

String userID = authUtils.userID;
final firebaseReference =
FirebaseDatabase.instance.reference().child('users');

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _concentration;
  String _comment;
  static const List<String> timeList = const [
    "Breakfast",
    "Lunch",
    "Dinner",
    "Bedtime"
  ];
  String _time = timeList[0];

  final TextEditingController _concentrationController =
  new TextEditingController();
  final TextEditingController _commentsController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Blood Glucose Recorder'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: () {Navigator.of(context).pushNamed('/log_page');})
        ],
      ),
      body: new Column(
        children: <Widget>[
          const Divider(
            height: 6.0,
          ),
          new ListTile(
              leading: const Icon(Icons.fastfood),
              title: new DropdownButton<String>(
                value: _time,
                onChanged: (String value) {
                  setState(() {
                    _time = value;
                  });
                },
                items: timeList.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              )),
          new ListTile(
            leading: const Icon(Icons.map),
            title: new TextField(
              decoration:
              new InputDecoration(hintText: "Blood Glucose Concentration"),
              controller: _concentrationController,
              keyboardType: TextInputType.number,
              onChanged: (string) {
                _concentration = string;
              },
            ),
          ),
          new ListTile(
            leading: const Icon(Icons.comment),
            title: new TextField(
              decoration: new InputDecoration(hintText: "Comments"),
              controller: _commentsController,
              keyboardType: TextInputType.text,
              onChanged: (string) {
                _comment = string;
              },
            ),
          ),
          new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new RaisedButton(
                  onPressed: _submit, child: new Text("Submit"))),
        ],
      ),
    );
  }

  void _submit() {
    DataEntry entry =
    new DataEntry(new DateTime.now(), _time, _concentration, _comment);

    firebaseReference.child(userID).push().set(entry.toJson());

    showDialog(
        context: context,
        child: new AlertDialog(
          content: new Text("Entry Submitted"),
        ));
    _commentsController.text = "";
    _concentrationController.text = "";
  }

}
