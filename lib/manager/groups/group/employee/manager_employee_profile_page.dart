import 'dart:convert';

import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/employee/dto/employee_timesheet_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_employee_contact_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/profile/manager_profile_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/circular_progress_indicator.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/silver_app_bar_delegate.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/libraries/constants.dart';
import '../../../manager_side_bar.dart';
import 'manager_employee_ts_completed_page.dart';
import 'manager_employee_ts_in_progress_page.dart';

class ManagerEmployeeProfilePage extends StatefulWidget {
  final GroupEmployeeModel _model;
  final String _employeeNationality;
  final String _currency;
  final int _employeeId;
  final String _employeeInfo;

  const ManagerEmployeeProfilePage(
    this._model,
    this._employeeNationality,
    this._currency,
    this._employeeId,
    this._employeeInfo,
  );

  @override
  _ManagerEmployeeProfilePageState createState() =>
      _ManagerEmployeeProfilePageState();
}

class _ManagerEmployeeProfilePageState
    extends State<ManagerEmployeeProfilePage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;
  String _employeeNationality;
  String _currency;
  int _employeeId;
  String _employeeInfo;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    this._employeeNationality = widget._employeeNationality;
    this._currency = widget._currency;
    this._employeeId = widget._employeeId;
    this._employeeInfo = widget._employeeInfo;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: managerSideBar(context, _model.user),
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
                        icon: iconWhite(Icons.person),
                        onPressed: () {
                          Navigator.push(
                            this.context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManagerProfilePage(_model.user)),
                          );
                        },
                      ),
                    ),
                  ],
                  title: text15White(getTranslated(this.context, 'employee')),
                  iconTheme: IconThemeData(color: WHITE),
                  expandedHeight: 250.0,
                  pinned: true,
                  backgroundColor: BRIGHTER_DARK,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 70, bottom: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                  'images/big-employee-icon.png',
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                        text25WhiteBold(utf8.decode(_employeeInfo != null
                            ? _employeeInfo.runes.toList()
                            : '-')),
                        SizedBox(height: 2.5),
                        text20White(LanguageUtil.convertShortNameToFullName(
                                this.context, _employeeNationality) +
                            ' ' +
                            LanguageUtil.findFlagByNationality(
                                _employeeNationality)),
                        SizedBox(height: 2.5),
                        text18White(getTranslated(this.context, 'employee') +
                            ' #' +
                            _employeeId.toString()),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                    TabBar(
                      labelColor: GREEN,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                            icon: Icon(Icons.event_note),
                            text: getTranslated(this.context, 'timesheets')),
                        Tab(
                            icon: Icon(Icons.import_contacts),
                            text: getTranslated(this.context, 'contact')),
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
                  _buildTimesheetsSection(),
                  _buildContactSection(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }

  Widget _buildTimesheetsSection() {
    return FutureBuilder(
      future: _managerService.findEmployeeTimesheetsByGroupIdAndEmployeeId(
          _model.groupId.toString(),
          _employeeId.toString(),
          _model.user.authHeader),
      builder: (BuildContext context,
          AsyncSnapshot<List<EmployeeTimesheetDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: circularProgressIndicator());
        } else {
          List<EmployeeTimesheetDto> timesheets = snapshot.data;
          return timesheets.isNotEmpty
              ? SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        for (var timesheet in timesheets)
                          Card(
                            color: BRIGHTER_DARK,
                            child: InkWell(
                              onTap: () {
                                if (timesheet.status == 'Completed') {
                                  Navigator.of(this.context).push(
                                    CupertinoPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return ManagerEmployeeTsCompletedPage(
                                            _model,
                                            _employeeInfo,
                                            _employeeNationality,
                                            _currency,
                                            timesheet);
                                      },
                                    ),
                                  );
                                } else {
                                  Navigator.of(this.context).push(
                                    CupertinoPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return ManagerEmployeeTsInProgressPage(
                                            _model,
                                            _employeeInfo,
                                            _employeeNationality,
                                            _currency,
                                            timesheet);
                                      },
                                    ),
                                  );
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    leading: Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                      child: Image(
                                        image: timesheet.status ==
                                                STATUS_IN_PROGRESS
                                            ? AssetImage('images/unchecked.png')
                                            : AssetImage('images/checked.png'),
                                      ),
                                    ),
                                    title: textWhiteBold(
                                        timesheet.year.toString() +
                                            ' ' +
                                            MonthUtil.translateMonth(
                                                this.context, timesheet.month)),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Align(
                                            child: Row(
                                              children: <Widget>[
                                                textWhite(getTranslated(
                                                        this.context,
                                                        'hoursWorked') +
                                                    ': '),
                                                textGreenBold(timesheet
                                                        .numberOfHoursWorked
                                                        .toString() +
                                                    'h'),
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
                                              textGreenBold(timesheet
                                                  .averageRating
                                                  .toString()),
                                            ],
                                          ),
                                          alignment: Alignment.topLeft,
                                        ),
                                      ],
                                    ),
                                    trailing: Wrap(
                                      children: <Widget>[
                                        textGreenBold(timesheet
                                            .amountOfEarnedMoney
                                            .toString()),
                                        textGreenBold(' ' + _currency)
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
                )
              : _handleEmptyData(getTranslated(context, 'noTimesheets'),
                  getTranslated(context, 'employeeHasNoTimesheets'));
        }
      },
    );
  }

  Widget _buildContactSection() {
    return FutureBuilder(
        future: _managerService.findEmployeeContactByEmployeeId(
            _employeeId, _model.user.authHeader),
        builder: (BuildContext context,
            AsyncSnapshot<ManagerEmployeeContactDto> snapshot) {
          ManagerEmployeeContactDto contact = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Center(child: circularProgressIndicator());
          } else if (contact == null) {
            return _handleEmptyData(getTranslated(context, 'noContact'),
                getTranslated(context, 'employeeHasNoContact'));
          } else {
            String email = contact.email;
            String phoneNumber = contact.phoneNumber;
            String viberNumber = contact.viberNumber;
            String whatsAppNumber = contact.whatsAppNumber;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  email != null
                      ? _buildEmail(email)
                      : _buildEmptyListTile('email'),
                  phoneNumber != null
                      ? _buildPhoneNumber(phoneNumber)
                      : _buildEmptyListTile('phoneNumber'),
                  viberNumber != null
                      ? _buildViber(viberNumber)
                      : _buildEmptyListTile('viberNumber'),
                  whatsAppNumber != null
                      ? _buildWhatsApp(whatsAppNumber)
                      : _buildEmptyListTile('whatsAppNumber'),
                ],
              ),
            );
          }
        });
  }

  Widget _buildEmail(String email) {
    return ListTile(
      title: text16GreenBold(getTranslated(this.context, 'email')),
      subtitle: Row(
        children: <Widget>[
          SelectableText(email, style: TextStyle(fontSize: 16, color: WHITE)),
          SizedBox(width: 5),
          IconButton(
            icon: icon30White(Icons.alternate_email),
            onPressed: () => _launchAction('mailto', email),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber(String phoneNumber) {
    return ListTile(
      title: text16GreenBold(getTranslated(this.context, 'phone')),
      subtitle: Row(
        children: <Widget>[
          SelectableText(phoneNumber,
              style: TextStyle(fontSize: 16, color: WHITE)),
          SizedBox(width: 5),
          IconButton(
            icon: icon30White(Icons.phone),
            onPressed: () => _launchAction('tel', phoneNumber),
          ),
          IconButton(
            icon: icon30White(Icons.local_post_office),
            onPressed: () => _launchAction('sms', phoneNumber),
          ),
        ],
      ),
    );
  }

  Widget _buildViber(String viberNumber) {
    return ListTile(
      title: text16GreenBold(getTranslated(this.context, 'viber')),
      subtitle: Row(
        children: <Widget>[
          SelectableText(viberNumber,
              style: TextStyle(fontSize: 16, color: WHITE)),
          SizedBox(width: 5),
          SizedBox(width: 7.5),
          Padding(
            padding: EdgeInsets.all(4),
            child: Transform.scale(
              scale: 1.2,
              child: BouncingWidget(
                duration: Duration(milliseconds: 100),
                scaleFactor: 2,
                onPressed: () => _launchApp('viber', viberNumber),
                child: Image(
                  width: 40,
                  height: 40,
                  image: AssetImage('images/viber-logo.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsApp(String whatsAppNumber) {
    return ListTile(
      title: text16GreenBold(getTranslated(this.context, 'whatsApp')),
      subtitle: Row(
        children: <Widget>[
          SelectableText(whatsAppNumber,
              style: TextStyle(fontSize: 16, color: WHITE)),
          SizedBox(width: 7.5),
          Padding(
            padding: EdgeInsets.all(4),
            child: Transform.scale(
              scale: 1.2,
              child: BouncingWidget(
                duration: Duration(milliseconds: 100),
                scaleFactor: 2,
                onPressed: () => _launchApp('whatsapp', whatsAppNumber),
                child: Image(
                  width: 40,
                  height: 40,
                  image: AssetImage('images/whatsapp-logo.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchAction(String action, String number) async {
    String url = action + ':' + number;
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  _launchApp(String app, String number) async {
    var url = '$app://send?phone=$number';
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  Widget _buildEmptyListTile(String title) {
    return ListTile(
      title: text16GreenBold(getTranslated(this.context, title)),
      subtitle: text16White(getTranslated(this.context, 'empty')),
    );
  }

  Widget _handleEmptyData(String title, String subtitle) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: text16GreenBold(getTranslated(context, 'noTimesheets')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.center,
            child: textCenter19White(
                getTranslated(context, 'employeeHasNoTimesheets')),
          ),
        ),
      ],
    );
  }
}
