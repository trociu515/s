import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/util/month_util.dart';

Container employeeTimeSheetsTab(BuildContext context, List timeSheets) {
  if (timeSheets.isEmpty) {
    return Container(
      child: Text(
        '\n   ' + getTranslated(context, 'employeeDoesNotHaveTimeSheets'),
        style: TextStyle(color: WHITE, fontSize: 17.0),
      ),
    );
  }
  return Container(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            for (var timeSheet in timeSheets)
              Card(
                color: DARK,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        timeSheet.status == 'Accepted'
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        color: timeSheet.status == 'Accepted'
                            ? Color(0xffb5d76d)
                            : Colors.orange,
                      ),
                      title: Text(
                        timeSheet.year.toString() +
                            ' ' +
                            MonthUtil.translateMonth(context, timeSheet.month) +
                            '\n' +
                            utf8.decode(timeSheet.groupName.runes.toList()),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Wrap(
                        children: <Widget>[
                          Text(
                            getTranslated(context, 'hoursWorked') +
                                ': ' +
                                timeSheet.totalHours.toString() +
                                'h',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            getTranslated(context, 'averageRating') +
                                ': ' +
                                timeSheet.averageEmployeeRating.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          Text(
                            timeSheet.totalMoneyEarned.toString(),
                            style: TextStyle(
                                color: Color(0xffb5d76d),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " ZŁ",
                            style: TextStyle(
                                color: Color(0xffb5d76d),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
