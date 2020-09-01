import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/manager/profile/manager_profile_page.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
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
      Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: IconButton(
          icon: iconWhite(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ManagerProfilePage(user)),
            );
          },
        ),
      ),
    ],
  );
}
