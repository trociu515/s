import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/groups/manager_groups_details_time_sheets_workdays_accepted_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/loader_widget.dart';
import 'package:give_job/shared/month_util.dart';
import 'package:give_job/shared/toastr_service.dart';

import '../../shared/constants.dart';
import '../manager_side_bar.dart';
import 'manager_group_details_time_sheets_workdays_in_progress_page.dart';

class ManagerGroupsDetailsTimeSheetsPage extends StatefulWidget {
  final String _managerId;
  final String _managerInfo;
  final String _authHeader;

  final int _groupId;
  final String _groupName;
  final String _groupDescription;
  final int _employeeId;
  final String _employeeInfo;

  const ManagerGroupsDetailsTimeSheetsPage(
    this._managerId,
    this._managerInfo,
    this._authHeader,
    this._groupId,
    this._groupName,
    this._groupDescription,
    this._employeeId,
    this._employeeInfo,
  );

  @override
  _ManagerGroupsDetailsTimeSheetsPageState createState() =>
      _ManagerGroupsDetailsTimeSheetsPageState();
}

class _ManagerGroupsDetailsTimeSheetsPageState
    extends State<ManagerGroupsDetailsTimeSheetsPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EmployeeTimeSheetDto>>(
      future: _managerService
          .findEmployeeTimeSheetsByGroupIdAndEmployeeId(
              widget._groupId.toString(),
              widget._employeeId.toString(),
              widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'employeeDoesNotHaveTimeSheets'),
            Colors.red);
        Navigator.pop(context);
      }),
      builder: (BuildContext context,
          AsyncSnapshot<List<EmployeeTimeSheetDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loaderWidget(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(context, widget._managerId, widget._managerInfo,
                widget._authHeader),
          );
        } else {
          List<EmployeeTimeSheetDto> timeSheets = snapshot.data;
          if (timeSheets.isEmpty) {
            ToastService.showToast(
                getTranslated(context, 'employeeDoesNotHaveTimeSheets'),
                Colors.red);
            Navigator.pop(context);
          }
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(context, getTranslated(context, 'workTimeSheets')),
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
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              widget._employeeInfo != null
                                  ? utf8.decode(
                                      widget._employeeInfo.runes.toList())
                                  : getTranslated(context, 'empty'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var timeSheet in timeSheets)
                        Card(
                          child: InkWell(
                            onTap: () {
                              if (timeSheet.status == 'Accepted') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPage(
                                            widget._managerId,
                                            widget._managerInfo,
                                            widget._authHeader,
                                            widget._employeeInfo,
                                            timeSheet),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage(
                                            widget._managerId,
                                            widget._managerInfo,
                                            widget._authHeader,
                                            widget._employeeInfo,
                                            timeSheet),
                                  ),
                                );
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(
                                    timeSheet.status == 'Accepted'
                                        ? Icons.check_circle_outline
                                        : Icons.radio_button_unchecked,
                                    color: timeSheet.status == 'Accepted'
                                        ? Color(0xffb5d76d)
                                        : Colors.orange,
                                  ),
                                  title: Text(timeSheet.year.toString() +
                                      ' ' +
                                      MonthUtil.translateMonth(
                                          context, timeSheet.month)),
                                  subtitle: Wrap(
                                    children: <Widget>[
                                      Text(getTranslated(
                                              context, 'hoursWorked') +
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
                                            color: Color(0xffb5d76d), fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.attach_money,
                                        color: Color(0xffb5d76d),
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
