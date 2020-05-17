import 'package:flutter/material.dart';
import 'package:lets_work/shared/app_bar.dart';
import 'package:lets_work/shared/constants.dart';

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
        appBar: appBar(context),
        body: Center(
          child: ListView(
            children: <Widget>[
              Text('Menadżer'),
            ],
          ),
        ),
      ),
    );
  }
}
