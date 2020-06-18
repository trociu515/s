import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';

Future<void> bugReportDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(getTranslated(context, 'bugReport')),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(getTranslated(context, 'somethingWrongWithApplication')),
              SizedBox(
                height: 5,
              ),
              Text(getTranslated(context, 'contactWithUsByGivenEmail')),
              SizedBox(
                height: 25,
              ),
              SelectableText(
                'givejob.bug@gmail.com',
                style: TextStyle(
                    fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(getTranslated(context, 'close')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
