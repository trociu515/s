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
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../../../main.dart';
import '../../../../shared/libraries/constants.dart';
import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';

class ManagerEmployeeTimeSheetsWorkdaysInProgressPage extends StatefulWidget {
  final User _user;

  final String _employeeInfo;
  final String _employeeNationality;
  final String _currency;
  final EmployeeTimeSheetDto timeSheet;

  const ManagerEmployeeTimeSheetsWorkdaysInProgressPage(this._user,
      this._employeeInfo,
      this._employeeNationality,
      this._currency,
      this.timeSheet);

  @override
  _ManagerEmployeeTimeSheetsWorkdaysInProgressPageState createState() =>
      _ManagerEmployeeTimeSheetsWorkdaysInProgressPageState();
}

class _ManagerEmployeeTimeSheetsWorkdaysInProgressPageState
    extends State<ManagerEmployeeTimeSheetsWorkdaysInProgressPage> {
  final ManagerService _managerService = new ManagerService();
  final TextEditingController _hoursController = new TextEditingController();
  final TextEditingController _ratingController = new TextEditingController();
  final TextEditingController _commentController = new TextEditingController();

  Set<int> selectedIds = new Set();
  List<WorkdayDto> workdays = new List();
  bool _sortNo = true;
  bool _sortHours = true;
  bool _sortRatings = true;
  bool _sortMoney = true;
  bool _sortComments = true;
  bool _sort = true;
  int _sortColumnIndex;

  @override
  Widget build(BuildContext context) {
    if (workdays.isEmpty) {
      return FutureBuilder<List<WorkdayDto>>(
        future: _managerService
            .findWorkdaysByTimeSheetId(
            widget.timeSheet.id.toString(), widget._user.authHeader)
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
              managerSideBar(context, widget._user),
            );
          } else {
            List<WorkdayDto> workdays = snapshot.data;
            this.workdays = workdays;
            if (workdays.isEmpty) {
              ToastService.showBottomToast(
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
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: BRIGHTER_DARK,
                          child: Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: ListTile(
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
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: textWhiteBold(widget._employeeInfo !=
                                        null
                                        ? utf8.decode(widget._employeeInfo.runes
                                        .toList()) +
                                        ' ' +
                                        LanguageUtil.findFlagByNationality(
                                            widget._employeeNationality)
                                        : getTranslated(context, 'empty')),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: textWhite(getTranslated(
                                            context, 'hoursWorked') +
                                            ': '),
                                      ),
                                      textGreenBold(widget.timeSheet.totalHours
                                          .toString() +
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
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Theme(
                              data: Theme.of(context).copyWith(),
                              child: DataTable(
                                sortAscending: _sort,
                                sortColumnIndex: _sortColumnIndex,
                                columns: [
                                  DataColumn(
                                    label: textWhiteBold('No.'),
                                    onSort: (columnIndex, ascending) =>
                                        _onSortNo(columnIndex, ascending),
                                  ),
                                  DataColumn(
                                    label: textWhiteBold(
                                        getTranslated(context, 'hours')),
                                    onSort: (columnIndex, ascending) =>
                                        _onSortHours(columnIndex, ascending),
                                  ),
                                  DataColumn(
                                    label: textWhiteBold(
                                        getTranslated(context, 'rating')),
                                    onSort: (columnIndex, ascending) =>
                                        _onSortRatings(columnIndex, ascending),
                                  ),
                                  DataColumn(
                                    label: textWhiteBold(
                                        getTranslated(context, 'money')),
                                    onSort: (columnIndex, ascending) =>
                                        _onSortMoney(columnIndex, ascending),
                                  ),
                                  DataColumn(
                                    label: textWhiteBold(
                                        getTranslated(context, 'comment')),
                                    onSort: (columnIndex, ascending) =>
                                        _onSortComments(columnIndex, ascending),
                                  ),
                                ],
                                rows: this
                                    .workdays
                                    .map(
                                      (workday) =>
                                      DataRow(
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
                                            onTap: () =>
                                                _showCommentDetails(
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
                bottomNavigationBar: Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 1),
                      Expanded(
                        child: MaterialButton(
                          color: GREEN,
                          child: textDarkBold(getTranslated(context, 'hours')),
                          onPressed: () =>
                          {
                            _hoursController.clear(),
                            _showUpdateHoursDialog(selectedIds)
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MaterialButton(
                          color: GREEN,
                          child: textDarkBold(getTranslated(context, 'rating')),
                          onPressed: () =>
                          {
                            _ratingController.clear(),
                            _showUpdateRatingDialog(selectedIds)
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: MaterialButton(
                          color: GREEN,
                          child:
                          textDarkBold(getTranslated(context, 'comment')),
                          onPressed: () =>
                          {
                            _commentController.clear(),
                            _showUpdateCommentDialog(selectedIds)
                          },
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
              child: Column(
                children: <Widget>[
                  Container(
                    color: BRIGHTER_DARK,
                    child: Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 5),
                      child: ListTile(
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: textWhiteBold(widget._employeeInfo != null
                                  ? utf8.decode(
                                  widget._employeeInfo.runes.toList()) +
                                  ' ' +
                                  LanguageUtil.findFlagByNationality(
                                      widget._employeeNationality)
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
                                    widget.timeSheet.totalHours.toString() +
                                        'h'),
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
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Theme(
                        data: Theme.of(context).copyWith(),
                        child: DataTable(
                          sortAscending: _sort,
                          sortColumnIndex: _sortColumnIndex,
                          columns: [
                            DataColumn(
                              label: textWhiteBold('No.'),
                              onSort: (columnIndex, ascending) =>
                                  _onSortNo(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: textWhiteBold(
                                  getTranslated(context, 'hours')),
                              onSort: (columnIndex, ascending) =>
                                  _onSortHours(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: textWhiteBold(
                                  getTranslated(context, 'rating')),
                              onSort: (columnIndex, ascending) =>
                                  _onSortRatings(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: textWhiteBold(
                                  getTranslated(context, 'money')),
                              onSort: (columnIndex, ascending) =>
                                  _onSortMoney(columnIndex, ascending),
                            ),
                            DataColumn(
                              label: textWhiteBold(
                                  getTranslated(context, 'comment')),
                              onSort: (columnIndex, ascending) =>
                                  _onSortComments(columnIndex, ascending),
                            ),
                          ],
                          rows: this
                              .workdays
                              .map(
                                (workday) =>
                                DataRow(
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
                                      onTap: () =>
                                          _showCommentDetails(workday.comment),
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
          bottomNavigationBar: Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(width: 1),
                Expanded(
                  child: MaterialButton(
                    color: GREEN,
                    child: textDarkBold(getTranslated(context, 'hours')),
                    onPressed: () =>
                    {
                      _hoursController.clear(),
                      _showUpdateHoursDialog(selectedIds)
                    },
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: MaterialButton(
                    color: GREEN,
                    child: textDarkBold(getTranslated(context, 'rating')),
                    onPressed: () =>
                    {
                      _ratingController.clear(),
                      _showUpdateRatingDialog(selectedIds)
                    },
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: MaterialButton(
                    color: GREEN,
                    child: textDarkBold(getTranslated(context, 'comment')),
                    onPressed: () =>
                    {
                      _commentController.clear(),
                      _showUpdateCommentDialog(selectedIds)
                    },
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

  void _onSortNo(columnIndex, ascending) {
    setState(() {
      if (columnIndex == _sortColumnIndex) {
        _sort = _sortNo = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sort = _sortNo;
      }
      workdays.sort((a, b) => a.id.compareTo(b.id));
      if (!_sort) {
        workdays = workdays.reversed.toList();
      }
    });
  }

  void _onSortHours(columnIndex, ascending) {
    setState(() {
      if (columnIndex == _sortColumnIndex) {
        _sort = _sortHours = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sort = _sortHours;
      }
      workdays.sort((a, b) => a.hours.compareTo(b.hours));
      if (!_sort) {
        workdays = workdays.reversed.toList();
      }
    });
  }

  void _onSortRatings(columnIndex, ascending) {
    setState(() {
      if (columnIndex == _sortColumnIndex) {
        _sort = _sortRatings = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sort = _sortRatings;
      }
      workdays.sort((a, b) => a.rating.compareTo(b.rating));
      if (!_sort) {
        workdays = workdays.reversed.toList();
      }
    });
  }

  void _onSortMoney(columnIndex, ascending) {
    setState(() {
      if (columnIndex == _sortColumnIndex) {
        _sort = _sortMoney = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sort = _sortMoney;
      }
      workdays.sort((a, b) => a.money.compareTo(b.money));
      if (!_sort) {
        workdays = workdays.reversed.toList();
      }
    });
  }

  void _onSortComments(columnIndex, ascending) {
    setState(() {
      if (columnIndex == _sortColumnIndex) {
        _sort = _sortComments = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sort = _sortComments;
      }
      workdays.sort((a, b) => a.comment.compareTo(b.comment));
      if (!_sort) {
        workdays = workdays.reversed.toList();
      }
    });
  }

  void _showCommentDetails(String comment) {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Comment details'),
            SizedBox(height: 20),
            text20White(comment != null
                ? utf8.decode(comment.runes.toList())
                : getTranslated(context, 'empty')),
          ],
        ),
      ),
    );
  }

  void _showUpdateHoursDialog(Set<int> selectedIds) {
    slideDialog.showSlideDialog(
        context: context,
        backgroundColor: DARK,
        child: selectedIds.isNotEmpty
            ? Column(
          children: <Widget>[
            text20GreenBold('HOURS'),
            SizedBox(height: 5),
            Container(
              width: 125,
              child: TextFormField(
                autofocus: true,
                controller: _hoursController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                maxLength: 2,
                cursorColor: WHITE,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: WHITE),
                  labelStyle: TextStyle(color: WHITE),
                  labelText:
                  getTranslated(context, 'newHours') + ' (0-24)',
                ),
              ),
            ),
            SizedBox(height: 5),
            MaterialButton(
              elevation: 0,
              height: 50,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: textWhiteBold(getTranslated(context, 'update')),
              color: GREEN,
              onPressed: () {
                int hours;
                try {
                  hours = int.parse(_hoursController.text);
                } catch (FormatException) {
                  ToastService.showBottomToast(
                      getTranslated(context, 'givenValueIsNotANumber'),
                      Colors.red);
                  return;
                }
                String invalidMessage =
                ValidatorService.validateUpdatingHours(
                    hours, context);
                if (invalidMessage != null) {
                  ToastService.showBottomToast(
                      invalidMessage, Colors.red);
                  return;
                }
                _managerService
                    .updateWorkdaysHours(
                    selectedIds, hours, widget._user.authHeader)
                    .then(
                      (res) {
                    Navigator.of(context).pop();
                    selectedIds.clear();
                    ToastService.showCenterToast(
                        getTranslated(
                            context, 'hoursUpdatedSuccessfully'),
                        GREEN);
                    _refresh();
                  },
                );
              },
            ),
          ],
        )
            : _buildHint());
  }

  void _showUpdateRatingDialog(Set<int> selectedIds) {
    slideDialog.showSlideDialog(
        context: context,
        backgroundColor: DARK,
        child: selectedIds.isNotEmpty
            ? Column(
          children: <Widget>[
            text20GreenBold('RATING'),
            SizedBox(height: 5),
            Container(
              width: 125,
              child: TextFormField(
                autofocus: true,
                controller: _ratingController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                maxLength: 2,
                cursorColor: WHITE,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: WHITE),
                  labelStyle: TextStyle(color: WHITE),
                  labelText:
                  getTranslated(context, 'newRating') + ' (1-10)',
                ),
              ),
            ),
            SizedBox(height: 5),
            MaterialButton(
              elevation: 0,
              height: 50,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: textWhiteBold(getTranslated(context, 'update')),
              color: GREEN,
              onPressed: () {
                int hours;
                try {
                  hours = int.parse(_ratingController.text);
                } catch (FormatException) {
                  ToastService.showBottomToast(
                      getTranslated(context, 'givenValueIsNotANumber'),
                      Colors.red);
                  return;
                }
                String invalidMessage =
                ValidatorService.validateUpdatingRating(
                    hours, context);
                if (invalidMessage != null) {
                  ToastService.showBottomToast(
                      invalidMessage, Colors.red);
                  return;
                }
                _managerService
                    .updateWorkdaysRating(
                    selectedIds, hours, widget._user.authHeader)
                    .then((res) {
                  Navigator.of(context).pop();
                  selectedIds.clear();
                  ToastService.showCenterToast(
                      getTranslated(context, 'ratingUpdatedSuccessfully'),
                      GREEN);
                  _refresh();
                });
              },
            ),
          ],
        )
            : _buildHint());
  }

  void _showUpdateCommentDialog(Set<int> selectedIds) {
    slideDialog.showSlideDialog(
        context: context,
        backgroundColor: DARK,
        child: selectedIds.isNotEmpty
            ? Column(
          children: <Widget>[
            text20GreenBold('COMMENT'),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                autofocus: true,
                controller: _commentController,
                keyboardType: TextInputType.multiline,
                maxLength: 510,
                maxLines: 3,
                cursorColor: WHITE,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(color: WHITE),
                decoration: InputDecoration(
                  counterStyle: TextStyle(color: WHITE),
                  labelStyle: TextStyle(color: WHITE),
                  labelText: getTranslated(context, 'newComment'),
                ),
              ),
            ),
            MaterialButton(
              elevation: 0,
              height: 50,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: textWhiteBold(getTranslated(context, 'update')),
              color: GREEN,
              onPressed: () {
                String comment = _commentController.text;
                String invalidMessage =
                ValidatorService.validateUpdatingComment(
                    comment, context);
                if (invalidMessage != null) {
                  ToastService.showBottomToast(
                      invalidMessage, Colors.red);
                  return;
                }
                _managerService
                    .updateWorkdaysComment(
                    selectedIds, comment, widget._user.authHeader)
                    .then((res) {
                  Navigator.of(context).pop();
                  selectedIds.clear();
                  ToastService.showCenterToast(
                      getTranslated(
                          context, 'commentUpdatedSuccessfully'),
                      GREEN);
                  _refresh();
                });
              },
            ),
          ],
        )
            : _buildHint());
  }

  Widget _buildHint() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          text20GreenBold('Hint'),
          SizedBox(height: 10),
          text20White('You need to select records '),
          text20White('which you want to update.'),
        ],
      ),
    );
  }
}
