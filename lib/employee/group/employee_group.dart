import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_group_dto.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/colors.dart';
import 'package:give_job/shared/loader_widget.dart';
import 'package:give_job/shared/toastr_service.dart';

import '../../shared/constants.dart';
import '../service/employee_service.dart';

class EmployeeGroup extends StatefulWidget {
  final String _employeeId;
  final String _employeeInfo;
  final String _authHeader;

  const EmployeeGroup(this._employeeId, this._employeeInfo, this._authHeader);

  @override
  _EmployeeGroupState createState() => _EmployeeGroupState();
}

class _EmployeeGroupState extends State<EmployeeGroup> {
  final EmployeeService _employeeService = new EmployeeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeGroupDto>(
      future: _employeeService
          .findGroupById(widget._employeeId, widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'employeeDoesNotHaveGroup'), Colors.red);
        Navigator.pop(context);
      }),
      builder:
          (BuildContext context, AsyncSnapshot<EmployeeGroupDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loaderWidget(
            context,
            getTranslated(context, 'loading'),
            employeeSideBar(context, widget._employeeId, widget._employeeInfo,
                widget._authHeader),
          );
        } else {
          EmployeeGroupDto employee = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme:
                ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
            home: Scaffold(
              backgroundColor: DARK,
              appBar: appBar(context, getTranslated(context, 'group')),
              drawer: employeeSideBar(context, widget._employeeId,
                  widget._employeeInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: DARK,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                getTranslated(context, 'groupId'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.groupId != null
                                    ? employee.groupId.toString()
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'groupName'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(
                                  employee.groupName != null
                                      ? employee.groupName.runes.toList()
                                      : getTranslated(context, 'empty'),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'groupDescription'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(
                                  employee.groupDescription != null
                                      ? employee.groupDescription.runes.toList()
                                      : getTranslated(context, 'empty'),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'groupManager'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(
                                  employee.groupManager != null
                                      ? employee.groupManager.runes.toList()
                                      : getTranslated(context, 'empty'),
                                ),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
