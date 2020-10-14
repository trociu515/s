import 'dart:collection';
import 'dart:convert';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_timesheet_with_no_status_dto.dart';
import 'package:give_job/manager/dto/manager_vocations_ts_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/manager/shimmer/shimmer_manager_in_progress_ts_details.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:intl/intl.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

import '../../../../../manager_app_bar.dart';
import '../../../../../manager_side_bar.dart';

class ManagerVocationsManagePage extends StatefulWidget {
  final GroupEmployeeModel _model;
  final ManagerGroupTimesheetWithNoStatusDto _timeSheet;

  ManagerVocationsManagePage(this._model, this._timeSheet);

  @override
  _ManagerVocationsManagePageState createState() =>
      _ManagerVocationsManagePageState();
}

class _ManagerVocationsManagePageState
    extends State<ManagerVocationsManagePage> {
  GroupEmployeeModel _model;
  ManagerService _managerService;
  ManagerGroupTimesheetWithNoStatusDto _timesheet;

  List<ManagerVocationsTsDto> _employees = new List();
  List<ManagerVocationsTsDto> _filteredEmployees = new List();
  bool _loading = false;
  bool _isChecked = false;
  List<bool> _checked = new List();
  LinkedHashSet<int> _selectedIds = new LinkedHashSet();

  final TextEditingController _reasonController = new TextEditingController();

  @override
  void initState() {
    this._model = widget._model;
    this._managerService = new ManagerService(context, _model.user.authHeader);
    this._timesheet = widget._timeSheet;
    super.initState();
    _loading = true;
    _managerService
        .findAllForVocationsTsByGroupIdAndTimesheetYearMonthStatusForMobile(
            _model.groupId,
            _timesheet.year,
            MonthUtil.findMonthNumberByMonthName(context, _timesheet.month),
            STATUS_IN_PROGRESS)
        .then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return shimmerManagerInProgressTsDetails(this.context, _model.user);
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(context, _model.user,
            getTranslated(context, 'manageEmployeesVocations')),
        drawer: managerSideBar(context, _model.user),
        body: RefreshIndicator(
          color: DARK,
          backgroundColor: WHITE,
          onRefresh: _refresh,
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: textCenter20White(_timesheet.year.toString() +
                        ' ' +
                        MonthUtil.translateMonth(context, _timesheet.month) +
                        ' - ' +
                        getTranslated(context, 'vocations')),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: textCenter14Green(getTranslated(
                        context, 'hintSelectEmployeesAndDatesOfVocations')),
                  ),
                ],
              ),
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
                      labelText: getTranslated(this.context, 'search'),
                      prefixIcon: iconWhite(Icons.search),
                      labelStyle: TextStyle(color: WHITE)),
                  onChanged: (string) {
                    setState(
                      () {
                        _filteredEmployees = _employees
                            .where((u) => (u.info
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
                  title: textWhite(
                      getTranslated(this.context, 'selectUnselectAll')),
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
                            .addAll(_filteredEmployees.map((e) => e.id));
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
                    ManagerVocationsTsDto employee = _filteredEmployees[index];
                    int foundIndex = 0;
                    for (int i = 0; i < _employees.length; i++) {
                      if (_employees[i].id == employee.id) {
                        foundIndex = i;
                      }
                    }
                    String info = employee.info;
                    String nationality = employee.nationality;
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
                                secondary: Padding(
                                  padding: EdgeInsets.all(4),
                                ),
                                title: text20WhiteBold(
                                    utf8.decode(info.runes.toList()) +
                                        ' ' +
                                        LanguageUtil.findFlagByNationality(
                                            nationality)),
                                activeColor: GREEN,
                                checkColor: WHITE,
                                value: _checked[foundIndex],
                                onChanged: (bool value) {
                                  setState(() {
                                    _checked[foundIndex] = value;
                                    if (value) {
                                      _selectedIds
                                          .add(_employees[foundIndex].id);
                                    } else {
                                      _selectedIds
                                          .remove(_employees[foundIndex].id);
                                    }
                                    int selectedIdsLength = _selectedIds.length;
                                    if (selectedIdsLength ==
                                        _employees.length) {
                                      _isChecked = true;
                                    } else if (selectedIdsLength == 0) {
                                      _isChecked = false;
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
                  child: textDarkBold(getTranslated(context, 'manage')),
                  onPressed: () => {
                    if (_selectedIds.isNotEmpty)
                      {
                        _manageVocations(),
                      }
                    else
                      {_showHint(getTranslated(context, 'manageLowerCase'))}
                  },
                ),
              ),
              SizedBox(width: 1),
              Expanded(
                  child: MaterialButton(
                color: Colors.red,
                child: textWhiteBold(getTranslated(context, 'remove')),
                onPressed: () => {
                  if (_selectedIds.isNotEmpty)
                    {
                      _removeVocations(),
                    }
                  else
                    {_showHint(getTranslated(context, 'removeLowerCase'))}
                },
              )),
              SizedBox(width: 1),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }

  void _manageVocations() async {
    int year = _timesheet.year;
    int monthNum =
        MonthUtil.findMonthNumberByMonthName(context, _timesheet.month);
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
      showGeneralDialog(
        context: context,
        barrierColor: DARK.withOpacity(0.95),
        barrierDismissible: false,
        barrierLabel: getTranslated(context, 'reason'),
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) {
          return SizedBox.expand(
            child: Scaffold(
              backgroundColor: Colors.black12,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: text20GreenBold(
                            getTranslated(context, 'reasonUpperCase'))),
                    SizedBox(height: 2.5),
                    textGreen(
                        getTranslated(context, 'vocationForSelectedEmployees')),
                    SizedBox(height: 2.5),
                    textGreenBold('[' + dateFrom + ' - ' + dateTo + ']'),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: TextFormField(
                        autofocus: true,
                        controller: _reasonController,
                        keyboardType: TextInputType.multiline,
                        maxLength: 510,
                        maxLines: 5,
                        cursorColor: WHITE,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(color: WHITE),
                        decoration: InputDecoration(
                          hintText: getTranslated(context, 'textSomeReason'),
                          hintStyle: TextStyle(color: MORE_BRIGHTER_DARK),
                          counterStyle: TextStyle(color: WHITE),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: GREEN, width: 2.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: GREEN, width: 2.5),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        MaterialButton(
                          elevation: 0,
                          height: 50,
                          minWidth: 40,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[iconWhite(Icons.close)],
                          ),
                          color: Colors.red,
                          onPressed: () => Navigator.pop(context),
                        ),
                        SizedBox(width: 25),
                        MaterialButton(
                          elevation: 0,
                          height: 50,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[iconWhite(Icons.check)],
                          ),
                          color: GREEN,
                          onPressed: () {
                            String reason = _reasonController.text;
                            String invalidMessage =
                                ValidatorService.validateVocationReason(
                                    reason, context);
                            if (invalidMessage != null) {
                              ToastService.showErrorToast(invalidMessage);
                              return;
                            }
                            _managerService
                                .createOrUpdateVocation(
                                    reason,
                                    dateFrom,
                                    dateTo,
                                    _selectedIds,
                                    year,
                                    monthNum,
                                    STATUS_IN_PROGRESS)
                                .then(
                              (res) {
                                _uncheckAll();
                                _refresh();
                                Navigator.of(context).pop();
                                ToastService.showSuccessToast(getTranslated(
                                    context, 'vocationManagedSuccessfully'));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _removeVocations() async {
    int year = _timesheet.year;
    int monthNum =
        MonthUtil.findMonthNumberByMonthName(context, _timesheet.month);
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: DARK,
            title: textRed(getTranslated(context, 'removeVocations')),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  textCenterWhite(
                      getTranslated(context, 'areYouSureYouWantToRemove')),
                  SizedBox(height: 2),
                  textCenterWhite(
                      getTranslated(context, "vocationsForSelectedEmployees")),
                  SizedBox(height: 2),
                  textCenterWhite(getTranslated(context, 'from') +
                      dateFrom +
                      getTranslated(context, 'to') +
                      dateTo +
                      '?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: textRed(getTranslated(context, 'removeConfirmation')),
                onPressed: () => {
                  _managerService
                      .removeEmployeesVocations(
                          dateFrom,
                          dateTo,
                          _selectedIds,
                          _timesheet.year,
                          MonthUtil.findMonthNumberByMonthName(
                              context, _timesheet.month),
                          STATUS_IN_PROGRESS)
                      .then(
                    (res) {
                      _uncheckAll();
                      _refresh();
                      Navigator.of(context).pop();
                      ToastService.showSuccessToast(getTranslated(
                          context, 'vocationsRemovedSuccessfully'));
                    },
                  ),
                },
              ),
              FlatButton(
                child: textGreen(getTranslated(context, 'no')),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
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

  void _showHint(String operationName) {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold(getTranslated(context, 'hint')),
            SizedBox(height: 10),
            textCenter20White(
                getTranslated(context, 'needToSelectEmployeesToBe')),
            textCenter20White(getTranslated(context, 'ableTo') +
                ' ' +
                operationName +
                ' ' +
                getTranslated(context, 'vocationsForThem')),
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() {
    return _managerService
        .findAllForVocationsTsByGroupIdAndTimesheetYearMonthStatusForMobile(
            _model.groupId,
            _timesheet.year,
            MonthUtil.findMonthNumberByMonthName(context, _timesheet.month),
            STATUS_IN_PROGRESS)
        .then((res) {
      setState(() {
        _employees = res;
        _employees.forEach((e) => _checked.add(false));
        _filteredEmployees = _employees;
        _loading = false;
      });
    });
  }
}
