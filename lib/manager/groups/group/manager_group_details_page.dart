import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../manager_app_bar.dart';
import '../manager_groups_page.dart';
import 'employee/manager_employee_page.dart';

class ManagerGroupDetailsPage extends StatefulWidget {
  final User _user;
  final int _groupId;
  final String _groupName;
  final String _groupDescription;
  final String _numberOfEmployees;
  final String _countryOfWork;

  ManagerGroupDetailsPage(
    this._user,
    this._groupId,
    this._groupName,
    this._groupDescription,
    this._numberOfEmployees,
    this._countryOfWork,
  );

  @override
  _ManagerGroupDetailsPageState createState() =>
      _ManagerGroupDetailsPageState();
}

class _ManagerGroupDetailsPageState extends State<ManagerGroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: managerAppBar(
              context,
              widget._user,
              getTranslated(context, 'group') +
                  ' - ' +
                  utf8.decode(widget._groupName != null
                      ? widget._groupName.runes.toList()
                      : '-')),
          drawer: managerSideBar(context, widget._user),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Tab(
                      icon: Container(
                        child: Image(
                          image: AssetImage(
                            'images/group-img.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: text18WhiteBold(
                      utf8.decode(
                        widget._groupName != null
                            ? widget._groupName.runes.toList()
                            : getTranslated(context, 'empty'),
                      ),
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Align(
                            child: textWhite(utf8.decode(
                                widget._groupDescription != null
                                    ? widget._groupDescription.runes.toList()
                                    : getTranslated(context, 'empty'))),
                            alignment: Alignment.topLeft),
                        SizedBox(height: 5),
                        Align(
                            child: textWhite(
                                getTranslated(context, 'numberOfEmployees') +
                                    ': ' +
                                    widget._numberOfEmployees.toString()),
                            alignment: Alignment.topLeft),
                        Align(
                            child: textWhite(
                                getTranslated(context, 'groupCountryOfWork') +
                                    ': ' +
                                    LanguageUtil.findFlagByNationality(
                                        widget._countryOfWork.toString())),
                            alignment: Alignment.topLeft),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ManagerEmployeePage(widget._user,
                                        widget._groupId, widget._groupName);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                icon50Green(Icons.person_outline),
                                text20WhiteBold('Employee'),
                                textWhite('Fill hours, rating etc.'),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: <Widget>[
                                icon50Green(Icons.people_outline),
                                text20WhiteBold('All employees'),
                                textWhite('Fill hours, rating etc.'),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: <Widget>[
                                icon50Green(Icons.event_note),
                                text20WhiteBold('Plan'),
                                textWhite('Plan day for one employee'),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: <Widget>[
                                icon50Green(Icons.equalizer),
                                text20WhiteBold('Plan for all'),
                                textWhite('Plan day for employees'),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: <Widget>[
                                icon50Green(Icons.chat),
                                text20WhiteBold('Chat'),
                                textWhite('Chat with your group'),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Material(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: <Widget>[
                                icon50Green(Icons.error_outline),
                                text20WhiteBold('Message'),
                                textWhite('Send message to all group'),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerGroupsPage(widget._user),
      ),
    );
    return false;
  }
}
