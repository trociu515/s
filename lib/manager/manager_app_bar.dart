import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/manager/informations/manager_information_page.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/settings/settings_page.dart';

AppBar managerAppBar(BuildContext context, User user, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: DARK),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(Icons.person),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ManagerInformationPage(user)),
          );
        },
      ),
      Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage(user)),
            );
          },
        ),
      ),
    ],
  );
}
