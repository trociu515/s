import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../shared/libraries/constants.dart';
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
          return loader(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(context, widget._managerId, widget._managerInfo,
                widget._authHeader),
          );
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
            theme:
                ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: DARK,
              appBar: appBar(context, getTranslated(context, 'workdays')),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      text15WhiteBold(widget._employeeInfo != null
                          ? utf8.decode(widget._employeeInfo.runes.toList())
                          : getTranslated(context, 'empty')),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(
                          widget.timeSheet.status == 'Accepted'
                              ? Icons.check_circle_outline
                              : Icons.radio_button_unchecked,
                          color: widget.timeSheet.status == 'Accepted'
                              ? GREEN
                              : Colors.orange,
                        ),
                        title: textWhiteBold(widget.timeSheet.year.toString() +
                            ' ' +
                            MonthUtil.translateMonth(
                                context, widget.timeSheet.month) +
                            '\n' +
                            utf8.decode(
                              widget.timeSheet.groupName.runes.toList(),
                            )),
                        subtitle: Wrap(
                          children: <Widget>[
                            textWhite(getTranslated(context, 'hoursWorked') +
                                ': ' +
                                widget.timeSheet.totalHours.toString() +
                                'h'),
                            textWhite(getTranslated(context, 'averageRating') +
                                ': ' +
                                widget.timeSheet.averageEmployeeRating
                                    .toString()),
                          ],
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            text20GreenBold(
                                widget.timeSheet.totalMoneyEarned.toString()),
                            text20GreenBold(" ZŁ"),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: textWhiteBold('#')),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'hours'))),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'rating'))),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'money'))),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'comment'))),
                            ],
                            rows: [
                              for (var workday in workdays)
                                DataRow(
                                  cells: [
                                    DataCell(
                                        textWhite(workday.number.toString())),
                                    DataCell(
                                        textWhite(workday.hours.toString())),
                                    DataCell(
                                        textWhite(workday.rating.toString())),
                                    DataCell(
                                        textWhite(workday.money.toString())),
                                    DataCell(
                                        Wrap(
                                          children: <Widget>[
                                            textWhite(workday.comment != null
                                                ? workday.comment.length > 10
                                                    ? utf8
                                                            .decode(workday
                                                                .comment.runes
                                                                .toList())
                                                            .substring(0, 10) +
                                                        '...'
                                                    : utf8.decode(workday
                                                        .comment.runes
                                                        .toList())
                                                : getTranslated(
                                                    context, 'empty')),
                                            workday.comment != null &&
                                                    workday.comment != ''
                                                ? iconWhite(Icons.zoom_in)
                                                : Text('')
                                          ],
                                        ),
                                        onTap: () => _showCommentDetails(
                                            workday.comment)),
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

  void _showCommentDetails(String comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textDarkBold(getTranslated(context, 'commentDetails')),
          content: textDark(comment != null
              ? utf8.decode(comment.runes.toList())
              : getTranslated(context, 'empty')),
          actions: <Widget>[
            FlatButton(
                child: textDark(getTranslated(context, 'close')),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }
}
