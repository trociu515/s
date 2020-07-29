import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/colors.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/loader_widget.dart';

import '../dto/employee_dto.dart';

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
          return MaterialApp(
            title: APP_NAME,
            theme:
                ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: DARK,
              appBar: appBar(context, getTranslated(context, 'information')),
              drawer: employeeSideBar(context, widget._employeeId,
                  widget._employeeInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: DARK,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                getTranslated(context, 'id'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.id != null
                                    ? employee.id.toString()
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'username'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(
                                  employee.username != null
                                      ? employee.username.runes.toList()
                                      : getTranslated(context, 'empty'),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'name'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(
                                  employee.name != null
                                      ? employee.name.runes.toList()
                                      : getTranslated(context, 'empty'),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'surname'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(
                                  employee.surname != null
                                      ? employee.surname.runes.toList()
                                      : getTranslated(context, 'empty'),
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'dateOfBirth'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.dateOfBirth != null
                                    ? employee.dateOfBirth
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'fatherName'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.fatherName != null
                                    ? utf8.decode(
                                        employee.fatherName.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'motherName'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.motherName != null
                                    ? utf8.decode(
                                        employee.motherName.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(
                                    context, 'expirationDateOfWorkInPoland'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.expirationDateOfWorkInPoland != null
                                    ? employee.expirationDateOfWorkInPoland
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'nip'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.nip != null
                                    ? employee.nip
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'bankAccountNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.bankAccountNumber != null
                                    ? employee.bankAccountNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'moneyPerHour'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.moneyPerHour != null
                                    ? employee.moneyPerHour.toString()
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'drivingLicense'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.drivingLicense != null
                                    ? employee.drivingLicense
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'houseNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.houseNumber != null
                                    ? employee.houseNumber.toString()
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'street'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.street != null
                                    ? utf8
                                        .decode(employee.street.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'zipCode'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.zipCode != null
                                    ? employee.zipCode
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'locality'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.locality != null
                                    ? utf8.decode(
                                        employee.locality.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'passportNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.passportNumber != null
                                    ? employee.passportNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'passportReleaseDate'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.passportReleaseDate != null
                                    ? employee.passportReleaseDate
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(
                                    context, 'passportExpirationDate'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.passportExpirationDate != null
                                    ? employee.passportExpirationDate
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'email'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.email != null
                                    ? employee.email
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'phoneNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.phoneNumber != null
                                    ? employee.phoneNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'viberNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.viberNumber != null
                                    ? employee.viberNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'whatsAppNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.whatsAppNumber != null
                                    ? employee.whatsAppNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'groupId'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.groupId != null
                                    ? employee.groupId.toString()
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'groupName'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                employee.groupName != null &&
                                        employee.groupName != 'Brak'
                                    ? utf8.decode(
                                        employee.groupName.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
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
          );
        }
      },
    );
  }
}
