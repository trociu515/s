import 'package:flutter/material.dart';
import 'package:lets_work/login_page.dart';
import 'package:lets_work/main.dart';
import 'package:lets_work/toastr_service.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Lets work')),
        body: Center(
          //child: Text('Its works!')
          child: ListView(
            children: <Widget>[
              Text('Its works!'),
              RaisedButton(
                child: Text('Wyloguj'),
                onPressed: () async {
                  storage.delete(key: 'authorization');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                  ToastService.showToast('Wylogowano pomyślnie', Colors.green);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
