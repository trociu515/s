import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/colors.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/logout.dart';

class ManagerPage extends StatefulWidget {
  final String _id;
  final String _userInfo;
  final String _authHeader;

  const ManagerPage(this._id, this._userInfo, this._authHeader);

  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(context, getTranslated(context, 'home')),
          drawer: managerSideBar(
              context, widget._id, widget._userInfo, widget._authHeader),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
