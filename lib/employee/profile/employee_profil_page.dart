import 'dart:convert';

import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/profile/tabs/employee_info_tab.dart';
import 'package:give_job/employee/profile/tabs/employee_timesheets.tab.dart';
import 'package:give_job/employee/profile/tabs/employee_todo.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/employee/shimmer/shimmer_employee_profile.dart';
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
  EmployeeDto _employee;
  bool _refreshCalled = false;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    if (_refreshCalled) {
      return _buildPage();
    } else {
      return FutureBuilder<EmployeeDto>(
        future: _employeeService.findById(_user.id, _user.authHeader),
        builder: (BuildContext context, AsyncSnapshot<EmployeeDto> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return shimmerEmployeeProfile();
          } else {
            this._employee = snapshot.data;
            return _buildPage();
          }
        },
      );
    }
  }

  Widget _buildPage() {
    return WillPopScope(
        child: MaterialApp(
          title: APP_NAME,
          theme:
              ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            drawer: employeeSideBar(context, _user),
            backgroundColor: DARK,
            body: DefaultTabController(
              length: 3,
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
                                    builder: (context) => SettingsPage(_user)),
                              );
                            },
                          ),
                        ),
                      ],
                      iconTheme: IconThemeData(color: WHITE),
                      expandedHeight: 280.0,
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
                                    image: AssetImage(
                                      'images/big-employee-icon.png',
                                    ),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            text25WhiteBold(utf8.decode(_user.info != null
                                    ? _user.info.runes.toList()
                                    : '-') +
                                ' ' +
                                LanguageUtil.findFlagByNationality(
                                    _user.nationality)),
                            SizedBox(height: 5),
                            text18White(
                                getTranslated(this.context, 'employee') +
                                    ' #' +
                                    _user.id.toString()),
                            SizedBox(height: 12),
                            text16GreenBold(getTranslated(
                                    this.context, 'statisticsForThe') +
                                _employee.currentYear +
                                ' ' +
                                getTranslated(
                                    this.context, _employee.currentMonth)),
                            Padding(
                              padding: EdgeInsets.only(right: 12, left: 12),
                              child: Card(
                                elevation: 0.0,
                                child: Container(
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
                                              end: _employee
                                                  .daysWorkedInCurrentMonth
                                                  .toDouble(),
                                              duration: Duration(seconds: 2),
                                              style: TextStyle(
                                                  fontSize: 18.0, color: WHITE),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            text20White(getTranslated(
                                                this.context, 'money')),
                                            textCenter14White(
                                                _employee.moneyCurrency != null
                                                    ? '(' +
                                                        _employee
                                                            .moneyCurrency +
                                                        ')'
                                                    : getTranslated(
                                                        this.context,
                                                        'noCurrency')),
                                            Countup(
                                              begin: 0,
                                              end: _employee
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
                                                this.context, 'rating')),
                                            SizedBox(height: 5.0),
                                            Countup(
                                              begin: 0,
                                              end: _employee
                                                  .ratingInCurrentMonth,
                                              precision: 1,
                                              duration: Duration(seconds: 2),
                                              style: TextStyle(
                                                  fontSize: 18.0, color: WHITE),
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
                                text:
                                    getTranslated(this.context, 'timesheets')),
                            Tab(
                                icon: iconWhite(Icons.done_outline),
                                text: getTranslated(this.context, 'todo')),
                            Tab(
                                icon: iconWhite(Icons.info),
                                text: getTranslated(this.context, 'aboutMe')),
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
                      _buildTab(employeeTimesheetsTab(
                          this.context, _user, _employee.timesheets)),
                      _buildTab(employeeTodaysTodo(
                          this.context, _employee.todaysPlan)),
                      _buildTab(employeeInfoTab(this.context, _employee)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        onWillPop: _onWillPop);
  }

  RefreshIndicator _buildTab(Widget tab) {
    return RefreshIndicator(
        color: DARK, backgroundColor: WHITE, onRefresh: _refresh, child: tab);
  }

  Future<Null> _refresh() {
    return _employeeService
        .findById(_user.id.toString(), _user.authHeader)
        .then((employee) {
      setState(() {
        _employee = employee;
        _refreshCalled = true;
      });
    });
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
