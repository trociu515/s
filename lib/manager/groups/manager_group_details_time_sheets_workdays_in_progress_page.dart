import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../main.dart';
import '../../shared/libraries/constants.dart';
import '../manager_app_bar.dart';
import '../manager_side_bar.dart';

class ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage
    extends StatefulWidget {
  final User _user;

  final String _employeeInfo;
  final String _employeeNationality;
  final String _currency;
  final EmployeeTimeSheetDto timeSheet;

  const ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage(
      this._user,
      this._employeeInfo,
      this._employeeNationality,
      this._currency,
      this.timeSheet);

  @override
  _ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPageState createState() =>
      _ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPageState();
}

class _ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPageState
    extends State<ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage> {
  final ManagerService _managerService = new ManagerService();

  Set<int> selectedIds = new Set();
  List<WorkdayDto> workdays = new List();
  bool sort = true;

  @override
  Widget build(BuildContext context) {
    if (workdays.isEmpty) {
      return FutureBuilder<List<WorkdayDto>>(
        future: _managerService
            .findWorkdaysByTimeSheetId(
                widget.timeSheet.id.toString(), widget._user.authHeader)
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
              managerAppBar(context, null, getTranslated(context, 'loading')),
              managerSideBar(context, widget._user),
            );
          } else {
            List<WorkdayDto> workdays = snapshot.data;
            this.workdays = workdays;
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
                  primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: DARK,
                appBar: managerAppBar(
                    context,
                    widget._user,
                    getTranslated(context, 'workdays') +
                        ' - ' +
                        utf8.decode(widget.timeSheet.groupName != null
                            ? widget.timeSheet.groupName.runes.toList()
                            : '-')),
                drawer: managerSideBar(context, widget._user),
                body: RefreshIndicator(
                  color: DARK,
                  backgroundColor: WHITE,
                  key: refreshIndicatorState,
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          text20WhiteBold(widget._employeeInfo != null
                              ? utf8.decode(
                                      widget._employeeInfo.runes.toList()) +
                                  ' ' +
                                  LanguageUtil.findFlagByNationality(
                                      widget._employeeNationality)
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
                            title: textWhiteBold(
                                widget.timeSheet.year.toString() +
                                    ' ' +
                                    MonthUtil.translateMonth(
                                        context, widget.timeSheet.month)),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: textWhite(getTranslated(
                                              context, 'hoursWorked') +
                                          ': '),
                                    ),
                                    textGreenBold(
                                        widget.timeSheet.totalHours.toString() +
                                            'h'),
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
                                text20GreenBold(widget
                                    .timeSheet.totalMoneyEarned
                                    .toString()),
                                text20GreenBold(' ' + widget._currency)
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Theme(
                                data: Theme.of(context).copyWith(),
                                child: DataTable(
                                  sortAscending: sort,
                                  sortColumnIndex: 0,
                                  columns: [
                                    DataColumn(
                                        label: textWhiteBold('No.'),
                                        onSort: (columnIndex, ascending) {
                                          setState(() {
                                            sort = !sort;
                                          });
                                          onSortColum(columnIndex, ascending);
                                        }),
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
                                  rows: this
                                      .workdays
                                      .map(
                                        (workday) => DataRow(
                                          selected:
                                              selectedIds.contains(workday.id),
                                          onSelectChanged: (bool selected) {
                                            onSelectedRow(selected, workday.id);
                                          },
                                          cells: [
                                            DataCell(textWhite(
                                                workday.number.toString())),
                                            DataCell(textWhite(
                                                workday.hours.toString())),
                                            DataCell(textWhite(
                                                workday.rating.toString())),
                                            DataCell(textWhite(
                                                workday.money.toString())),
                                            DataCell(
                                              Wrap(
                                                children: <Widget>[
                                                  textWhite(workday.comment !=
                                                          null
                                                      ? workday.comment.length >
                                                              10
                                                          ? utf8
                                                                  .decode(workday
                                                                      .comment
                                                                      .runes
                                                                      .toList())
                                                                  .substring(
                                                                      0, 10) +
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
                                                  workday.comment),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 1),
                      Expanded(
                        child: MaterialButton(
                          color: GREEN,
                          child: textDarkBold(getTranslated(context, 'hours')),
                          onPressed: () => _showDialog('HOURS', selectedIds),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MaterialButton(
                          color: GREEN,
                          child: textDarkBold(getTranslated(context, 'rating')),
                          onPressed: () => _showDialog('RATING', selectedIds),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MaterialButton(
                          color: GREEN,
                          child:
                              textDarkBold(getTranslated(context, 'comment')),
                          onPressed: () => _showDialog('COMMENT', selectedIds),
                        ),
                      ),
                      SizedBox(width: 1),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      );
    } else {
      return MaterialApp(
        title: APP_NAME,
        theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: DARK,
          appBar: managerAppBar(
              context,
              widget._user,
              getTranslated(context, 'workdays') +
                  ' - ' +
                  utf8.decode(widget.timeSheet.groupName != null
                      ? widget.timeSheet.groupName.runes.toList()
                      : '-')),
          drawer: managerSideBar(context, widget._user),
          body: RefreshIndicator(
            color: DARK,
            backgroundColor: WHITE,
            key: refreshIndicatorState,
            onRefresh: _refresh,
            child: SingleChildScrollView(
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
                              context, widget.timeSheet.month)),
                      subtitle: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,
                                child: textWhite(
                                    getTranslated(context, 'hoursWorked') +
                                        ': '),
                              ),
                              textGreenBold(
                                  widget.timeSheet.totalHours.toString() + 'h'),
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
                                  .timeSheet.averageEmployeeRating
                                  .toString()),
                            ],
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          text20GreenBold(
                              widget.timeSheet.totalMoneyEarned.toString()),
                          text20GreenBold(' ' + widget._currency)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context).copyWith(),
                          child: DataTable(
                            sortAscending: sort,
                            sortColumnIndex: 0,
                            columns: [
                              DataColumn(
                                  label: textWhiteBold('No.'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      sort = !sort;
                                    });
                                    onSortColum(columnIndex, ascending);
                                  }),
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
                            rows: this
                                .workdays
                                .map(
                                  (workday) => DataRow(
                                    selected: selectedIds.contains(workday.id),
                                    onSelectChanged: (bool selected) {
                                      onSelectedRow(selected, workday.id);
                                    },
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
                                            workday.comment),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(width: 1),
                Expanded(
                  child: MaterialButton(
                    color: GREEN,
                    child: textDarkBold(getTranslated(context, 'hours')),
                    onPressed: () => _showDialog('HOURS', selectedIds),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: MaterialButton(
                    color: GREEN,
                    child: textDarkBold(getTranslated(context, 'rating')),
                    onPressed: () => _showDialog('RATING', selectedIds),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: MaterialButton(
                    color: GREEN,
                    child: textDarkBold(getTranslated(context, 'comment')),
                    onPressed: () => _showDialog('COMMENT', selectedIds),
                  ),
                ),
                SizedBox(width: 1),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<Null> _refresh() {
    return _managerService
        .findWorkdaysByTimeSheetId(
            widget.timeSheet.id.toString(), widget._user.authHeader)
        .then((_workdays) {
      setState(() {
        workdays = _workdays;
      });
    });
  }

  void onSelectedRow(bool selected, int id) {
    setState(() {
      selected ? selectedIds.add(id) : selectedIds.remove(id);
    });
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        workdays.sort((a, b) => a.number.compareTo(b.number));
      } else {
        workdays.sort((a, b) => b.number.compareTo(a.number));
      }
    }
  }

  void _showCommentDetails(String comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textWhiteBold(getTranslated(context, 'commentDetails')),
          content: textWhite(comment != null
              ? utf8.decode(comment.runes.toList())
              : getTranslated(context, 'empty')),
          actions: <Widget>[
            FlatButton(
                child: textWhite(getTranslated(context, 'close')),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  void _showDialog(String content, Set<int> selectedIds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (selectedIds.isEmpty) {
          return AlertDialog(
            backgroundColor: DARK,
            title: textWhite('Information'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  textWhite(
                      'You need to select records which you want to update.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        }
        if (content == 'HOURS') {
          final hoursController = new TextEditingController();
          TextFormField field = TextFormField(
            controller: hoursController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            maxLength: 2,
            cursorColor: WHITE,
            style: TextStyle(color: WHITE),
            decoration: InputDecoration(
              counterStyle: TextStyle(color: WHITE),
              labelStyle: TextStyle(color: WHITE),
              labelText: getTranslated(context, 'newHours') + ' (0-24)',
            ),
          );
          return AlertDialog(
            backgroundColor: DARK,
            title: textWhite(getTranslated(context, 'updatingHours')),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite(getTranslated(context, 'update')),
                onPressed: () {
                  int hours;
                  try {
                    hours = int.parse(hoursController.text);
                  } catch (FormatException) {
                    ToastService.showToast(
                        getTranslated(context, 'givenValueIsNotANumber'),
                        Colors.red);
                    return;
                  }
                  String invalidMessage =
                      ValidatorService.validateUpdatingHours(hours, context);
                  if (invalidMessage != null) {
                    ToastService.showToast(invalidMessage, Colors.red);
                    return;
                  }
                  _managerService
                      .updateWorkdaysHours(
                          selectedIds, hours, widget._user.authHeader)
                      .then((res) {
                    Navigator.of(context).pop();
                    ToastService.showToast(
                        getTranslated(context, 'hoursUpdatedSuccessfully'),
                        GREEN);
                    _refresh();
                  });
                },
              ),
              FlatButton(
                  child: textWhite(getTranslated(context, 'close')),
                  onPressed: () => Navigator.of(context).pop())
            ],
          );
        } else if (content == 'RATING') {
          final ratingController = new TextEditingController();
          TextFormField field = TextFormField(
            controller: ratingController,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: WHITE),
            cursorColor: WHITE,
            maxLength: 2,
            decoration: InputDecoration(
              counterStyle: TextStyle(color: WHITE),
              labelStyle: TextStyle(color: WHITE),
              labelText: getTranslated(context, 'newRating') + ' (1-10)',
            ),
          );
          return AlertDialog(
            backgroundColor: DARK,
            title: textWhiteBold(getTranslated(context, 'updatingRating')),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite(getTranslated(context, 'update')),
                onPressed: () {
                  int hours;
                  try {
                    hours = int.parse(ratingController.text);
                  } catch (FormatException) {
                    ToastService.showToast(
                        getTranslated(context, 'givenValueIsNotANumber'),
                        Colors.red);
                    return;
                  }
                  String invalidMessage =
                      ValidatorService.validateUpdatingRating(hours, context);
                  if (invalidMessage != null) {
                    ToastService.showToast(invalidMessage, Colors.red);
                    return;
                  }
                  _managerService
                      .updateWorkdaysRating(
                          selectedIds, hours, widget._user.authHeader)
                      .then((res) {
                    Navigator.of(context).pop();
                    ToastService.showToast(
                        getTranslated(context, 'ratingUpdatedSuccessfully'),
                        GREEN);
                    _refresh();
                  });
                },
              ),
              FlatButton(
                child: textWhite(getTranslated(context, 'close')),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        } else {
          final commentController = new TextEditingController();
          TextFormField field = TextFormField(
            controller: commentController,
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLength: 510,
            maxLines: 10,
            style: TextStyle(color: WHITE),
            cursorColor: WHITE,
            decoration: InputDecoration(
              counterStyle: TextStyle(color: WHITE),
              labelStyle: TextStyle(color: WHITE),
              labelText: getTranslated(context, 'newComment'),
            ),
          );
          return AlertDialog(
            backgroundColor: DARK,
            title: textWhiteBold(getTranslated(context, 'updatingComment')),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite(getTranslated(context, 'update')),
                onPressed: () {
                  String comment = commentController.text;
                  String invalidMessage =
                      ValidatorService.validateUpdatingComment(
                          comment, context);
                  if (invalidMessage != null) {
                    ToastService.showToast(invalidMessage, Colors.red);
                    return;
                  }
                  _managerService
                      .updateWorkdaysComment(
                          selectedIds, comment, widget._user.authHeader)
                      .then((res) {
                    Navigator.of(context).pop();
                    ToastService.showToast(
                        getTranslated(context, 'commentUpdatedSuccessfully'),
                        GREEN);
                    _refresh();
                  });
                },
              ),
              FlatButton(
                child: textWhite(getTranslated(context, 'close')),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        }
      },
    );
  }
}
