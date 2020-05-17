import 'package:flutter/material.dart';
import 'package:lets_work/internationalization/localization/localization_constants.dart';
import 'package:lets_work/shared/app_bar.dart';
import 'package:lets_work/shared/side_bar.dart';

import '../shared/constants.dart';

class EmployeePage extends StatefulWidget {
  final String _userInfo;

  const EmployeePage(this._userInfo);

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
        drawer: sideBar(
          context,
          widget._userInfo,
          getTranslated(context, 'employee'),
        ),
      ),
    );
  }
}
