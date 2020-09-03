import 'dart:convert';

import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/profile/tabs/employee_info_tab.dart';
import 'package:give_job/employee/profile/tabs/employee_time_sheets.tab.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/settings/settings_page.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/silver_app_bar_delegate.dart';
import 'package:give_job/shared/widget/texts.dart';

class EmployeeProfilPage extends StatefulWidget {
  final User _user;

  EmployeeProfilPage(this._user);

  @override
  _EmployeeProfilPageState createState() => _EmployeeProfilPageState();
}

class _EmployeeProfilPageState extends State<EmployeeProfilPage> {
  final EmployeeService _employeeService = new EmployeeService();

  User _user;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    return FutureBuilder<EmployeeDto>(
      future: _employeeService.findById(_user.id, _user.authHeader),
      builder: (BuildContext context, AsyncSnapshot<EmployeeDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: GREEN,
              valueColor: new AlwaysStoppedAnimation(Colors.white),
            ),
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
                  drawer: employeeSideBar(context, _user),
                  backgroundColor: DARK,
                  body: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            elevation: 0.0,
                            actions: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: IconButton(
                                  icon: iconWhite(Icons.settings),
                                  onPressed: () {
                                    Navigator.push(
                                      this.context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingsPage(_user)),
                                    );
                                  },
                                ),
                              ),
                            ],
                            iconTheme: IconThemeData(color: WHITE),
                            expandedHeight: 305.0,
                            pinned: true,
                            backgroundColor: BRIGHTER_DARK,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(top: 35, bottom: 5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage('images/logo.png'),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  text25WhiteBold(utf8.decode(_user.info != null
                                      ? _user.info.runes.toList()
                                      : '-')),
                                  SizedBox(height: 2.5),
                                  text20White(
                                      LanguageUtil.convertShortNameToFullName(
                                              _user.nationality) +
                                          ' ' +
                                          LanguageUtil.findFlagByNationality(
                                              _user.nationality)),
                                  SizedBox(height: 2.5),
                                  text18White(
                                      getTranslated(this.context, 'employee') +
                                          ' #' +
                                          _user.id.toString()),
                                  SizedBox(height: 5),
                                  text16GreenBold(getTranslated(
                                          this.context, 'statisticsForThe') +
                                      employee.currentYear +
                                      ' ' +
                                      getTranslated(
                                          this.context, employee.currentMonth)),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: 12, left: 12),
                                    child: Card(
                                      elevation: 0.0,
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        color: BRIGHTER_DARK,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  text20White(getTranslated(
                                                      this.context, 'days')),
                                                  SizedBox(height: 5.0),
                                                  Countup(
                                                    begin: 0,
                                                    end: employee
                                                        .daysWorkedInCurrentMonth
                                                        .toDouble(),
                                                    duration:
                                                        Duration(seconds: 2),
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
                                                      this.context, 'money')),
                                                  text14White(employee
                                                              .moneyCurrency !=
                                                          null
                                                      ? '(' +
                                                          employee
                                                              .moneyCurrency +
                                                          ')'
                                                      : getTranslated(
                                                          this.context,
                                                          'noCurrency')),
                                                  Countup(
                                                    begin: 0,
                                                    end: employee
                                                        .earnedMoneyInCurrentMonth,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    separator: ',',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: WHITE),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  text20White(getTranslated(
                                                      this.context, 'rating')),
                                                  SizedBox(height: 5.0),
                                                  Countup(
                                                    begin: 0,
                                                    end: employee
                                                        .ratingInCurrentMonth,
                                                    precision: 1,
                                                    duration:
                                                        Duration(seconds: 2),
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
                          SliverPersistentHeader(
                            delegate: SliverAppBarDelegate(
                              TabBar(
                                labelColor: GREEN,
                                unselectedLabelColor: Colors.grey,
                                tabs: <Widget>[
                                  Tab(
                                      icon: iconWhite(Icons.assignment),
                                      text: getTranslated(
                                          this.context, 'timesheets')),
                                  Tab(
                                      icon: iconWhite(Icons.info),
                                      text: 'About me'),
                                ],
                              ),
                            ),
                            pinned: true,
                          ),
                        ];
                      },
                      body: Padding(
                        padding: EdgeInsets.all(5),
                        child: TabBarView(
                          children: <Widget>[
                            employeeTimeSheetsTab(
                                this.context, employee.timeSheets),
                            employeeInfoTab(this.context, employee)
                          ],
                        ),
                      ),
                    ),
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
