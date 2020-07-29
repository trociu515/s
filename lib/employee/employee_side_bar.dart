import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_job/employee/employee_page.dart';
import 'package:give_job/employee/group/employee_group.dart';
import 'package:give_job/employee/information/employee_information_page.dart';
import 'package:give_job/employee/timesheet/employee_time_sheets_page.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/colors.dart';
import 'package:give_job/shared/dialog/bug_report_dialog.dart';
import 'package:give_job/shared/logout.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeePage(employeeId, userInfo, authHeader),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              getTranslated(context, 'information'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeInformationPage(employeeId, userInfo, authHeader),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.group,
              color: Colors.white,
            ),
            title: Text(
              getTranslated(context, 'group'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeGroup(employeeId, userInfo, authHeader),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeTimeSheetsPage(employeeId, userInfo, authHeader),
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
