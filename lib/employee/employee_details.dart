import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/service/employee_service.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';

import 'dto/employee_dto.dart';

class EmployeeDetails extends StatefulWidget {
  final String _employeeId;
  final String _employeeInfo;
  final String _authHeader;

  EmployeeDetails(this._employeeId, this._employeeInfo, this._authHeader);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  final EmployeeService _employeeService = new EmployeeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EmployeeDto>(
      future: _employeeService.findById(widget._employeeId, widget._authHeader),
      builder: (BuildContext context, AsyncSnapshot<EmployeeDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          EmployeeDto employee = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Scaffold(
              appBar: appBar(context, getTranslated(context, 'information')),
              drawer: employeeSideBar(context, widget._employeeId,
                  widget._employeeInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title: Text(getTranslated(context, 'id')),
                              subtitle: Text(employee.id != null
                                  ? employee.id.toString()
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'username')),
                              subtitle: Text(
                                utf8.decode(employee.username != null
                                    ? employee.username.runes.toList()
                                    : getTranslated(context, 'empty')),
                              ),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'name')),
                              subtitle: Text(utf8.decode(employee.name != null
                                  ? employee.name.runes.toList()
                                  : getTranslated(context, 'empty'))),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'surname')),
                              subtitle: Text(utf8.decode(
                                  employee.surname != null
                                      ? employee.surname.runes.toList()
                                      : getTranslated(context, 'empty'))),
                            ),
                            ListTile(
                              title:
                                  Text(getTranslated(context, 'dateOfBirth')),
                              subtitle: Text(employee.dateOfBirth != null
                                  ? employee.dateOfBirth
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'fatherName')),
                              subtitle: Text(utf8.decode(
                                  employee.fatherName != null
                                      ? employee.fatherName.runes.toList()
                                      : getTranslated(context, 'empty'))),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'motherName')),
                              subtitle: Text(utf8.decode(
                                  employee.motherName != null
                                      ? employee.motherName.runes.toList()
                                      : getTranslated(context, 'empty'))),
                            ),
                            ListTile(
                              title: Text(getTranslated(
                                  context, 'expirationDateOfWorkInPoland')),
                              subtitle: Text(
                                  employee.expirationDateOfWorkInPoland != null
                                      ? employee.expirationDateOfWorkInPoland
                                      : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'nip')),
                              subtitle: Text(employee.nip != null
                                  ? employee.nip
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(
                                  getTranslated(context, 'bankAccountNumber')),
                              subtitle: Text(employee.bankAccountNumber != null
                                  ? employee.bankAccountNumber
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title:
                                  Text(getTranslated(context, 'moneyPerHour')),
                              subtitle: Text(employee.moneyPerHour != null
                                  ? employee.moneyPerHour.toString()
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(
                                  getTranslated(context, 'drivingLicense')),
                              subtitle: Text(employee.drivingLicense != null
                                  ? employee.drivingLicense
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title:
                                  Text(getTranslated(context, 'houseNumber')),
                              subtitle: Text(employee.houseNumber != null
                                  ? employee.houseNumber.toString()
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'street')),
                              subtitle: Text(employee.street != null
                                  ? utf8.decode(employee.street.runes.toList())
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'zipCode')),
                              subtitle: Text(employee.zipCode != null
                                  ? employee.zipCode
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'locality')),
                              subtitle: Text(employee.locality != null
                                  ? utf8
                                      .decode(employee.locality.runes.toList())
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(
                                  getTranslated(context, 'passportNumber')),
                              subtitle: Text(employee.passportNumber != null
                                  ? employee.passportNumber
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(
                                  context, 'passportReleaseDate')),
                              subtitle: Text(
                                  employee.passportReleaseDate != null
                                      ? employee.passportReleaseDate
                                      : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(
                                  context, 'passportExpirationDate')),
                              subtitle: Text(
                                  employee.passportExpirationDate != null
                                      ? employee.passportExpirationDate
                                      : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'groupId')),
                              subtitle: Text(employee.groupId != null
                                  ? employee.groupId.toString()
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'groupName')),
                              subtitle: Text(employee.groupName != null &&
                                      employee.groupName != 'Brak'
                                  ? utf8
                                      .decode(employee.groupName.runes.toList())
                                  : getTranslated(context, 'empty')),
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
