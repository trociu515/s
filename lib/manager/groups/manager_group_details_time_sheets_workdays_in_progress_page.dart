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
import 'package:give_job/shared/validator_service.dart';

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
            return Center(child: CircularProgressIndicator());
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
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton.icon(
                                  label: Text(getTranslated(context, 'hours')),
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showDialog('HOURS', selectedIds);
                                  },
                                ),
                                RaisedButton.icon(
                                  label: Text(getTranslated(context, 'rating')),
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showDialog('RATING', selectedIds);
                                  },
                                ),
                                RaisedButton.icon(
                                  label:
                                      Text(getTranslated(context, 'comment')),
                                  icon: Icon(Icons.edit),
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
                                    label: Text('No.'),
                                    onSort: (columnIndex, ascending) {
                                      setState(() {
                                        sort = !sort;
                                      });
                                      onSortColum(columnIndex, ascending);
                                    }),
                                DataColumn(
                                  label: Text(
                                    getTranslated(context, 'hours'),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    getTranslated(context, 'rating'),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    getTranslated(context, 'money'),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    getTranslated(context, 'comment'),
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
                                            Text(workday.number.toString())),
                                        DataCell(
                                            Text(workday.hours.toString())),
                                        DataCell(
                                            Text(workday.rating.toString())),
                                        DataCell(
                                            Text(workday.money.toString())),
                                        DataCell(Text(workday.comment != null
                                            ? utf8.decode(
                                                workday.comment.runes.toList())
                                            : getTranslated(context, 'empty'))),
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
            );
          }
        },
      );
    } else {
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
                        utf8.decode(widget.timeSheet.groupName.runes.toList())),
                    subtitle: Wrap(
                      children: <Widget>[
                        Text(getTranslated(context, 'hoursWorked') +
                            ': ' +
                            widget.timeSheet.totalHours.toString() +
                            'h'),
                        Text(getTranslated(context, 'averageRating') +
                            ': ' +
                            widget.timeSheet.averageEmployeeRating.toString()),
                      ],
                    ),
                    trailing: Wrap(
                      children: <Widget>[
                        Text(
                          widget.timeSheet.totalMoneyEarned.toString(),
                          style: TextStyle(color: Colors.green, fontSize: 20),
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
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton.icon(
                            label: Text(getTranslated(context, 'hours')),
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showDialog('HOURS', selectedIds);
                            },
                          ),
                          RaisedButton.icon(
                            label: Text(getTranslated(context, 'rating')),
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showDialog('RATING', selectedIds);
                            },
                          ),
                          RaisedButton.icon(
                            label: Text(getTranslated(context, 'comment')),
                            icon: Icon(Icons.edit),
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
                              label: Text('No.'),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  sort = !sort;
                                });
                                onSortColum(columnIndex, ascending);
                              }),
                          DataColumn(
                            label: Text(
                              getTranslated(context, 'hours'),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              getTranslated(context, 'rating'),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              getTranslated(context, 'money'),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              getTranslated(context, 'comment'),
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
      );
    }
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
              labelText: 'New hours (0-24)',
            ),
          );
          return AlertDialog(
            title: Text('Updating hours ...'),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                onPressed: () {
                  int hours;
                  try {
                    hours = int.parse(hoursController.text);
                  } catch (FormatException) {
                    ToastService.showToast(
                        'Given value is not a number', Colors.red);
                    return;
                  }
                  String invalidMessage =
                      ValidatorService.validateUpdatingHours(hours);
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
                        'Hours updated successfully', Colors.green);
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text('Close'),
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
              labelText: 'New rating (1-5)',
            ),
          );
          return AlertDialog(
            title: Text('Updating rating ...'),
            content: Row(
              children: <Widget>[
                Expanded(child: field),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                onPressed: () {
                  int hours;
                  try {
                    hours = int.parse(ratingController.text);
                  } catch (FormatException) {
                    ToastService.showToast(
                        'Given value is not a number', Colors.red);
                    return;
                  }
                  String invalidMessage =
                      ValidatorService.validateUpdatingRating(hours);
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
                        'Rating updated successfully', Colors.green);
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        } else {
          return AlertDialog(
            title: Text('Updating comment ...'),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    maxLength: 510,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'New comment',
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                onPressed: () {
                  print(selectedIds);
                },
              ),
              FlatButton(
                child: Text('Close'),
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
