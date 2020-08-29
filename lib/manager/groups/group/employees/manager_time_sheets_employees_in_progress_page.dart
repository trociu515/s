import 'dart:convert';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_employees_time_sheet_dto.dart';
import 'package:give_job/manager/dto/manager_group_time_sheet_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:intl/intl.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../../../main.dart';
import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';

class ManagerTimeSheetsEmployeesInProgressPage extends StatefulWidget {
  final GroupEmployeeModel _model;
  final ManagerGroupTimeSheetDto _timeSheet;

  ManagerTimeSheetsEmployeesInProgressPage(this._model, this._timeSheet);

  @override
  _ManagerTimeSheetsEmployeesInProgressPageState createState() =>
      _ManagerTimeSheetsEmployeesInProgressPageState();
}

class _ManagerTimeSheetsEmployeesInProgressPageState
    extends State<ManagerTimeSheetsEmployeesInProgressPage> {
  final ManagerService _managerService = new ManagerService();

  final TextEditingController _hoursController = new TextEditingController();
  final TextEditingController _ratingController = new TextEditingController();
  final TextEditingController _commentController = new TextEditingController();

  GroupEmployeeModel _model;
  ManagerGroupTimeSheetDto _timeSheet;

  List<ManagerGroupEmployeesTimeSheetDto> _employees = new List();
  List<ManagerGroupEmployeesTimeSheetDto> _filteredEmployees = new List();
  bool _loading = false;
  bool _isChecked = false;
  List<bool> _checked = new List();
  List<int> _selectedIds = new List();

  @override
  void initState() {
    this._model = widget._model;
    this._timeSheet = widget._timeSheet;
    super.initState();
    _loading = true;
    _managerService
        .findAllEmployeesOfTimeSheetByGroupIdAndTimeSheetYearMonthStatusForMobile(
            _model.groupId,
            _timeSheet.year,
            MonthUtil.findMonthNumberByMonthName(context, _timeSheet.month),
            _timeSheet.status,
            _model.user.authHeader)
        .then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _filteredEmployees = _employees;
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showBottomToast('Something went wrong', Colors.red);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(
        managerAppBar(context, null, getTranslated(context, 'loading')),
        managerSideBar(context, _model.user),
      );
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(
            context,
            _model.user,
            _timeSheet.year.toString() +
                ' ' +
                MonthUtil.translateMonth(context, _timeSheet.month) +
                ' - ' +
                _timeSheet.status),
        drawer: managerSideBar(context, _model.user),
        body: RefreshIndicator(
          color: DARK,
          backgroundColor: WHITE,
          key: refreshIndicatorState,
          onRefresh: _refresh,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  autofocus: false,
                  autocorrect: true,
                  cursorColor: WHITE,
                  style: TextStyle(color: WHITE),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: WHITE, width: 2)),
                      counterStyle: TextStyle(color: WHITE),
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      prefixIcon: iconWhite(Icons.search),
                      labelStyle: TextStyle(color: WHITE)),
                  onChanged: (string) {
                    setState(
                      () {
                        _filteredEmployees = _employees
                            .where((u) => (u.employeeInfo
                                .toLowerCase()
                                .contains(string.toLowerCase())))
                            .toList();
                      },
                    );
                  },
                ),
              ),
              ListTileTheme(
                contentPadding: EdgeInsets.only(left: 3),
                child: CheckboxListTile(
                  title: textWhite('Select / Unselect all'),
                  value: _isChecked,
                  activeColor: GREEN,
                  checkColor: WHITE,
                  onChanged: (bool value) {
                    setState(() {
                      _isChecked = value;
                      List<bool> l = new List();
                      _checked.forEach((b) => l.add(value));
                      _checked = l;
                      if (value) {
                        _selectedIds
                            .addAll(_employees.map((e) => e.employeeId));
                      } else
                        _selectedIds.clear();
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredEmployees.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: DARK,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            color: BRIGHTER_DARK,
                            child: ListTileTheme(
                              contentPadding: EdgeInsets.only(right: 10),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                secondary: Image(
                                  image: AssetImage(
                                    'images/group-img.png', // TODO replace img
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                title: text20WhiteBold(utf8.decode(
                                        _filteredEmployees[index]
                                            .employeeInfo
                                            .runes
                                            .toList()) +
                                    ' ' +
                                    LanguageUtil.findFlagByNationality(
                                        _filteredEmployees[index]
                                            .employeeNationality)),
                                subtitle: Column(
                                  children: <Widget>[
                                    Align(
                                        child: Row(
                                          children: <Widget>[
                                            textWhite(getTranslated(
                                                    this.context,
                                                    'moneyPerHour') +
                                                ': '),
                                            textGreenBold(_employees[index]
                                                    .moneyPerHour
                                                    .toString() +
                                                ' ' +
                                                _employees[index].currency),
                                          ],
                                        ),
                                        alignment: Alignment.topLeft),
                                    Align(
                                        child: Row(
                                          children: <Widget>[
                                            textWhite(getTranslated(
                                                    this.context,
                                                    'averageRating') +
                                                ': '),
                                            textGreenBold(_employees[index]
                                                .averageEmployeeRating
                                                .toString()),
                                          ],
                                        ),
                                        alignment: Alignment.topLeft),
                                    Align(
                                        child: Row(
                                          children: <Widget>[
                                            textWhite(getTranslated(
                                                    this.context,
                                                    'numberOfHoursWorked') +
                                                ': '),
                                            textGreenBold(_employees[index]
                                                .numberOfHoursWorked
                                                .toString()),
                                          ],
                                        ),
                                        alignment: Alignment.topLeft),
                                    Align(
                                        child: Row(
                                          children: <Widget>[
                                            textWhite(getTranslated(
                                                    this.context,
                                                    'amountOfEarnedMoney') +
                                                ': '),
                                            textGreenBold(_employees[index]
                                                    .amountOfEarnedMoney
                                                    .toString() +
                                                ' ' +
                                                _employees[index].currency),
                                          ],
                                        ),
                                        alignment: Alignment.topLeft),
                                  ],
                                ),
                                activeColor: GREEN,
                                checkColor: WHITE,
                                value: _checked[index],
                                onChanged: (bool value) {
                                  setState(() {
                                    _checked[index] = value;
                                    if (value) {
                                      _selectedIds
                                          .add(_employees[index].employeeId);
                                    } else {
                                      _selectedIds
                                          .remove(_employees[index].employeeId);
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
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
                  onPressed: () => {
                    if (_selectedIds.isNotEmpty)
                      {
                        _hoursController.clear(),
                        _showUpdateHoursDialog(_selectedIds)
                      }
                    else
                      {_showHint()}
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: textDarkBold(getTranslated(context, 'rating')),
                  onPressed: () => {
                    if (_selectedIds.isNotEmpty)
                      {
                        _hoursController.clear(),
                        _showUpdateRatingDialog(_selectedIds)
                      }
                    else
                      {_showHint()}
                  },
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: MaterialButton(
                  color: GREEN,
                  child: textDarkBold(getTranslated(context, 'comment')),
                  onPressed: () => {
                    if (_selectedIds.isNotEmpty)
                      {
                        _hoursController.clear(),
                        _showUpdateCommentDialog(_selectedIds)
                      }
                    else
                      {_showHint()}
                  },
                ),
              ),
              SizedBox(width: 1),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }

  void _showUpdateHoursDialog(List<int> selectedIds) async {
    int year = _timeSheet.year;
    int monthNum =
        MonthUtil.findMonthNumberByMonthName(context, _timeSheet.month);
    int days = DateUtil().daysInMonth(monthNum, year);
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime(year, monthNum, 1),
        initialLastDate: new DateTime(year, monthNum, days),
        firstDate: new DateTime(year, monthNum, 1),
        lastDate: new DateTime(year, monthNum, days));
    if (picked != null && picked.length == 2) {
      String dateFrom = DateFormat('yyyy-MM-dd').format(picked[0]);
      String dateTo = DateFormat('yyyy-MM-dd').format(picked[1]);
      slideDialog.showSlideDialog(
        context: context,
        barrierDismissible: false,
        backgroundColor: DARK,
        child: Column(
          children: <Widget>[
            text20GreenBold('HOURS'),
            SizedBox(height: 2.5),
            textGreenBold('[' + dateFrom + ' - ' + dateTo + ']'),
            SizedBox(height: 2.5),
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
                  labelText: getTranslated(context, 'newHours') + ' (0-24)',
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  elevation: 0,
                  height: 40,
                  minWidth: 40,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text18White(getTranslated(context, 'close')),
                      iconWhite(Icons.close)
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 15),
                MaterialButton(
                  elevation: 0,
                  height: 40,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text18White(getTranslated(context, 'update')),
                      iconWhite(Icons.check)
                    ],
                  ),
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
                        ValidatorService.validateUpdatingHours(hours, context);
                    if (invalidMessage != null) {
                      ToastService.showBottomToast(invalidMessage, Colors.red);
                      return;
                    }
                    _managerService
                        .updateEmployeesHours(
                            hours,
                            dateFrom,
                            dateTo,
                            _selectedIds,
                            year,
                            monthNum,
                            _timeSheet.status,
                            _model.user.authHeader)
                        .then(
                      (res) {
                        _uncheckAll();
                        _refresh();
                        Navigator.of(context).pop();
                        ToastService.showCenterToast(
                            getTranslated(context, 'hoursUpdatedSuccessfully'),
                            GREEN);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _showUpdateRatingDialog(List<int> selectedIds) async {
    int year = _timeSheet.year;
    int monthNum =
        MonthUtil.findMonthNumberByMonthName(context, _timeSheet.month);
    int days = DateUtil().daysInMonth(monthNum, year);
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime(year, monthNum, 1),
        initialLastDate: new DateTime(year, monthNum, days),
        firstDate: new DateTime(year, monthNum, 1),
        lastDate: new DateTime(year, monthNum, days));
    if (picked != null && picked.length == 2) {
      String dateFrom = DateFormat('yyyy-MM-dd').format(picked[0]);
      String dateTo = DateFormat('yyyy-MM-dd').format(picked[1]);
      slideDialog.showSlideDialog(
        context: context,
        barrierDismissible: false,
        backgroundColor: DARK,
        child: Column(
          children: <Widget>[
            text20GreenBold('RATING'),
            SizedBox(height: 2.5),
            textGreenBold('[' + dateFrom + ' - ' + dateTo + ']'),
            SizedBox(height: 2.5),
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
                  labelText: getTranslated(context, 'newRating') + ' (1-10)',
                ),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  elevation: 0,
                  height: 40,
                  minWidth: 40,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text18White(getTranslated(context, 'close')),
                      iconWhite(Icons.close)
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 15),
                MaterialButton(
                  elevation: 0,
                  height: 40,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text18White(getTranslated(context, 'update')),
                      iconWhite(Icons.check)
                    ],
                  ),
                  color: GREEN,
                  onPressed: () {
                    int rating;
                    try {
                      rating = int.parse(_ratingController.text);
                    } catch (FormatException) {
                      ToastService.showBottomToast(
                          getTranslated(context, 'givenValueIsNotANumber'),
                          Colors.red);
                      return;
                    }
                    String invalidMessage =
                        ValidatorService.validateUpdatingRating(
                            rating, context);
                    if (invalidMessage != null) {
                      ToastService.showBottomToast(invalidMessage, Colors.red);
                      return;
                    }
                    _managerService
                        .updateEmployeesRating(
                            rating,
                            dateFrom,
                            dateTo,
                            _selectedIds,
                            year,
                            monthNum,
                            _timeSheet.status,
                            _model.user.authHeader)
                        .then(
                      (res) {
                        _uncheckAll();
                        _refresh();
                        Navigator.of(context).pop();
                        ToastService.showCenterToast(
                            getTranslated(context, 'ratingUpdatedSuccessfully'),
                            GREEN);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _showUpdateCommentDialog(List<int> selectedIds) async {
    int year = _timeSheet.year;
    int monthNum =
        MonthUtil.findMonthNumberByMonthName(context, _timeSheet.month);
    int days = DateUtil().daysInMonth(monthNum, year);
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime(year, monthNum, 1),
        initialLastDate: new DateTime(year, monthNum, days),
        firstDate: new DateTime(year, monthNum, 1),
        lastDate: new DateTime(year, monthNum, days));
    if (picked.length == 1) {
      picked.add(picked[0]);
    }
    if (picked != null && picked.length == 2) {
      String dateFrom = DateFormat('yyyy-MM-dd').format(picked[0]);
      String dateTo = DateFormat('yyyy-MM-dd').format(picked[1]);
      slideDialog.showSlideDialog(
        context: context,
        barrierDismissible: false,
        backgroundColor: DARK,
        child: Column(
          children: <Widget>[
            text20GreenBold('COMMENT'),
            SizedBox(height: 2.5),
            textGreenBold('[' + dateFrom + ' - ' + dateTo + ']'),
            SizedBox(height: 2.5),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  elevation: 0,
                  height: 40,
                  minWidth: 40,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text18White(getTranslated(context, 'close')),
                      iconWhite(Icons.close)
                    ],
                  ),
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 15),
                MaterialButton(
                  elevation: 0,
                  height: 40,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      text18White(getTranslated(context, 'update')),
                      iconWhite(Icons.check)
                    ],
                  ),
                  color: GREEN,
                  onPressed: () {
                    String comment = _commentController.text;
                    String invalidMessage =
                        ValidatorService.validateUpdatingComment(
                            comment, context);
                    if (invalidMessage != null) {
                      ToastService.showBottomToast(invalidMessage, Colors.red);
                      return;
                    }
                    _managerService
                        .updateEmployeesComment(
                            comment,
                            dateFrom,
                            dateTo,
                            _selectedIds,
                            year,
                            monthNum,
                            _timeSheet.status,
                            _model.user.authHeader)
                        .then(
                      (res) {
                        _uncheckAll();
                        _refresh();
                        Navigator.of(context).pop();
                        ToastService.showCenterToast(
                            getTranslated(
                                context, 'commentUpdatedSuccessfully'),
                            GREEN);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  void _uncheckAll() {
    _selectedIds.clear();
    _isChecked = false;
    List<bool> l = new List();
    _checked.forEach((b) => l.add(false));
    _checked = l;
  }

  void _showHint() {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Hint'),
            SizedBox(height: 10),
            text20White('You need to select records '),
            text20White('which you want to update.'),
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() {
    return _managerService
        .findAllEmployeesOfTimeSheetByGroupIdAndTimeSheetYearMonthStatusForMobile(
            _model.groupId,
            _timeSheet.year,
            MonthUtil.findMonthNumberByMonthName(context, _timeSheet.month),
            _timeSheet.status,
            _model.user.authHeader)
        .then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _filteredEmployees = _employees;
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showBottomToast('Something went wrong', Colors.red);
      Navigator.pop(context);
    });
  }
}
