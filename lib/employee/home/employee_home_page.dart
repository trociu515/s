import 'dart:convert';

import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/home/tabs/employee_info_tab.dart';
import 'package:give_job/employee/home/tabs/employee_time_sheets.tab.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../dto/employee_dto.dart';

class EmployeeHomePage extends StatefulWidget {
  final String _employeeId;
  final String _employeeInfo;
  final String _authHeader;

  EmployeeHomePage(this._employeeId, this._employeeInfo, this._authHeader);

  @override
  _EmployeeHomePageState createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  final EmployeeService _employeeService = new EmployeeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeDto>(
      future: _employeeService.findById(widget._employeeId, widget._authHeader),
      builder: (BuildContext context, AsyncSnapshot<EmployeeDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loader(
            context,
            getTranslated(context, 'loading'),
            employeeSideBar(context, widget._employeeId, widget._employeeInfo,
                widget._authHeader),
          );
        } else {
          EmployeeDto employee = snapshot.data;
          return WillPopScope(
              child: MaterialApp(
                title: APP_NAME,
                theme: ThemeData(
                    primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor: DARK,
                  appBar: appBar(context, getTranslated(context, 'home')),
                  drawer: employeeSideBar(context, widget._employeeId,
                      widget._employeeInfo, widget._authHeader),
                  body: Column(
                    children: <Widget>[
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [WHITE, GREEN])),
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image:
                                                AssetImage('images/logo.png'),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: text22DarkBold(utf8.decode(
                                            widget._employeeInfo != null
                                                ? widget._employeeInfo.runes
                                                    .toList()
                                                : '-')),
                                        subtitle: textDarkBold(
                                          getTranslated(context, 'employee') +
                                              ' #' +
                                              widget._employeeId +
                                              ' ' +
                                              LanguageUtil
                                                  .findFlagByNationality(
                                                      employee.nationality),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                text18DarkBold(
                                    getTranslated(context, 'statisticsForThe') +
                                        employee.currentYear +
                                        ' ' +
                                        getTranslated(
                                            context, employee.currentMonth)),
                                Card(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0)),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: DARK,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0, vertical: 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              text20WhiteBold(getTranslated(
                                                  context, 'days')),
                                              SizedBox(height: 5.0),
                                              Countup(
                                                begin: 0,
                                                end: employee
                                                    .daysWorkedInCurrentMonth
                                                    .toDouble(),
                                                duration: Duration(seconds: 2),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              text20WhiteBold(getTranslated(
                                                  context, 'rating')),
                                              SizedBox(height: 5.0),
                                              Countup(
                                                begin: 0,
                                                end: employee
                                                    .ratingInCurrentMonth,
                                                precision: 1,
                                                duration: Duration(seconds: 2),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              text20WhiteBold(getTranslated(
                                                  context, 'money')),
                                              SizedBox(height: 5.0),
                                              Countup(
                                                begin: 0,
                                                end: employee
                                                    .earnedMoneyInCurrentMonth,
                                                duration: Duration(seconds: 2),
                                                separator: ',',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
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
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: <Widget>[
                              TabBar(
                                tabs: <Widget>[
                                  Tab(
                                      icon: iconWhite(Icons.assignment),
                                      child: text18White(getTranslated(
                                          context, 'workTimeSheets'))),
                                  Tab(
                                      icon: iconWhite(Icons.person_pin),
                                      child: text18White(getTranslated(
                                          context, 'informations'))),
                                ],
                                isScrollable: true,
                                indicatorColor: GREEN,
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    employeeTimeSheetsTab(
                                        context, employee.timeSheets),
                                    employeeInfoTab(context, employee)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onWillPop: _onWillPop);
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
