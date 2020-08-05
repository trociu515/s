import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';

Container employeeGroupTab(BuildContext context, EmployeeDto employee) {
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
                      getTranslated(context, 'groupId'),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
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
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      employee.groupName != null && employee.groupName != 'Brak'
                          ? utf8.decode(employee.groupName.runes.toList())
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
