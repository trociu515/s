import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_employees_time_sheet_dto.dart';
import 'package:give_job/manager/dto/manager_group_time_sheet_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';

class ManagerTimeSheetsEmployeesInProgressPage extends StatefulWidget {
  final GroupEmployeeModel _model;
  final ManagerGroupTimeSheetDto _timeSheet;

  ManagerTimeSheetsEmployeesInProgressPage(this._model, this._timeSheet);

  @override
  _ManagerTimeSheetsEmployeesInProgressPageState createState() =>
      _ManagerTimeSheetsEmployeesInProgressPageState();
}

class _ManagerTimeSheetsEmployeesInProgressPageState
    extends State<ManagerTimeSheetsEmployeesInProgressPage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;
  ManagerGroupTimeSheetDto _timeSheet;

  List<ManagerGroupEmployeesTimeSheetDto> _employees = new List();
  List<ManagerGroupEmployeesTimeSheetDto> _filteredEmployees = new List();
  bool _loading = false;

  @override
  void initState() {
    this._model = widget._model;
    this._timeSheet = widget._timeSheet;
    super.initState();
    _loading = true;
    _managerService
        .findAllEmployeesOfTimeSheetByGroupIdAndTimeSheetYearMonthStatusForMobile(
            _model.groupId,
            _timeSheet.year,
            MonthUtil.findMonthNumberByMonthName(context, _timeSheet.month),
            _timeSheet.status,
            _model.user.authHeader)
        .then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showBottomToast('Something went wrong', Colors.red);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(
        managerAppBar(context, null, getTranslated(context, 'loading')),
        managerSideBar(context, _model.user),
      );
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
            getTranslated(context, 'employees') +
                ' - ' +
                utf8.decode(_model.groupName != null
                    ? _model.groupName.runes.toList()
                    : '-')),
        drawer: managerSideBar(context, _model.user),
        body: Column(
          children: <Widget>[
            Card(
              color: BRIGHTER_DARK,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.radio_button_unchecked,
                          color: Colors.orange),
                      title: textWhiteBold(_timeSheet.year.toString() +
                          ' ' +
                          MonthUtil.translateMonth(context, _timeSheet.month)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                autofocus: false,
                autocorrect: true,
                cursorColor: WHITE,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: WHITE, width: 2)),
                    counterStyle: TextStyle(color: WHITE),
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    prefixIcon: iconWhite(Icons.search),
                    labelStyle: TextStyle(color: WHITE)),
                onChanged: (string) {
                  setState(
                    () {
                      _filteredEmployees = _employees
                          .where((u) => (u.employeeInfo
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                          .toList();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }
}
