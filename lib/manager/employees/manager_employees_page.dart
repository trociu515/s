import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_employee_group_dto.dart';
import 'package:give_job/manager/groups/manager_groups_details_time_sheets_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../manager_side_bar.dart';

class ManagerEmployeesPage extends StatefulWidget {
  final User _user;

  ManagerEmployeesPage(this._user);

  @override
  _ManagerEmployeesPageState createState() => _ManagerEmployeesPageState();
}

class _ManagerEmployeesPageState extends State<ManagerEmployeesPage> {
  final ManagerService _managerService = new ManagerService();

  List<ManagerEmployeeGroupDto> _employees = new List();
  List<ManagerEmployeeGroupDto> _filteredEmployees = new List();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _managerService
        .findGroupEmployeesByGroupManagerId(
            widget._user.id, widget._user.authHeader)
        .then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showToast(
          getTranslated(context, 'managerDoesNotHaveEmployeesInGroups'),
          Colors.red);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(
        context,
        getTranslated(context, 'loading'),
        managerSideBar(context, widget._user),
      );
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar:
            appBar(context, widget._user, getTranslated(context, 'employees')),
        drawer: managerSideBar(context, widget._user),
        body: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Filter'),
              onChanged: (string) {
                setState(() {
                  _filteredEmployees = _employees
                      .where((u) => (u.employeeInfo
                          .toLowerCase()
                          .contains(string.toLowerCase())))
                      .toList();
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: _filteredEmployees.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: DARK,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            color: DARK,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(this.context).push(
                                  CupertinoPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return ManagerGroupsDetailsTimeSheetsPage(
                                          widget._user,
                                          _employees[index].groupId,
                                          _employees[index].groupName,
                                          _employees[index].groupDescription,
                                          _employees[index].employeeId,
                                          _employees[index].employeeInfo);
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: text20WhiteBold(
                                        '#' + (index + 1).toString()),
                                    title: text20WhiteBold(utf8.decode(
                                        _filteredEmployees[index]
                                            .employeeInfo
                                            .runes
                                            .toList())),
                                    subtitle: Wrap(
                                      children: <Widget>[
                                        textWhite(getTranslated(
                                                this.context, 'moneyPerHour') +
                                            ': ' +
                                            _employees[index]
                                                .moneyPerHour
                                                .toString()),
                                        textWhite(getTranslated(this.context,
                                                'numberOfHoursWorked') +
                                            ': ' +
                                            _employees[index]
                                                .numberOfHoursWorked
                                                .toString()),
                                        textWhite(getTranslated(this.context,
                                                'amountOfEarnedMoney') +
                                            ': ' +
                                            _employees[index]
                                                .amountOfEarnedMoney
                                                .toString()),
                                        textWhite(
                                          getTranslated(
                                                  this.context, 'groupName') +
                                              ': ' +
                                              utf8.decode(_employees[index]
                                                          .groupName !=
                                                      null
                                                  ? _employees[index]
                                                      .groupName
                                                      .runes
                                                      .toList()
                                                  : getTranslated(
                                                      this.context, 'empty')),
                                        ),
                                      ],
                                    ),
                                    trailing: Wrap(
                                      children: <Widget>[
                                        iconWhite(Icons.edit),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
