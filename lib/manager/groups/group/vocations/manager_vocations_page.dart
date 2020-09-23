import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';

class ManagerVocationsPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerVocationsPage(this._model);

  @override
  _ManagerVocationsPageState createState() => _ManagerVocationsPageState();
}

class _ManagerVocationsPageState extends State<ManagerVocationsPage> {
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
            getTranslated(context, 'vocations') +
                ' - ' +
                utf8.decode(_model.groupName != null
                    ? _model.groupName.runes.toList()
                    : '-')),
        drawer: managerSideBar(context, _model.user),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                _buildButtonWithoutHint(
                    'Arrange vocation for the employee', () => print('object')),
                _buildButtonWithHint(
                    'Verify vocation',
                    '2 vocation request are waiting for verify',
                    () => print('object')),
                _buildButtonWithHint('Vocations calendar',
                    '3 employees are on vocation today', () => print('object')),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }

  Widget _buildButtonWithoutHint(String text, Function() fun) {
    return Column(
      children: [
        SizedBox(height: 20),
        MaterialButton(
          elevation: 0,
          minWidth: double.maxFinite,
          height: 50,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () => fun(),
          color: GREEN,
          child: text20White(text),
        ),
      ],
    );
  }

  Widget _buildButtonWithHint(String text, String hint, Function() fun) {
    return Column(
      children: [
        SizedBox(height: 20),
        MaterialButton(
          elevation: 0,
          minWidth: double.maxFinite,
          height: 75,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () => fun(),
          color: GREEN,
          child: Column(
            children: [
              text20White(text),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconRed(Icons.error_outline),
                  SizedBox(width: 5),
                  textCenter18Red(hint),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
