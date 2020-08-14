import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/dialog/bug_report_dialog.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:open_appstore/open_appstore.dart';

import 'home/employee_home_page.dart';

Drawer employeeSideBar(BuildContext context, String employeeId, String userInfo,
    String authHeader) {
  return Drawer(
    child: Container(
      color: DARK,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [WHITE, GREEN])),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 30,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('images/logo.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                  text22DarkBold(utf8.decode(
                      userInfo != null ? userInfo.runes.toList() : '-')),
                  textDarkBold(
                      getTranslated(context, 'employee') + ' #' + employeeId),
                ],
              ),
            ),
          ),
          ListTile(
            leading: iconWhite(Icons.home),
            title: text18White(getTranslated(context, 'home')),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute<Null>(
                  builder: (BuildContext context) {
                    return EmployeeHomePage(employeeId, userInfo, authHeader);
                  },
                ),
              );
            },
          ),
          Divider(color: WHITE),
          ListTile(
              leading: iconWhite(Icons.star),
              title: text18White(getTranslated(context, 'rate')),
              onTap: () => OpenAppstore.launch(
                  androidAppId: ANDROID_APP_ID, iOSAppId: IOS_APP_ID)),
          ListTile(
              leading: iconWhite(Icons.bug_report),
              title: text18White(getTranslated(context, 'bugReport')),
              onTap: () => bugReportDialog(context)),
          ListTile(
              leading: iconWhite(Icons.exit_to_app),
              title: text18White(getTranslated(context, 'signOut')),
              onTap: () => Logout.logout(context)),
        ],
      ),
    ),
  );
}
