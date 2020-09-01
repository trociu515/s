import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/groups/manager_groups_page.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/settings/settings_page.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../manager_app_bar.dart';

class ManagerProfilePage extends StatefulWidget {
  final User _user;

  ManagerProfilePage(this._user);

  @override
  _ManagerProfilePageState createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  User _user;

  @override
  Widget build(BuildContext context) {
    _user = widget._user;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(context, _user, 'Profile'),
        drawer: managerSideBar(context, _user),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('images/logo.png'), fit: BoxFit.fill),
                  ),
                ),
                Column(
                  children: <Widget>[
                    text25White(utf8.decode(
                        _user.info != null ? _user.info.runes.toList() : '-')),
                    SizedBox(height: 2.5),
                    text20White(LanguageUtil.convertShortNameToFullName(
                            _user.nationality) +
                        ' ' +
                        LanguageUtil.findFlagByNationality(_user.nationality)),
                    SizedBox(height: 2.5),
                    text18White(
                        getTranslated(context, 'manager') + ' #' + _user.id),
                    SizedBox(height: 10),
                    _buildButton(
                      'See my groups',
                      Icons.group,
                      () => {
                        Navigator.of(context).push(
                          CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                              return ManagerGroupsPage(_user);
                            },
                          ),
                        ),
                      },
                    ),
                    _buildButton('About me', Icons.info, () => print('object')),
                    _buildButton(
                      'Settings',
                      Icons.settings,
                      () => {
                        Navigator.of(context).push(
                          CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                              return SettingsPage(_user);
                            },
                          ),
                        ),
                      },
                    ),
                    _buildButton('Logout', Icons.exit_to_app,
                        () => Logout.logout(context)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Function() fun) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: MaterialButton(
        elevation: 0,
        height: 50,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () => fun(),
        color: GREEN,
        child: Container(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text20White(text),
              iconWhite(icon),
            ],
          ),
        ),
        textColor: Colors.white,
      ),
    );
  }
}
