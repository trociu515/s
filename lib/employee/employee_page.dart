import 'package:flutter/material.dart';
import 'package:lets_work/internationalization/localization/localization_constants.dart';
import 'package:lets_work/shared/app_bar.dart';

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
        appBar: appBar(context),
        body: Center(
          //child: Text('Its works!')
          child: ListView(
            children: <Widget>[Text(getTranslated(context, 'home_page'))],
          ),
        ),
      ),
    );
  }
}
