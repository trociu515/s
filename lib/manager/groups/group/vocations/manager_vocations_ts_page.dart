import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_timesheet_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/groups/group/vocations/timesheets/arrange/manager_vocations_arrange_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/manager/shimmer/shimmer_manager_timesheets.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/radio_element.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';

class ManagerVocationsTsPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerVocationsTsPage(this._model);

  @override
  _ManagerVocationsTsPageState createState() => _ManagerVocationsTsPageState();
}

class _ManagerVocationsTsPageState extends State<ManagerVocationsTsPage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;

  List<ManagerGroupTimesheetDto> _inProgressTimesheets = new List();
  List<ManagerGroupTimesheetDto> _completedTimesheets = new List();

  bool _loading = false;

  List<RadioElement> _elements = new List();
  int _currentRadioValue = 0;
  RadioElement _currentRadioElement;

  @override
  void initState() {
    this._model = widget._model;
    super.initState();
    _loading = true;
    _managerService
        .findTimesheetsByGroupId(
            _model.groupId.toString(), _model.user.authHeader)
        .then((res) {
      setState(() {
        int _counter = 0;
        res.forEach((ts) => {
              if (ts.status == STATUS_IN_PROGRESS)
                {
                  _inProgressTimesheets.add(ts),
                  _elements.add(RadioElement(
                      index: _counter++,
                      id: ts.id,
                      title: ts.year.toString() +
                          ' ' +
                          MonthUtil.translateMonth(context, ts.month))),
                  if (_currentRadioElement == null)
                    {
                      _currentRadioElement = _elements[0],
                    }
                }
              else
                {_completedTimesheets.add(ts)}
            });
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return shimmerManagerTimesheets(context, _model.user);
    }
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
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: textCenter20White('Manage employees vocations'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: textCenter14Green(
                        'Hint: Select a timesheet and click the button at the bottom to manage employees vocations'),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Image(
                          height: 45,
                          image: AssetImage('images/unchecked.png'),
                        ),
                      ),
                      text20OrangeBold(
                          getTranslated(context, 'inProgressTimesheets')),
                    ],
                  ),
                ),
              ),
              _inProgressTimesheets.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: text15White(
                            getTranslated(context, 'noInProgressTimesheets')),
                      ),
                    )
                  : Container(),
              Card(
                color: BRIGHTER_DARK,
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _elements
                        .map(
                          (e) => RadioListTile(
                            activeColor: GREEN,
                            groupValue: _currentRadioValue,
                            title: text18WhiteBold(e.title),
                            value: e.index,
                            onChanged: (newValue) {
                              setState(() {
                                _currentRadioValue = newValue;
                                _currentRadioElement = e;
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Image(
                          height: 45,
                          image: AssetImage('images/checked.png'),
                        ),
                      ),
                      text20GreenBold(
                          getTranslated(this.context, 'completedTimesheets')),
                    ],
                  ),
                ),
              ),
              _completedTimesheets.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: text15White(getTranslated(
                            this.context, 'noCompletedTimesheets')),
                      ),
                    )
                  : Container(),
              for (var completedTs in _completedTimesheets)
                Card(
                  color: BRIGHTER_DARK,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: text18WhiteBold(completedTs.year.toString() +
                              ' ' +
                              MonthUtil.translateMonth(
                                  context, completedTs.month)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 40,
          child: Row(
            children: <Widget>[
              SizedBox(width: 1),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: textDarkBold('Arrange'),
                  onPressed: () => {
                    if (_currentRadioElement != null)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagerVocationsArrangePage(
                                  _model,
                                  _inProgressTimesheets[
                                      _currentRadioElement.index])),
                        ),
                      }
                    else
                      {_handleEmptyTs()},
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: textDarkBold('Verify'),
                  onPressed: () => {
                    if (_currentRadioElement != null)
                      {}
                    else
                      {_handleEmptyTs()},
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: textDarkBold('Calendar'),
                  onPressed: () => {
                    if (_currentRadioElement != null)
                      {}
                    else
                      {_handleEmptyTs()},
                  },
                ),
              ),
              SizedBox(width: 1),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }

  _handleEmptyTs() {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold(getTranslated(context, 'hint')),
            SizedBox(height: 20),
            textCenter20White(
                'You need to select in progress timesheet to manage vocations'),
          ],
        ),
      ),
    );
  }
}
