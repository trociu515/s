import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_details_dto.dart';
import 'package:give_job/manager/groups/manager_groups_details_time_sheets_page.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/toastr_service.dart';

class ManagerGroupsDetailsPage extends StatefulWidget {
  final String _managerId;
  final String _managerInfo;
  final String _authHeader;

  final int _groupId;
  final String _groupName;
  final String _groupDescription;

  ManagerGroupsDetailsPage(
    this._managerId,
    this._managerInfo,
    this._authHeader,
    this._groupId,
    this._groupName,
    this._groupDescription,
  );

  @override
  _ManagerGroupsDetailsPageState createState() =>
      _ManagerGroupsDetailsPageState();
}

class _ManagerGroupsDetailsPageState extends State<ManagerGroupsDetailsPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ManagerGroupDetailsDto>>(
      future: _managerService
          .findEmployeesGroupDetails(
              widget._groupId.toString(), widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'managerDoesNotHaveGroups'), Colors.red);
        Navigator.pop(context);
      }),
      builder: (BuildContext context,
          AsyncSnapshot<List<ManagerGroupDetailsDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<ManagerGroupDetailsDto> employees = snapshot.data;
          if (employees.isEmpty) {
            ToastService.showToast(
                getTranslated(context, 'managerDoesNotHaveGroups'), Colors.red);
            Navigator.pop(context);
          }
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(
                  context, getTranslated(context, 'employeesOfTheGroup')),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(widget._groupName != null
                            ? utf8.decode(widget._groupName.runes.toList())
                            : getTranslated(context, 'empty')),
                        subtitle: Wrap(
                          children: <Widget>[
                            Text(widget._groupDescription != null
                                ? utf8.decode(
                                    widget._groupDescription.runes.toList())
                                : getTranslated(context, 'empty')),
                          ],
                        ),
                      ),
                      for (int i = 0; i < employees.length; i++)
                        Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManagerGroupsDetailsTimeSheetsPage(
                                          widget._managerId,
                                          widget._managerInfo,
                                          widget._authHeader,
                                          widget._groupId,
                                          widget._groupName,
                                          widget._groupDescription,
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
            ),
          );
        }
      },
    );
  }
}