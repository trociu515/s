import 'package:flutter/material.dart';
import 'package:lets_work/shared/logout.dart';

import '../shared/constants.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Logout.showAlert(context);
                  },
                  child: Icon(Icons.exit_to_app),
                )),
          ],
        ),
        body: Center(
          //child: Text('Its works!')
          child: ListView(
            children: <Widget>[
              Text('Pracownik'),
            ],
          ),
        ),
      ),
    );
  }
}
