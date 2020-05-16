import 'package:flutter/material.dart';
import 'package:lets_work/shared/constants.dart';
import 'package:lets_work/login_page.dart';
import 'package:lets_work/main.dart';
import 'package:lets_work/shared/toastr_service.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(APP_NAME)),
        body: Center(
          //child: Text('Its works!')
          child: ListView(
            children: <Widget>[
              Text('Menadżer'),
              RaisedButton(
                child: Text('Wyloguj'),
                onPressed: () async {
                  storage.delete(key: 'authorization');
                  storage.delete(key: 'role');
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
