import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';

Container employeeAddressTab(BuildContext context, EmployeeDto employee) {
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
                      getTranslated(context, 'locality'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.locality != null
                          ? utf8.decode(employee.locality.runes.toList())
                          : getTranslated(context, 'empty'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'zipCode'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                      getTranslated(context, 'street'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.street != null
                          ? utf8.decode(employee.street.runes.toList())
                          : getTranslated(context, 'empty'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      getTranslated(context, 'houseNumber'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.houseNumber != null
                          ? employee.houseNumber.toString()
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
