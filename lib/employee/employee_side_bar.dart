import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/homepage/employee_home_page.dart';
import 'package:give_job/employee/timesheet/employee_time_sheets_page.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/dialog/bug_report_dialog.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/logout_service.dart';

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
            color: Theme.of(context).primaryColor,
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
                  Text(
                    utf8.decode(
                        userInfo != null ? userInfo.runes.toList() : '-'),
                    style: TextStyle(
                        fontSize: 22, color: DARK, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getTranslated(context, 'employee') + ' #' + employeeId,
                    style: TextStyle(color: DARK, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.white,
            ),
            title: Text(
              getTranslated(context, 'home'),
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
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
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.white,
            ),
            title: Text(
              getTranslated(context, 'workTimeSheets'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute<Null>(
                  builder: (BuildContext context) {
                    return EmployeeTimeSheetsPage(
                        employeeId, userInfo, authHeader);
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bug_report,
              color: Colors.white,
            ),
            title: Text(
              getTranslated(context, 'bugReport'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              bugReportDialog(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            title: Text(
              getTranslated(context, 'signOut'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Logout.logout(context);
            },
          ),
        ],
      ),
    ),
  );
}
