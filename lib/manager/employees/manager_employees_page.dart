import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_employee_group_dto.dart';
import 'package:give_job/manager/groups/manager_groups_details_time_sheets_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/loader_widget.dart';

import '../manager_side_bar.dart';

class ManagerEmployeesPage extends StatefulWidget {
  final String _id;
  final String _userInfo;
  final String _authHeader;

  ManagerEmployeesPage(this._id, this._userInfo, this._authHeader);

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
        .findGroupEmployeesByGroupManagerId(widget._id, widget._authHeader)
        .then((res) {
      setState(() {
        _employees = res;
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loaderWidget(
        context,
        getTranslated(context, 'loading'),
        managerSideBar(
            context, widget._id, widget._userInfo, widget._authHeader),
      );
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: appBar(context, getTranslated(context, 'employees')),
        drawer: managerSideBar(
            context, widget._id, widget._userInfo, widget._authHeader),
        body: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0), hintText: 'Filter'),
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
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  this.context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerGroupsDetailsTimeSheetsPage(
                                            widget._id,
                                            widget._userInfo,
                                            widget._authHeader,
                                            _employees[index].groupId,
                                            _employees[index].groupName,
                                            _employees[index].groupDescription,
                                            _employees[index].employeeId,
                                            _employees[index].employeeInfo),
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Text(
                                      '#' + (index + 1).toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    title: Text(
                                      utf8.decode(_filteredEmployees[index]
                                          .employeeInfo
                                          .runes
                                          .toList()),
                                    ),
                                    subtitle: Wrap(
                                      children: <Widget>[
                                        Text(getTranslated(
                                                this.context, 'moneyPerHour') +
                                            ': ' +
                                            _employees[index]
                                                .moneyPerHour
                                                .toString()),
                                        Text(getTranslated(this.context,
                                                'numberOfHoursWorked') +
                                            ': ' +
                                            _employees[index]
                                                .numberOfHoursWorked
                                                .toString()),
                                        Text(getTranslated(this.context,
                                                'amountOfEarnedMoney') +
                                            ': ' +
                                            _employees[index]
                                                .amountOfEarnedMoney
                                                .toString()),
                                        Text(getTranslated(
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
                                                    this.context, 'empty'))),
                                      ],
                                    ),
                                    trailing: Wrap(
                                      children: <Widget>[
                                        Icon(
                                          Icons.edit,
                                        ),
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
