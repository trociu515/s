import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';

Future<void> bugReportDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          getTranslated(context, 'bugReport'),
          style: TextStyle(color: DARK),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                getTranslated(context, 'somethingWrongWithApplication'),
                style: TextStyle(color: DARK),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                getTranslated(context, 'contactWithUsByGivenEmail'),
                style: TextStyle(color: DARK),
              ),
              SizedBox(
                height: 25,
              ),
              SelectableText(
                'givejob.bug@gmail.com',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: DARK),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              getTranslated(context, 'close'),
              style: TextStyle(color: DARK),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
