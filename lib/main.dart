import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return new MaterialApp(
  title: 'Blood Glucose Recorder',
  theme: new ThemeData(
  primarySwatch: Colors.blue,
  ),
  home: new HomePage(),
  );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _concentration;
  String _comment;
  static const List<String> timeList = const ["Breakfast", "Lunch", "Dinner", "Bedtime"];
  String _time = timeList[0];
  final firebaseReference = FirebaseDatabase.instance.reference();

  final TextEditingController _concentrationController = new TextEditingController();
  final TextEditingController _commentsController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Blood Glucose Recorder'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _toLogPage)
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
            )
          ),
          new ListTile(
            leading: const Icon(Icons.map),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: "Blood Glucose Concentration"
              ),
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
              decoration: new InputDecoration(
                hintText: "Comments"
              ),
              controller: _commentsController,
              keyboardType: TextInputType.text,
              onChanged: (string) {
                _comment = string;
              },
            ),
          ),
          new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new RaisedButton(onPressed: _submit, child: new Text("Submit"))
          ),
        ],
      ),
    );
  }

  void _toLogPage(){
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          appBar: new AppBar(title: new Text("Log"),),
          body: new Column(
            children: <Widget>[
              new Flexible(
                  child: new FirebaseAnimatedList(
                  query: firebaseReference.orderByChild("id"),
                  reverse: false,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    return new ListTile(
                      leading: new Text(_notNull(snapshot.value["concentration"], "concentration")),
                      title: new Text(snapshot.value["time"]),
                      subtitle: new Text(_notNull(snapshot.value["comment"], "comment")),
                      trailing: new Text(_convertDate(DateTime.parse(snapshot.value["date"]))),
                      onLongPress: () {
                        FirebaseDatabase.instance.reference().child(snapshot.key.toString()).remove();
                      },
                    );
                  }
              ))
            ],
          )
        );
      })
    );
  }

  void _submit() {
    DataEntry entry = new DataEntry(new DateTime.now(), _time, _concentration, _comment);
    firebaseReference.push().set(entry.toJson());
    showDialog(context: context, child: new AlertDialog(
      content: new Text("Entry Submitted"),
    ));
    _commentsController.text = "";
    _concentrationController.text = "";

  }

  String _notNull(String rawString, String type) {
    String value;
    if(type=="concentration") {
      if(rawString==null){
        value = "N/A";
      }else {
        value = rawString;
      }
    }else if (type=="comment"){
      if(rawString==null){
        value = "No comment";
      }else{
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

class DataEntry {
  DateTime date;
  String time;
  String concentration;
  String comment;

  DataEntry(this.date, this.time, this.concentration, this.comment);

  toJson() {
    DateTime dateTime = new DateTime.now();
    return {
      "date": date.toString(),
      "time": time,
      "concentration": concentration,
      "comment": comment,
      "id": dateTime.millisecondsSinceEpoch*-1,
    };

  }
}
