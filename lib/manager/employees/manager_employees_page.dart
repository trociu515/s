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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ManagerEmployeeGroupDto>>(
      future: _managerService.findGroupEmployeesByGroupManagerId(
          widget._id, widget._authHeader),
      builder: (BuildContext context,
          AsyncSnapshot<List<ManagerEmployeeGroupDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loaderWidget(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(
                context, widget._id, widget._userInfo, widget._authHeader),
          );
        } else {
          List<ManagerEmployeeGroupDto> employees = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(context, getTranslated(context, 'employees')),
              drawer: managerSideBar(
                  context, widget._id, widget._userInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < employees.length; i++)
                      Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ManagerGroupsDetailsTimeSheetsPage(
                                        widget._id,
                                        widget._userInfo,
                                        widget._authHeader,
                                        employees[i].groupId,
                                        employees[i].groupName,
                                        employees[i].groupDescription,
                                        employees[i].employeeId,
                                        employees[i].employeeInfo),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                leading: Text(
                                  '#' + (i + 1).toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text(utf8.decode(
                                    employees[i].employeeInfo != null
                                        ? employees[i]
                                            .employeeInfo
                                            .runes
                                            .toList()
                                        : getTranslated(context, 'empty'))),
                                subtitle: Wrap(
                                  children: <Widget>[
                                    Text(getTranslated(
                                            context, 'moneyPerHour') +
                                        ': ' +
                                        employees[i].moneyPerHour.toString()),
                                    Text(getTranslated(
                                            context, 'numberOfHoursWorked') +
                                        ': ' +
                                        employees[i]
                                            .numberOfHoursWorked
                                            .toString()),
                                    Text(getTranslated(
                                            context, 'amountOfEarnedMoney') +
                                        ': ' +
                                        employees[i]
                                            .amountOfEarnedMoney
                                            .toString()),
                                    Text(getTranslated(context, 'groupName') +
                                        ': ' +
                                        utf8.decode(employees[i].groupName !=
                                                null
                                            ? employees[i]
                                                .groupName
                                                .runes
                                                .toList()
                                            : getTranslated(context, 'empty'))),
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
            ),
          );
        }
      },
    );
  }
}
