import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/service/employee_time_sheet_service.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/toastr_service.dart';

import '../shared/constants.dart';
import 'dto/employee_time_sheet_dto.dart';

class EmployeeTimeSheetsPage extends StatefulWidget {
  final String _employeeId;
  final String _employeeInfo;
  final String _authHeader;

  const EmployeeTimeSheetsPage(
      this._employeeId, this._employeeInfo, this._authHeader);

  @override
  _EmployeeTimeSheetsPageState createState() => _EmployeeTimeSheetsPageState();
}

class _EmployeeTimeSheetsPageState extends State<EmployeeTimeSheetsPage> {
  final EmployeeTimeSheetService _employeeService =
      new EmployeeTimeSheetService();

  String translateMonth(String toTranslate) {
    switch (toTranslate) {
      case JANUARY:
        return getTranslated(context, 'january');
      case FEBRUARY:
        return getTranslated(context, 'february');
      case MARCH:
        return getTranslated(context, 'march');
      case APRIL:
        return getTranslated(context, 'april');
      case MAY:
        return getTranslated(context, 'may');
      case JUNE:
        return getTranslated(context, 'june');
      case JULY:
        return getTranslated(context, 'july');
      case AUGUST:
        return getTranslated(context, 'august');
      case SEPTEMBER:
        return getTranslated(context, 'september');
      case OCTOBER:
        return getTranslated(context, 'october');
      case NOVEMBER:
        return getTranslated(context, 'november');
      case DECEMBER:
        return getTranslated(context, 'december');
    }
    throw 'Wrong month to translate!';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EmployeeTimeSheetDto>>(
      future: _employeeService
          .findEmployeeTimeSheetsById(widget._employeeId, widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'employeeDoesNotHaveGroup'), Colors.red);
        Navigator.pop(context);
      }),
      builder: (BuildContext context,
          AsyncSnapshot<List<EmployeeTimeSheetDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<EmployeeTimeSheetDto> timeSheets = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              appBar: appBar(context),
              drawer: employeeSideBar(context, widget._employeeId,
                  widget._employeeInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      for (var timeSheet in timeSheets)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(
                                  timeSheet.status == 'Accepted'
                                      ? Icons.check_circle_outline
                                      : Icons.radio_button_unchecked,
                                  color: timeSheet.status == 'Accepted'
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                                title: Text(timeSheet.year.toString() +
                                    ' ' +
                                    translateMonth(timeSheet.month) +
                                    '\n' +
                                    utf8.decode(
                                        timeSheet.groupName.runes.toList())),
                                subtitle: Wrap(
                                  children: <Widget>[
                                    Text(getTranslated(context, 'hoursWorked') +
                                        ': ' +
                                        timeSheet.totalHours.toString() +
                                        'h'),
                                    Text(getTranslated(
                                            context, 'averageRating') +
                                        ': ' +
                                        timeSheet.averageEmployeeRating
                                            .toString()),
                                  ],
                                ),
                                trailing: Wrap(
                                  children: <Widget>[
                                    Text(
                                      timeSheet.totalMoneyEarned.toString(),
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.attach_money,
                                      color: Colors.green,
                                    ),
                                  ],
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
