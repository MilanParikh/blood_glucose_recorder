import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Blood Glucose Recorder'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: () {})
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

  void _submit(){
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          appBar: new AppBar(title: new Text("Log"),),
          body: new Text('Time: $_time, Concentration: $_concentration, Comments: $_comment'),
        );
      })
    );
  }
}
