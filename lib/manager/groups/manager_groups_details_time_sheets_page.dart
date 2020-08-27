import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/groups/manager_groups_details_time_sheets_workdays_accepted_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../shared/libraries/constants.dart';
import '../manager_app_bar.dart';
import '../manager_side_bar.dart';
import 'manager_group_details_time_sheets_workdays_in_progress_page.dart';

class ManagerGroupsDetailsTimeSheetsPage extends StatefulWidget {
  final User _user;
  final int _groupId;
  final String _groupName;
  final String _employeeNationality;
  final String _currency;
  final int _employeeId;
  final String _employeeInfo;

  const ManagerGroupsDetailsTimeSheetsPage(
    this._user,
    this._groupId,
    this._groupName,
    this._employeeNationality,
    this._currency,
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
              widget._user.authHeader)
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
          return loader(
            managerAppBar(context, null, getTranslated(context, 'loading')),
            managerSideBar(context, widget._user),
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
            theme:
                ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: DARK,
              appBar: managerAppBar(
                  context,
                  widget._user,
                  getTranslated(context, 'timesheets') +
                      ' - ' +
                      utf8.decode(widget._groupName != null
                          ? widget._groupName.runes.toList()
                          : '-')),
              drawer: managerSideBar(context, widget._user),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      text20WhiteBold(widget._employeeInfo != null
                          ? utf8.decode(widget._employeeInfo.runes.toList()) +
                              ' ' +
                              LanguageUtil.findFlagByNationality(
                                  widget._employeeNationality)
                          : getTranslated(context, 'empty')),
                      SizedBox(height: 10),
                      for (var timeSheet in timeSheets)
                        Card(
                          color: DARK,
                          child: InkWell(
                            onTap: () {
                              if (timeSheet.status == 'Accepted') {
                                Navigator.of(context).push(
                                  CupertinoPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return ManagerGroupsDetailsTimeSheetsWorkdaysAcceptedPage(
                                          widget._user,
                                          widget._employeeInfo,
                                          widget._employeeNationality,
                                          widget._currency,
                                          timeSheet);
                                    },
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  CupertinoPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage(
                                          widget._user,
                                          widget._employeeInfo,
                                          widget._employeeNationality,
                                          widget._currency,
                                          timeSheet);
                                    },
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
                                        ? GREEN
                                        : Colors.orange,
                                  ),
                                  title: textWhiteBold(
                                      timeSheet.year.toString() +
                                          ' ' +
                                          MonthUtil.translateMonth(
                                              context, timeSheet.month)),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Align(
                                          child: Row(
                                            children: <Widget>[
                                              textWhite(getTranslated(
                                                      context, 'hoursWorked') +
                                                  ': '),
                                              textGreenBold(timeSheet.totalHours
                                                      .toString() +
                                                  'h'),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft),
                                      Align(
                                        child: Row(
                                          children: <Widget>[
                                            textWhite(getTranslated(
                                                    context, 'averageRating') +
                                                ': '),
                                            textGreenBold(timeSheet
                                                .averageEmployeeRating
                                                .toString()),
                                          ],
                                        ),
                                        alignment: Alignment.topLeft,
                                      ),
                                    ],
                                  ),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      text20GreenBold(timeSheet.totalMoneyEarned
                                          .toString()),
                                      text20GreenBold(' ' + widget._currency)
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
