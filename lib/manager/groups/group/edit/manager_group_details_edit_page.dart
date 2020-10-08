import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';

class ManagerGroupDetailsEditPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerGroupDetailsEditPage(this._model);

  @override
  _ManagerGroupDetailsEditPageState createState() =>
      _ManagerGroupDetailsEditPageState();
}

class _ManagerGroupDetailsEditPageState
    extends State<ManagerGroupDetailsEditPage> {
  final ManagerService _managerService = new ManagerService();
  GroupEmployeeModel _model;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(
            context,
            _model.user,
            'Edit group' +
                ' - ' +
                utf8.decode(_model.groupName != null
                    ? _model.groupName.runes.toList()
                    : '-')),
        drawer: managerSideBar(context, _model.user),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      ListTile(
                        title: text18WhiteBold(getTranslated(context, 'name')),
                        subtitle: text16White(
                          utf8.decode(
                            _model.groupName != null
                                ? _model.groupName.runes.toList()
                                : getTranslated(context, 'empty'),
                          ),
                        ),
                      ),
                      ListTile(
                        title: text18WhiteBold('Description'),
                        subtitle: text16White(utf8.decode(
                            _model.groupDescription != null
                                ? _model.groupDescription.runes.toList()
                                : getTranslated(context, 'empty'))),
                      ),
                      ListTile(
                          title: text18WhiteBold(
                              getTranslated(context, 'groupCountryOfWork')),
                          subtitle: text16White(
                              LanguageUtil.findFlagByNationality(
                                      _model.countryOfWork.toString()) +
                                  ' ' +
                                  LanguageUtil.convertShortNameToFullName(
                                      context, _model.countryOfWork))),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
                  child: textCenter14Green(
                      'Hint: Click the buttons below and edit the group details'),
                ),
                _buildButton(
                    getTranslated(context, 'name'), () => _updateGroupName()),
                _buildButton('Description', () => _updateGroupDescription()),
                _buildButton(
                    'Country of work', () => _updateGroupCountryOfWork()),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }

  Widget _buildButton(String text, Function() fun) {
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
            children: <Widget>[text20White(text)],
          ),
        ),
        textColor: Colors.white,
      ),
    );
  }

  _updateGroupName() {}

  _updateGroupDescription() {}

  _updateGroupCountryOfWork() {}
}
