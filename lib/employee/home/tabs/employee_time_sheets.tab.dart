import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
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
                      leading: Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Image(
                          image: timeSheet.status == STATUS_IN_PROGRESS
                              ? AssetImage('images/unchecked.png')
                              : AssetImage('images/checked.png'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      title: textWhiteBold(timeSheet.year.toString() +
                          ' ' +
                          MonthUtil.translateMonth(context, timeSheet.month) +
                          '\n' +
                          utf8.decode(timeSheet.groupName.runes.toList())),
                      subtitle: Column(
                        children: <Widget>[
                          Align(
                              child: Row(
                                children: <Widget>[
                                  textWhite(
                                      getTranslated(context, 'hoursWorked') +
                                          ': '),
                                  textGreenBold(
                                      timeSheet.numberOfHoursWorked.toString()),
                                ],
                              ),
                              alignment: Alignment.topLeft),
                          Align(
                              child: Row(
                                children: <Widget>[
                                  textWhite(
                                      getTranslated(context, 'averageRating') +
                                          ': '),
                                  textGreenBold(
                                      timeSheet.averageRating.toString()),
                                ],
                              ),
                              alignment: Alignment.topLeft),
                        ],
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          text16GreenBold(
                              timeSheet.amountOfEarnedMoney.toString()),
                          text16GreenBold(
                              " " + timeSheet.groupCountryCurrency.toString())
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
