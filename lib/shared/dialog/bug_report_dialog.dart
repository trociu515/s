import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/widget/texts.dart';

Future<void> bugReportDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: DARK,
        title: textWhite(getTranslated(context, 'bugReport')),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              textWhite(
                  getTranslated(context, 'somethingWrongWithApplication')),
              SizedBox(height: 5),
              textWhite(getTranslated(context, 'contactWithUsByGivenEmail')),
              SizedBox(height: 25),
              SelectableText('givejob.bug@gmail.com',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: WHITE)),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: textWhite(getTranslated(context, 'close')),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
