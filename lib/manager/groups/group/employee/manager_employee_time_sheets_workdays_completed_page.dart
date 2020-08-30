import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../../../shared/libraries/constants.dart';
import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';
import 'model/group_employee_model.dart';

class ManagerEmployeeTimeSheetsWorkdaysCompletedPage extends StatefulWidget {
  final GroupEmployeeModel _model;
  final String _employeeInfo;
  final String _employeeNationality;
  final String _currency;
  final EmployeeTimeSheetDto timeSheet;

  const ManagerEmployeeTimeSheetsWorkdaysCompletedPage(
      this._model,
      this._employeeInfo,
      this._employeeNationality,
      this._currency,
      this.timeSheet);

  @override
  _ManagerEmployeeTimeSheetsWorkdaysCompletedPageState createState() =>
      _ManagerEmployeeTimeSheetsWorkdaysCompletedPageState();
}

class _ManagerEmployeeTimeSheetsWorkdaysCompletedPageState
    extends State<ManagerEmployeeTimeSheetsWorkdaysCompletedPage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;
  String _employeeInfo;
  String _employeeNationality;
  String _currency;
  EmployeeTimeSheetDto timeSheet;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    this._employeeInfo = widget._employeeInfo;
    this._employeeNationality = widget._employeeNationality;
    this._currency = widget._currency;
    this.timeSheet = widget.timeSheet;
    return FutureBuilder<List<WorkdayDto>>(
      future: _managerService
          .findWorkdaysByTimeSheetId(
              timeSheet.id.toString(), _model.user.authHeader)
          .catchError((e) {
        ToastService.showBottomToast(
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
            managerAppBar(context, null, getTranslated(context, 'loading')),
            managerSideBar(context, _model.user),
          );
        } else {
          List<WorkdayDto> workdays = snapshot.data;
          if (workdays.isEmpty) {
            ToastService.showBottomToast(
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
              appBar: managerAppBar(
                  context,
                  _model.user,
                  getTranslated(context, 'workdays') +
                      ' - ' +
                      utf8.decode(timeSheet.groupName != null
                          ? timeSheet.groupName.runes.toList()
                          : '-')),
              drawer: managerSideBar(context, _model.user),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: BRIGHTER_DARK,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: ListTile(
                          leading: Icon(
                            timeSheet.status == 'Completed'
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: timeSheet.status == 'Completed'
                                ? GREEN
                                : Colors.orange,
                          ),
                          title: textWhiteBold(timeSheet.year.toString() +
                              ' ' +
                              MonthUtil.translateMonth(
                                  context, timeSheet.month)),
                          subtitle: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: textWhiteBold(_employeeInfo != null
                                    ? utf8.decode(
                                            _employeeInfo.runes.toList()) +
                                        ' ' +
                                        LanguageUtil.findFlagByNationality(
                                            _employeeNationality)
                                    : getTranslated(context, 'empty')),
                              ),
                              Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: textWhite(
                                        getTranslated(context, 'hoursWorked') +
                                            ': '),
                                  ),
                                  textGreenBold(
                                      timeSheet.totalHours.toString() + 'h'),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: textWhite(getTranslated(
                                            context, 'averageRating') +
                                        ': '),
                                  ),
                                  textGreenBold(widget
                                      .timeSheet.averageEmployeeRating
                                      .toString()),
                                ],
                              ),
                            ],
                          ),
                          trailing: Wrap(
                            children: <Widget>[
                              text20GreenBold(
                                  timeSheet.totalMoneyEarned.toString()),
                              text20GreenBold(' ' + _currency),
                            ],
                          ),
                        ),
                      ),
                    ),
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
                            DataColumn(label: textWhiteBold('Opinion')),
                          ],
                          rows: [
                            for (var workday in workdays)
                              DataRow(
                                cells: [
                                  DataCell(
                                      textWhite(workday.number.toString())),
                                  DataCell(textWhite(workday.hours.toString())),
                                  DataCell(
                                      textWhite(workday.rating.toString())),
                                  DataCell(textWhite(workday.money.toString())),
                                  DataCell(
                                      Wrap(
                                        children: <Widget>[
                                          textWhite(workday.opinion != null
                                              ? workday.opinion.length > 10
                                                  ? utf8
                                                          .decode(workday
                                                              .opinion.runes
                                                              .toList())
                                                          .substring(0, 10) +
                                                      '...'
                                                  : utf8.decode(workday
                                                      .opinion.runes
                                                      .toList())
                                              : getTranslated(
                                                  context, 'empty')),
                                          workday.opinion != null &&
                                                  workday.opinion != ''
                                              ? iconWhite(Icons.zoom_in)
                                              : Text('')
                                        ],
                                      ),
                                      onTap: () =>
                                          _showOpinionDetails(workday.opinion)),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: groupFloatingActionButton(context, _model),
            ),
          );
        }
      },
    );
  }

  void _showOpinionDetails(String opinion) {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Opinion details'),
            SizedBox(height: 20),
            text20White(opinion != null
                ? utf8.decode(opinion.runes.toList())
                : getTranslated(context, 'empty')),
          ],
        ),
      ),
    );
  }
}
