import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';

Container employeeInfoTab(BuildContext context, EmployeeDto employee) {
  return Container(
    child: SingleChildScrollView(
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                      getTranslated(context, 'nationality'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      utf8.decode(
                        employee.nationality != null
                            ? employee.nationality.runes.toList()
                            : getTranslated(context, 'empty'),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'dateOfBirth'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.fatherName != null
                          ? utf8.decode(employee.fatherName.runes.toList())
                          : getTranslated(context, 'empty'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'motherName'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.motherName != null
                          ? utf8.decode(employee.motherName.runes.toList())
                          : getTranslated(context, 'empty'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'expirationDateOfWork'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.expirationDateOfWork != null
                          ? employee.expirationDateOfWork
                          : getTranslated(context, 'empty'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'nip'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                      getTranslated(context, 'passportNumber'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                      getTranslated(context, 'passportExpirationDate'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.passportExpirationDate != null
                          ? employee.passportExpirationDate
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
  );
}
