import 'dart:convert';

import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/profile/tabs/employee_info_tab.dart';
import 'package:give_job/employee/profile/tabs/employee_time_sheets.tab.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../dto/employee_dto.dart';
import '../employee_app_bar.dart';

class EmployeeProfilPage extends StatefulWidget {
  final User _user;

  EmployeeProfilPage(this._user);

  @override
  _EmployeeProfilPageState createState() => _EmployeeProfilPageState();
}

class _EmployeeProfilPageState extends State<EmployeeProfilPage> {
  final EmployeeService _employeeService = new EmployeeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeDto>(
      future:
          _employeeService.findById(widget._user.id, widget._user.authHeader),
      builder: (BuildContext context, AsyncSnapshot<EmployeeDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loader(
            employeeAppBar(context, null, getTranslated(context, 'loading')),
            employeeSideBar(context, widget._user),
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
                  appBar: employeeAppBar(context, widget._user, 'Profile'),
                  drawer: employeeSideBar(context, widget._user),
                  body: Column(
                    children: <Widget>[
                      Container(
                        color: DARK,
                        width: double.infinity,
                        height: 175,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    margin: EdgeInsets.only(top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage('images/logo.png'),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      title: text22WhiteBold(utf8.decode(
                                          widget._user.info != null
                                              ? widget._user.info.runes.toList()
                                              : '-')),
                                      subtitle: textWhite(
                                        getTranslated(context, 'employee') +
                                            ' #' +
                                            widget._user.id +
                                            ' ' +
                                            LanguageUtil.findFlagByNationality(
                                                employee.nationality),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.0),
                              text16GreenBold(
                                  getTranslated(context, 'statisticsForThe') +
                                      employee.currentYear +
                                      ' ' +
                                      getTranslated(
                                          context, employee.currentMonth)),
                              Padding(
                                padding: EdgeInsets.only(right: 12, left: 12),
                                child: Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    color: BRIGHTER_DARK,
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              text20White(getTranslated(
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
                                                    color: WHITE),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              text20White(getTranslated(
                                                  context, 'money')),
                                              text14White(employee
                                                          .moneyCurrency !=
                                                      null
                                                  ? '(' +
                                                      employee.moneyCurrency +
                                                      ')'
                                                  : getTranslated(
                                                      context, 'noCurrency')),
                                              Countup(
                                                begin: 0,
                                                end: employee
                                                    .earnedMoneyInCurrentMonth,
                                                duration: Duration(seconds: 2),
                                                separator: ',',
                                                style: TextStyle(
                                                    fontSize: 18, color: WHITE),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              text20White(getTranslated(
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
                                                    color: WHITE),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Scaffold(
                            body: TabBarView(
                              children: <Widget>[
                                employeeTimeSheetsTab(
                                    context, employee.timeSheets),
                                employeeInfoTab(context, employee)
                              ],
                            ),
                            bottomNavigationBar: TabBar(
                              tabs: <Widget>[
                                Tab(
                                    icon: iconWhite(Icons.assignment),
                                    text: getTranslated(context, 'timesheets')),
                                Tab(
                                    icon: iconWhite(Icons.person_pin),
                                    text:
                                        getTranslated(context, 'informations')),
                              ],
                              labelColor: WHITE,
                              unselectedLabelColor: Colors.white30,
                              indicatorColor: GREEN,
                            ),
                            backgroundColor: DARK,
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
