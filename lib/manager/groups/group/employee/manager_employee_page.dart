import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_details_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';
import 'manager_employee_time_sheets_page.dart';

class ManagerEmployeePage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerEmployeePage(this._model);

  @override
  _ManagerEmployeePageState createState() => _ManagerEmployeePageState();
}

class _ManagerEmployeePageState extends State<ManagerEmployeePage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;

  List<ManagerGroupDetailsDto> _employees = new List();
  List<ManagerGroupDetailsDto> _filteredEmployees = new List();
  bool _loading = false;

  @override
  void initState() {
    this._model = widget._model;
    super.initState();
    _loading = true;
    _managerService
        .findEmployeesGroupDetails(
            _model.groupId.toString(), _model.user.authHeader)
        .then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showBottomToast(
          getTranslated(context, 'managerDoesNotHaveEmployeesInGroups'),
          Colors.red);
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
            Container(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
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
            Expanded(
              child: ListView.builder(
                itemCount: _filteredEmployees.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: DARK,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          color: BRIGHTER_DARK,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(this.context).push(
                                CupertinoPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ManagerEmployeeTimeSheetsPage(
                                        _model,
                                        _employees[index].employeeNationality,
                                        _employees[index].currency,
                                        _employees[index].employeeId,
                                        _employees[index].employeeInfo);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Tab(
                                    icon: Container(
                                      child: Image(
                                        image: AssetImage(
                                          'images/group-img.png', // TODO replace img
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: text20WhiteBold(utf8.decode(
                                          _filteredEmployees[index]
                                              .employeeInfo
                                              .runes
                                              .toList()) +
                                      ' ' +
                                      LanguageUtil.findFlagByNationality(
                                          _filteredEmployees[index]
                                              .employeeNationality)),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Align(
                                          child: Row(
                                            children: <Widget>[
                                              textWhite(getTranslated(
                                                      this.context,
                                                      'moneyPerHour') +
                                                  ': '),
                                              textGreenBold(_employees[index]
                                                      .moneyPerHour
                                                      .toString() +
                                                  ' ' +
                                                  _employees[index].currency),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft),
                                      Align(
                                          child: Row(
                                            children: <Widget>[
                                              textWhite(getTranslated(
                                                      this.context,
                                                      'numberOfHoursWorked') +
                                                  ': '),
                                              textGreenBold(_employees[index]
                                                  .numberOfHoursWorked
                                                  .toString()),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft),
                                      Align(
                                          child: Row(
                                            children: <Widget>[
                                              textWhite(getTranslated(
                                                      this.context,
                                                      'amountOfEarnedMoney') +
                                                  ': '),
                                              textGreenBold(_employees[index]
                                                      .amountOfEarnedMoney
                                                      .toString() +
                                                  ' ' +
                                                  _employees[index].currency),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
