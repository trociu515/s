import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/settings/bug_report_dialog.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

import 'employees/manager_employees_page.dart';
import 'groups/manager_groups_page.dart';

Drawer managerSideBar(BuildContext context, User user) {
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
                      user.info != null ? user.info.runes.toList() : '-')),
                  textDarkBold(
                      getTranslated(context, 'manager') + ' #' + user.id),
                ],
              ),
            ),
          ),
          ListTile(
            leading: iconWhite(Icons.group),
            title: text18White(getTranslated(context, 'groups')),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute<Null>(
                  builder: (BuildContext context) {
                    return ManagerGroupsPage(user);
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: iconWhite(Icons.people_outline),
            title: text18White(getTranslated(context, 'employees')),
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute<Null>(
                  builder: (BuildContext context) {
                    return ManagerEmployeesPage(user);
                  },
                ),
              );
            },
          ),
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
