import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/settings/settings_page.dart';

AppBar appBar(BuildContext context, User user, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: DARK),
    ),
    actions: <Widget>[
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Container(
            width: 100,
            child: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: DARK,
                ),
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage(user)),
                  ),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 75,
                    child: Icon(Icons.settings),
                  ),
                ),
              ),
            ),
          )),
    ],
  );
}
