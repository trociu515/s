import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/colors.dart';
import 'package:give_job/shared/loader_widget.dart';
import 'package:give_job/shared/month_util.dart';
import 'package:give_job/shared/toastr_service.dart';
import 'package:give_job/shared/validator_service.dart';

import '../../main.dart';
import '../../shared/constants.dart';
import '../manager_side_bar.dart';

class ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage
    extends StatefulWidget {
  final String _managerId;
  final String _managerInfo;
  final String _authHeader;

  final String _employeeInfo;
  final EmployeeTimeSheetDto timeSheet;

  const ManagerGroupsDetailsTimeSheetsWorkdaysInProgressPage(this._managerId,
      this._managerInfo, this._authHeader, this._employeeInfo, this.timeSheet);

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
            return loaderWidget(
              context,
              getTranslated(context, 'loading'),
              managerSideBar(context, widget._managerId, widget._managerInfo,
                  widget._authHeader),
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
                  primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
              home: Scaffold(
                backgroundColor: DARK,
                appBar: appBar(context, getTranslated(context, 'workdays')),
                drawer: managerSideBar(context, widget._managerId,
                    widget._managerInfo, widget._authHeader),
                body: RefreshIndicator(
                  key: refreshIndicatorState,
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget._employeeInfo != null
                                ? utf8
                                    .decode(widget._employeeInfo.runes.toList())
                                : getTranslated(context, 'empty'),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
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
                                  ? Color(0xffb5d76d)
                                  : Colors.orange,
                            ),
                            title: Text(
                              widget.timeSheet.year.toString() +
                                  ' ' +
                                  MonthUtil.translateMonth(
                                      context, widget.timeSheet.month) +
                                  '\n' +
                                  utf8.decode(
                                    widget.timeSheet.groupName.runes.toList(),
                                  ),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Wrap(
                              children: <Widget>[
                                Text(
                                  getTranslated(context, 'hoursWorked') +
                                      ': ' +
                                      widget.timeSheet.totalHours.toString() +
                                      'h',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  getTranslated(context, 'averageRating') +
                                      ': ' +
                                      widget.timeSheet.averageEmployeeRating
                                          .toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            trailing: Wrap(
                              children: <Widget>[
                                Text(
                                  widget.timeSheet.totalMoneyEarned.toString(),
                                  style: TextStyle(
                                      color: GREEN,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " ZŁ",
                                  style: TextStyle(
                                      color: GREEN,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton.icon(
                                    color: GREEN,
                                    label: Text(
                                      getTranslated(context, 'hours'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showDialog('HOURS', selectedIds);
                                    },
                                  ),
                                  RaisedButton.icon(
                                    color: GREEN,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    label: Text(
                                      getTranslated(context, 'rating'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showDialog('RATING', selectedIds);
                                    },
                                  ),
                                  RaisedButton.icon(
                                    color: GREEN,
                                    label: Text(
                                      getTranslated(context, 'comment'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _showDialog('COMMENT', selectedIds);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                sortAscending: sort,
                                sortColumnIndex: 0,
                                columns: [
                                  DataColumn(
                                      label: Text(
                                        'No.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onSort: (columnIndex, ascending) {
                                        setState(() {
                                          sort = !sort;
                                        });
                                        onSortColum(columnIndex, ascending);
                                      }),
                                  DataColumn(
                                    label: Text(
                                      getTranslated(context, 'hours'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      getTranslated(context, 'rating'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      getTranslated(context, 'money'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      getTranslated(context, 'comment'),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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
                                          DataCell(
                                            Text(
                                              workday.number.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              workday.hours.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              workday.rating.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              workday.money.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DataCell(
                                            Wrap(
                                              children: <Widget>[
                                                Text(
                                                  workday.comment != null
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
                                                          context, 'empty'),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                workday.comment != null &&
                                                        workday.comment != ''
                                                    ? Icon(
                                                        Icons.zoom_in,
                                                        color: Colors.white,
                                                      )
                                                    : Text('')
                                              ],
                                            ),
                                            onTap: () {
                                              _showCommentDetails(
                                                  workday.comment);
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
        theme: ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
        home: Scaffold(
          backgroundColor: DARK,
          appBar: appBar(context, getTranslated(context, 'workdays')),
          drawer: managerSideBar(context, widget._managerId,
              widget._managerInfo, widget._authHeader),
          body: RefreshIndicator(
            key: refreshIndicatorState,
            onRefresh: _refresh,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget._employeeInfo != null
                          ? utf8.decode(widget._employeeInfo.runes.toList())
                          : getTranslated(context, 'empty'),
                      style: TextStyle(
                        color: Colors.white,
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
                            ? Color(0xffb5d76d)
                            : Colors.orange,
                      ),
                      title: Text(
                        widget.timeSheet.year.toString() +
                            ' ' +
                            MonthUtil.translateMonth(
                                context, widget.timeSheet.month) +
                            '\n' +
                            utf8.decode(
                              widget.timeSheet.groupName.runes.toList(),
                            ),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Wrap(
                        children: <Widget>[
                          Text(
                            getTranslated(context, 'hoursWorked') +
                                ': ' +
                                widget.timeSheet.totalHours.toString() +
                                'h',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            getTranslated(context, 'averageRating') +
                                ': ' +
                                widget.timeSheet.averageEmployeeRating
                                    .toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          Text(
                            widget.timeSheet.totalMoneyEarned.toString(),
                            style: TextStyle(
                                color: GREEN,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " ZŁ",
                            style: TextStyle(
                                color: GREEN,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton.icon(
                              color: GREEN,
                              label: Text(
                                getTranslated(context, 'hours'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showDialog('HOURS', selectedIds);
                              },
                            ),
                            RaisedButton.icon(
                              color: GREEN,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              label: Text(
                                getTranslated(context, 'rating'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showDialog('RATING', selectedIds);
                              },
                            ),
                            RaisedButton.icon(
                              color: GREEN,
                              label: Text(
                                getTranslated(context, 'comment'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _showDialog('COMMENT', selectedIds);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortAscending: sort,
                          sortColumnIndex: 0,
                          columns: [
                            DataColumn(
                                label: Text(
                                  'No.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    sort = !sort;
                                  });
                                  onSortColum(columnIndex, ascending);
                                }),
                            DataColumn(
                              label: Text(
                                getTranslated(context, 'hours'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                getTranslated(context, 'rating'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                getTranslated(context, 'money'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                getTranslated(context, 'comment'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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
                                      Text(
                                        workday.number.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        workday.hours.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        workday.rating.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        workday.money.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DataCell(
                                      Wrap(
                                        children: <Widget>[
                                          Text(
                                            workday.comment != null
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
                                                    context, 'empty'),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          workday.comment != null &&
                                                  workday.comment != ''
                                              ? Icon(
                                                  Icons.zoom_in,
                                                  color: Colors.white,
                                                )
                                              : Text('')
                                        ],
                                      ),
                                      onTap: () {
                                        _showCommentDetails(workday.comment);
                                      },
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<Null> _refresh() {
    return _managerService
        .findWorkdaysByTimeSheetId(
            widget.timeSheet.id.toString(), widget._authHeader)
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
          title: Text(
            getTranslated(context, 'commentDetails'),
            style: TextStyle(color: DARK, fontWeight: FontWeight.bold),
          ),
          content: Text(
            comment != null
                ? utf8.decode(comment.runes.toList())
                : getTranslated(context, 'empty'),
            style: TextStyle(color: DARK),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                getTranslated(context, 'close'),
                style: TextStyle(color: DARK),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(String content, Set<int> selectedIds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (content == 'HOURS') {
          final hoursController = new TextEditingController();
          TextFormField field = TextFormField(
            controller: hoursController,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 2,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: DARK),
              labelText: getTranslated(context, 'newHours') + ' (0-24)',
            ),
          );
          return AlertDialog(
            title: Text(
              getTranslated(context, 'updatingHours'),
              style: TextStyle(color: DARK),
            ),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  getTranslated(context, 'update'),
                  style: TextStyle(color: DARK),
                ),
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
                          selectedIds, hours, widget._authHeader)
                      .then((res) {
                    Navigator.of(context).pop();
                    ToastService.showToast(
                        getTranslated(context, 'hoursUpdatedSuccessfully'),
                        Color(0xffb5d76d));
                    _refresh();
                  });
                },
              ),
              FlatButton(
                child: Text(
                  getTranslated(context, 'close'),
                  style: TextStyle(color: DARK),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        } else if (content == 'RATING') {
          final ratingController = new TextEditingController();
          TextFormField field = TextFormField(
            controller: ratingController,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: DARK),
              labelText: getTranslated(context, 'newRating') + ' (1-5)',
            ),
          );
          return AlertDialog(
            title: Text(getTranslated(context, 'updatingRating')),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  getTranslated(context, 'update'),
                  style: TextStyle(color: DARK),
                ),
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
                          selectedIds, hours, widget._authHeader)
                      .then((res) {
                    Navigator.of(context).pop();
                    ToastService.showToast(
                        getTranslated(context, 'ratingUpdatedSuccessfully'),
                        Color(0xffb5d76d));
                    _refresh();
                  });
                },
              ),
              FlatButton(
                child: Text(
                  getTranslated(context, 'close'),
                  style: TextStyle(color: DARK),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
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
            decoration: InputDecoration(
              labelStyle: TextStyle(color: DARK),
              labelText: getTranslated(context, 'newComment'),
            ),
          );
          return AlertDialog(
            title: Text(
              getTranslated(context, 'updatingComment'),
              style: TextStyle(color: DARK, fontWeight: FontWeight.bold),
            ),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  getTranslated(context, 'update'),
                  style: TextStyle(color: DARK),
                ),
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
                          selectedIds, comment, widget._authHeader)
                      .then((res) {
                    Navigator.of(context).pop();
                    ToastService.showToast(
                        getTranslated(context, 'commentUpdatedSuccessfully'),
                        Color(0xffb5d76d));
                    _refresh();
                  });
                },
              ),
              FlatButton(
                child: Text(
                  getTranslated(context, 'close'),
                  style: TextStyle(color: DARK),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      },
    );
  }
}
