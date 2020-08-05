import 'dart:convert';

import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/loader_widget.dart';

import 'dto/employee_dto.dart';

class EmployeeInformationPage extends StatefulWidget {
  final String _employeeId;
  final String _employeeInfo;
  final String _authHeader;

  EmployeeInformationPage(
      this._employeeId, this._employeeInfo, this._authHeader);

  @override
  _EmployeeInformationPageState createState() =>
      _EmployeeInformationPageState();
}

class _EmployeeInformationPageState extends State<EmployeeInformationPage> {
  final EmployeeService _employeeService = new EmployeeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeDto>(
      future: _employeeService.findById(widget._employeeId, widget._authHeader),
      builder: (BuildContext context, AsyncSnapshot<EmployeeDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loaderWidget(
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
                                colors: [
                              GREEN,
                              GREEN,
                            ])),
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
                                      margin: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                      ),
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
                                        title: Text(
                                          utf8.decode(
                                              widget._employeeInfo != null
                                                  ? widget._employeeInfo.runes
                                                      .toList()
                                                  : '-'),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: DARK,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          getTranslated(context, 'employee') +
                                              ' #' +
                                              widget._employeeId,
                                          style: TextStyle(
                                              color: DARK,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Statistics for the current month',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: DARK),
                                ),
                                Card(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
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
                                              Text(
                                                "Days",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Countup(
                                                begin: 0,
                                                end: 20,
                                                duration: Duration(seconds: 2),
                                                separator: ',',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Rating",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Countup(
                                                begin: 0,
                                                end: 9.1,
                                                prefix: '10/',
                                                precision: 1,
                                                separator: ',',
                                                duration: Duration(seconds: 2),
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Money",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Countup(
                                                begin: 0,
                                                end: 3200,
                                                duration: Duration(seconds: 2),
                                                separator: ',',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.white,
                                                ),
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
                          child: Column(
                            children: <Widget>[
                              TabBar(
                                tabs: <Widget>[
                                  Tab(
                                    icon: Icon(
                                      Icons.person_pin,
                                      color: WHITE,
                                    ),
                                    child: Text(
                                      'Info',
                                      style: TextStyle(
                                          color: WHITE,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Tab(
                                    icon: Icon(
                                      Icons.home,
                                      color: WHITE,
                                    ),
                                    child: Text(
                                      'Address',
                                      style: TextStyle(
                                          color: WHITE,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Tab(
                                    icon: Icon(
                                      Icons.phone_in_talk,
                                      color: WHITE,
                                    ),
                                    child: Text(
                                      'Contact',
                                      style: TextStyle(
                                          color: WHITE,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Tab(
                                    icon: Icon(
                                      Icons.group,
                                      color: WHITE,
                                    ),
                                    child: Text(
                                      'Group',
                                      style: TextStyle(
                                          color: WHITE,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    Container(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: DARK,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'id'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.id != null
                                                            ? employee.id
                                                                .toString()
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'username'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        utf8.decode(
                                                          employee.username !=
                                                                  null
                                                              ? employee
                                                                  .username
                                                                  .runes
                                                                  .toList()
                                                              : getTranslated(
                                                                  context,
                                                                  'empty'),
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'name'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        utf8.decode(
                                                          employee.name != null
                                                              ? employee
                                                                  .name.runes
                                                                  .toList()
                                                              : getTranslated(
                                                                  context,
                                                                  'empty'),
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'surname'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        utf8.decode(
                                                          employee.surname !=
                                                                  null
                                                              ? employee
                                                                  .surname.runes
                                                                  .toList()
                                                              : getTranslated(
                                                                  context,
                                                                  'empty'),
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'nationality'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        utf8.decode(
                                                          employee.nationality !=
                                                                  null
                                                              ? employee
                                                                  .nationality
                                                                  .runes
                                                                  .toList()
                                                              : getTranslated(
                                                                  context,
                                                                  'empty'),
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'dateOfBirth'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.dateOfBirth !=
                                                                null
                                                            ? employee
                                                                .dateOfBirth
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'fatherName'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.fatherName !=
                                                                null
                                                            ? utf8.decode(
                                                                employee
                                                                    .fatherName
                                                                    .runes
                                                                    .toList())
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'motherName'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.motherName !=
                                                                null
                                                            ? utf8.decode(
                                                                employee
                                                                    .motherName
                                                                    .runes
                                                                    .toList())
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'expirationDateOfWork'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.expirationDateOfWork !=
                                                                null
                                                            ? employee
                                                                .expirationDateOfWork
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'nip'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.nip != null
                                                            ? employee.nip
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'bankAccountNumber'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.bankAccountNumber !=
                                                                null
                                                            ? employee
                                                                .bankAccountNumber
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'moneyPerHour'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.moneyPerHour !=
                                                                null
                                                            ? employee
                                                                .moneyPerHour
                                                                .toString()
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'drivingLicense'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee
                                                                    .drivingLicense !=
                                                                null
                                                            ? employee
                                                                .drivingLicense
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'passportNumber'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee
                                                                    .passportNumber !=
                                                                null
                                                            ? employee
                                                                .passportNumber
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'passportReleaseDate'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.passportReleaseDate !=
                                                                null
                                                            ? employee
                                                                .passportReleaseDate
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'passportExpirationDate'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.passportExpirationDate !=
                                                                null
                                                            ? employee
                                                                .passportExpirationDate
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: DARK,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'locality'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.locality !=
                                                                null
                                                            ? utf8.decode(
                                                                employee
                                                                    .locality
                                                                    .runes
                                                                    .toList())
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'zipCode'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.zipCode != null
                                                            ? employee.zipCode
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'street'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.street != null
                                                            ? utf8.decode(
                                                                employee.street
                                                                    .runes
                                                                    .toList())
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'houseNumber'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.houseNumber !=
                                                                null
                                                            ? employee
                                                                .houseNumber
                                                                .toString()
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: DARK,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'email'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.email != null
                                                            ? employee.email
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'phoneNumber'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.phoneNumber !=
                                                                null
                                                            ? employee
                                                                .phoneNumber
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'viberNumber'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.viberNumber !=
                                                                null
                                                            ? employee
                                                                .viberNumber
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'whatsAppNumber'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee
                                                                    .whatsAppNumber !=
                                                                null
                                                            ? employee
                                                                .whatsAppNumber
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: <Widget>[
                                              Card(
                                                color: DARK,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(
                                                            context, 'groupId'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.groupId != null
                                                            ? employee.groupId
                                                                .toString()
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        getTranslated(context,
                                                            'groupName'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        employee.groupName !=
                                                                    null &&
                                                                employee.groupName !=
                                                                    'Brak'
                                                            ? utf8.decode(
                                                                employee
                                                                    .groupName
                                                                    .runes
                                                                    .toList())
                                                            : getTranslated(
                                                                context,
                                                                'empty'),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
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
                            ],
                          ),
                          length: 4,
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
