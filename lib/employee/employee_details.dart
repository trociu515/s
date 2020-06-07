import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/employee_service.dart';
import 'package:give_job/employee/employee_side_bar.dart';
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
              appBar: appBar(context),
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
                              title: Text('Identyfikator'),
                              subtitle: Text(employee.id.toString()),
                            ),
                            ListTile(
                              title: Text('Nazwa użytkownika'),
                              subtitle: Text(utf8
                                  .decode(employee.username.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Imię'),
                              subtitle: Text(
                                  utf8.decode(employee.name.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Nazwisko'),
                              subtitle: Text(
                                  utf8.decode(employee.surname.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Data urodzenia'),
                              subtitle: Text(employee.dateOfBirth),
                            ),
                            ListTile(
                              title: Text('Imię ojca'),
                              subtitle: Text(utf8
                                  .decode(employee.fatherName.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Imię matki'),
                              subtitle: Text(utf8
                                  .decode(employee.motherName.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Data ważności pracy w Polsce'),
                              subtitle:
                                  Text(employee.expirationDateOfWorkInPoland),
                            ),
                            ListTile(
                              title: Text('NIP'),
                              subtitle: Text(employee.nip),
                            ),
                            ListTile(
                              title: Text('Number konta bankowego'),
                              subtitle: Text(employee.bankAccountNumber),
                            ),
                            ListTile(
                              title: Text('Stawka godzinowa'),
                              subtitle: Text(employee.moneyPerHour.toString()),
                            ),
                            ListTile(
                              title: Text('Prawo jazdy'),
                              subtitle: Text(employee.drivingLicense),
                            ),
                            ListTile(
                              title: Text('Numer domu'),
                              subtitle: Text(employee.houseNumber.toString()),
                            ),
                            ListTile(
                              title: Text('Ulica'),
                              subtitle: Text(
                                  utf8.decode(employee.street.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Kod pocztowy'),
                              subtitle: Text(employee.zipCode),
                            ),
                            ListTile(
                              title: Text('Miejscowość'),
                              subtitle: Text(utf8
                                  .decode(employee.locality.runes.toList())),
                            ),
                            ListTile(
                              title: Text('Numer paszportu'),
                              subtitle: Text(employee.passportNumber),
                            ),
                            ListTile(
                              title: Text('Data wydania paszportu'),
                              subtitle: Text(employee.passportReleaseDate),
                            ),
                            ListTile(
                              title: Text('Data ważności paszportu'),
                              subtitle: Text(employee.passportExpirationDate),
                            ),
                            ListTile(
                              title: Text('Identyfikator grupy'),
                              subtitle: Text(employee.groupId.toString()),
                            ),
                            ListTile(
                              title: Text('Nazwa grupy'),
                              subtitle: Text(utf8
                                  .decode(employee.groupName.runes.toList())),
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
