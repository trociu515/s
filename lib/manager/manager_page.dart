import 'package:flutter/material.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/logout.dart';

class ManagerPage extends StatefulWidget {
  final String _userInfo;

  const ManagerPage(this._userInfo);

  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: appBar(context),
          drawer: managerSideBar(
            context,
            widget._userInfo,
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
