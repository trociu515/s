import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../manager_app_bar.dart';
import 'manager_groups_page.dart';

class ManagerGroupsDetailsPage extends StatefulWidget {
  final User _user;
  final int _groupId;
  final String _groupName;
  final String _groupDescription;
  final String _numberOfEmployees;
  final String _countryOfWork;

  ManagerGroupsDetailsPage(
    this._user,
    this._groupId,
    this._groupName,
    this._groupDescription,
    this._numberOfEmployees,
    this._countryOfWork,
  );

  @override
  _ManagerGroupsDetailsPageState createState() =>
      _ManagerGroupsDetailsPageState();
}

class _ManagerGroupsDetailsPageState extends State<ManagerGroupsDetailsPage> {
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
