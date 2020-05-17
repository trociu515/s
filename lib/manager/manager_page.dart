import 'package:flutter/material.dart';
import 'package:lets_work/internationalization/localization/localization_constants.dart';
import 'package:lets_work/shared/app_bar.dart';
import 'package:lets_work/shared/constants.dart';
import 'package:lets_work/shared/side_bar.dart';

class ManagerPage extends StatefulWidget {
  final String _userInfo;

  const ManagerPage(this._userInfo);

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
        drawer: sideBar(
          context,
          widget._userInfo,
          getTranslated(context, 'manager'),
        ),
      ),
    );
  }
}
