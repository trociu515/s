import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/month_util.dart';
import 'package:give_job/shared/toastr_service.dart';

import '../../shared/constants.dart';
import '../manager_side_bar.dart';

class ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPage
    extends StatefulWidget {
  final String _managerId;
  final String _managerInfo;
  final String _authHeader;

  final String _employeeInfo;
  final EmployeeTimeSheetDto timeSheet;

  const ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPage(this._managerId,
      this._managerInfo, this._authHeader, this._employeeInfo, this.timeSheet);

  @override
  _ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPageState createState() =>
      _ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPageState();
}

class _ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPageState
    extends State<ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WorkdayDto>>(
      future: _managerService
          .findWorkdaysByTimeSheetId(
              widget.timeSheet.id.toString(), widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(
                context, 'employeeDoesNotHaveWorkdaysInCurrentTimeSheet'),
            Colors.red);
        Navigator.pop(context);
      }),
      builder:
          (BuildContext context, AsyncSnapshot<List<WorkdayDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<WorkdayDto> workdays = snapshot.data;
          if (workdays.isEmpty) {
            ToastService.showToast(
                getTranslated(
                    context, 'employeeDoesNotHaveWorkdaysInCurrentTimeSheet'),
                Colors.red);
            Navigator.pop(context);
          }
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(context, getTranslated(context, 'workdays')),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget._employeeInfo != null
                            ? utf8.decode(widget._employeeInfo.runes.toList())
                            : getTranslated(context, 'empty'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        leading: Icon(
                          widget.timeSheet.status == 'Accepted'
                              ? Icons.check_circle_outline
                              : Icons.radio_button_unchecked,
                          color: widget.timeSheet.status == 'Accepted'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        title: Text(widget.timeSheet.year.toString() +
                            ' ' +
                            MonthUtil.translateMonth(
                                context, widget.timeSheet.month) +
                            '\n' +
                            utf8.decode(
                                widget.timeSheet.groupName.runes.toList())),
                        subtitle: Wrap(
                          children: <Widget>[
                            Text(getTranslated(context, 'hoursWorked') +
                                ': ' +
                                widget.timeSheet.totalHours.toString() +
                                'h'),
                            Text(getTranslated(context, 'averageRating') +
                                ': ' +
                                widget.timeSheet.averageEmployeeRating
                                    .toString()),
                          ],
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            Text(
                              widget.timeSheet.totalMoneyEarned.toString(),
                              style:
                                  TextStyle(color: Colors.green, fontSize: 20),
                            ),
                            Icon(
                              Icons.attach_money,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('#')),
                              DataColumn(
                                  label: Text(getTranslated(context, 'hours'))),
                              DataColumn(
                                  label:
                                      Text(getTranslated(context, 'rating'))),
                              DataColumn(
                                  label: Text(getTranslated(context, 'money'))),
                              DataColumn(
                                  label:
                                      Text(getTranslated(context, 'comment'))),
                            ],
                            rows: [
                              for (var workday in workdays)
                                DataRow(
                                  cells: [
                                    DataCell(Text(workday.number.toString())),
                                    DataCell(Text(workday.hours.toString())),
                                    DataCell(Text(workday.rating.toString())),
                                    DataCell(Text(workday.money.toString())),
                                    DataCell(Text(workday.comment != null
                                        ? utf8.decode(
                                            workday.comment.runes.toList())
                                        : getTranslated(context, 'empty'))),
                                  ],
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
