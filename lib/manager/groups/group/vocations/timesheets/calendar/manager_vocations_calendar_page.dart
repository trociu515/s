//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_employee_vocation_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/manager/service/manager_vocation_service.dart';
import 'package:give_job/manager/shimmer/shimmer_manager_group_vocations_calendar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:intl/intl.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:table_calendar/table_calendar.dart';

import '../../../../../manager_app_bar.dart';
import '../../../../../manager_side_bar.dart';

class ManagerVocationsCalendarPage extends StatefulWidget {
  ManagerVocationsCalendarPage({Key key}) : super(key: key);

  GroupEmployeeModel _model;

  set model(GroupEmployeeModel value) {
    _model = value;
  }

  @override
  _ManagerVocationsCalendarPageState createState() =>
      _ManagerVocationsCalendarPageState();
}

class _ManagerVocationsCalendarPageState
    extends State<ManagerVocationsCalendarPage> with TickerProviderStateMixin {
  GroupEmployeeModel _model;
  ManagerService _service = new ManagerService();
  ManagerVocationService _vocationService = new ManagerVocationService();

  Map<DateTime, List<ManagerGroupEmployeeVocationDto>> _events = new Map();
  List _selectedEvents;
  DateTime _selectedDay;
  AnimationController _animationController;
  CalendarController _calendarController = new CalendarController();

  bool _loading;

  @override
  void initState() {
    super.initState();
    this._model = widget._model;
    super.initState();
    _loading = true;
    _service
        .findTimesheetsWithVocationsByGroupId(
            _model.groupId.toString(), _model.user.authHeader)
        .then((res) {
      setState(() {
        _loading = false;
        res.forEach((key, value) {
          _events[key] = value;
        });
        DateTime currentDate =
            DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
        _selectedEvents = _events[currentDate] ?? [];
        _animationController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        );
        _animationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
      _selectedDay = day;
    });
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    DateTime currentDate = DateTime.now();
    bool vocationsInCurrentMonth = _events.keys.any((element) =>
        element.year == currentDate.year && element.month == currentDate.month);
    if (vocationsInCurrentMonth) {
      ToastService.showToast(
          'There are some planned vocations in current month!');
    } else {
      ToastService.showToast('There are NO vocations for the current month!');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return shimmerManagerGroupVocationsCalendar(this.context, _model.user);
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(context, _model.user, 'Vocations calendar'),
        drawer: managerSideBar(context, _model.user),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendarWithBuilders(),
            //const SizedBox(height: 8.0),
            //_buildButtons(),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_EN',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        selectedStyle: TextStyle().copyWith(color: WHITE),
        weekendStyle: TextStyle().copyWith(color: Colors.red),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.red),
      ),
      headerStyle:
          HeaderStyle(centerHeaderTitle: true, formatButtonVisible: false),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: WHITE,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: GREEN,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    bool isAnyVocationNotVerified = events.any((element) => !element.verified);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: isAnyVocationNotVerified ? Colors.red : GREEN,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: ListTile(
                title: event.verified
                    ? _buildVerifiedWidget(event)
                    : _buildNotVerifiedWidget(event),
                onTap: () => _showVocationReason(event),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildVerifiedWidget(ManagerGroupEmployeeVocationDto vocation) {
    return ListTile(
      title: text20WhiteBold(utf8.decode(vocation.employeeInfo.runes.toList()) +
          ' ' +
          LanguageUtil.findFlagByNationality(vocation.employeeNationality)),
      leading: iconGreen(Icons.check),
      subtitle: text16GreenBold('Vocations are VERIFIED!'),
    );
  }

  Widget _buildNotVerifiedWidget(ManagerGroupEmployeeVocationDto vocation) {
    return ListTile(
      title: text20WhiteBold(utf8.decode(vocation.employeeInfo.runes.toList()) +
          ' ' +
          LanguageUtil.findFlagByNationality(vocation.employeeNationality)),
      leading: iconRed(Icons.cancel),
      subtitle: text16RedBold('Vocations are NOT VERIFIED!'),
    );
  }

  void _showVocationReason(ManagerGroupEmployeeVocationDto vocation) {
    String employeeInfo = utf8.decode(vocation.employeeInfo.runes.toList()) +
        ' ' +
        LanguageUtil.findFlagByNationality(vocation.employeeNationality);
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20WhiteBold(employeeInfo),
            SizedBox(height: 10),
            vocation.verified
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      text16GreenBold('Vocations are VERIFIED!'),
                      iconGreen(Icons.check),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          text16RedBold('Vocations are NOT VERIFIED!'),
                          SizedBox(width: 2),
                          iconRed(Icons.cancel),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildVerifyButton(employeeInfo, vocation.id),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 10),
            text20GreenBold(getTranslated(context, 'vocationReason')),
            SizedBox(height: 10),
            textCenter20White(vocation.reason != null
                ? utf8.decode(vocation.reason.runes.toList())
                : getTranslated(context, 'empty')),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyButton(String employeeInfo, int vocationId) {
    return MaterialButton(
      color: GREEN,
      child: textDarkBold('TAP TO VERIFY'),
      onPressed: () => _showConfirmationDialog(
          'Confirmation',
          'Are you sure u want to verify',
          _selectedDay.toString().substring(0, 10) + ' vocation day for',
          employeeInfo,
          () => verifyVocation(vocationId)),
    );
  }

  void _showConfirmationDialog(String title, String firstContent,
      String secondContent, String employeeInfo, Function() fun) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreenBold(title),
          content: SingleChildScrollView(
            child: Column(
              children: [
                textCenterWhite(firstContent),
                SizedBox(height: 2),
                textCenterWhite(secondContent),
                SizedBox(height: 2),
                textCenterWhite(employeeInfo + '?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textGreen('Yes, I want to verify'),
              onPressed: () => fun(),
            ),
            FlatButton(
                child: textRed(getTranslated(context, 'no')),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  void verifyVocation(int vocationId) {
    _vocationService
        .updateVocationVerification(vocationId, true, _model.user.authHeader)
        .then(
          (value) => {
            _refresh(),
            Navigator.of(context).pop(),
            ToastService.showSuccessToast('Vocation verified successfully!'),
          },
        );
  }

  Future<Null> _refresh() {
    return _service
        .findTimesheetsWithVocationsByGroupId(
            _model.groupId.toString(), _model.user.authHeader)
        .then((res) {
      setState(() {
        _loading = false;
        res.forEach((key, value) {
          _events[key] = value;
        });
        DateTime currentDate =
            DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
        _selectedEvents = _events[currentDate] ?? [];
        _animationController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        );
        _animationController.forward();
      });
    });
  }
}
