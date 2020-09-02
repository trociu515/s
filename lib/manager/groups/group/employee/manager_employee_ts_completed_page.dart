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

class ManagerEmployeeTsCompletedPage extends StatefulWidget {
  final GroupEmployeeModel _model;
  final String _employeeInfo;
  final String _employeeNationality;
  final String _currency;
  final EmployeeTimeSheetDto timeSheet;

  const ManagerEmployeeTsCompletedPage(
      this._model,
      this._employeeInfo,
      this._employeeNationality,
      this._currency,
      this.timeSheet);

  @override
  _ManagerEmployeeTsCompletedPageState createState() =>
      _ManagerEmployeeTsCompletedPageState();
}

class _ManagerEmployeeTsCompletedPageState
    extends State<ManagerEmployeeTsCompletedPage> {
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
              body: Column(
                children: <Widget>[
                  Container(
                    color: BRIGHTER_DARK,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: ListTile(
                        leading: Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Image(
                            image: AssetImage('images/checked.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        title: textWhiteBold(timeSheet.year.toString() +
                            ' ' +
                            MonthUtil.translateMonth(context, timeSheet.month)),
                        subtitle: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: textWhiteBold(_employeeInfo != null
                                  ? utf8.decode(_employeeInfo.runes.toList()) +
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
                                    timeSheet.numberOfHoursWorked.toString() + 'h'),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: textWhite(
                                      getTranslated(context, 'averageRating') +
                                          ': '),
                                ),
                                textGreenBold(widget
                                    .timeSheet.averageRating
                                    .toString()),
                              ],
                            ),
                          ],
                        ),
                        trailing: Wrap(
                          children: <Widget>[
                            text20GreenBold(
                                timeSheet.amountOfEarnedMoney.toString()),
                            text20GreenBold(' ' + _currency),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: MORE_BRIGHTER_DARK),
                          child: DataTable(
                            columnSpacing: 10,
                            columns: [
                              DataColumn(label: textWhiteBold('No.')),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'hours'))),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'rating'))),
                              DataColumn(
                                  label: textWhiteBold(
                                      getTranslated(context, 'money'))),
                              DataColumn(label: textWhiteBold('Plan')),
                              DataColumn(label: textWhiteBold('Opinion')),
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
                                            workday.plan != null &&
                                                    workday.plan != ''
                                                ? iconWhite(Icons.zoom_in)
                                                : textWhiteBold('-'),
                                          ],
                                        ),
                                        onTap: () =>
                                            _showPlanDetails(workday.opinion)),
                                    DataCell(
                                        Wrap(
                                          children: <Widget>[
                                            workday.opinion != null &&
                                                    workday.opinion != ''
                                                ? iconWhite(Icons.zoom_in)
                                                : textWhiteBold('-'),
                                          ],
                                        ),
                                        onTap: () => _showOpinionDetails(
                                            workday.opinion)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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

  void _showPlanDetails(String plan) {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Plan details'),
            SizedBox(height: 20),
            text20White(plan != null
                ? utf8.decode(plan.runes.toList())
                : getTranslated(context, 'empty')),
          ],
        ),
      ),
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
