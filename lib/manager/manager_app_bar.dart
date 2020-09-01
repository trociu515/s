import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/manager/informations/manager_information_page.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/settings/settings_page.dart';
import 'package:give_job/shared/widget/icons.dart';

AppBar managerAppBar(BuildContext context, User user, String title) {
  return AppBar(
    iconTheme: IconThemeData(color: WHITE),
    backgroundColor: BRIGHTER_DARK,
    elevation: 0.0,
    bottomOpacity: 0.0,
    title: Text(
      title,
      style: TextStyle(fontSize: 15, color: WHITE),
    ),
    actions: <Widget>[
      IconButton(
        icon: iconWhite(Icons.person),
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
          icon: iconWhite(Icons.settings),
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
