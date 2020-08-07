import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/texts.dart';

Container employeeTimeSheetsTab(BuildContext context, List timeSheets) {
  if (timeSheets.isEmpty) {
    return Container(
        child: text17White(
            '\n   ' + getTranslated(context, 'employeeDoesNotHaveTimeSheets')));
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
                            ? GREEN
                            : Colors.orange,
                      ),
                      title: textWhite(timeSheet.year.toString() +
                          ' ' +
                          MonthUtil.translateMonth(context, timeSheet.month) +
                          '\n' +
                          utf8.decode(timeSheet.groupName.runes.toList())),
                      subtitle: Wrap(
                        children: <Widget>[
                          textWhite(getTranslated(context, 'hoursWorked') +
                              ': ' +
                              timeSheet.totalHours.toString() +
                              'h'),
                          textWhite(getTranslated(context, 'averageRating') +
                              ': ' +
                              timeSheet.averageEmployeeRating.toString()),
                        ],
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          text20GreenBold(
                              timeSheet.totalMoneyEarned.toString()),
                          text20GreenBold(" ZŁ")
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
