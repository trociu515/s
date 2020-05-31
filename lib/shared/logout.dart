import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/toastr_service.dart';

import '../login_page.dart';
import '../main.dart';

class Logout {
  static logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslated(context, 'logout')),
          content: Text(getTranslated(context, 'logoutConfirm')),
          actions: <Widget>[
            FlatButton(
              child: Text(getTranslated(context, 'yes')),
              onPressed: () {
                storage.delete(key: 'authorization');
                storage.delete(key: 'role');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                ToastService.showToast(
                    getTranslated(context, 'logoutSuccessfully'), Colors.green);
              },
            ),
            FlatButton(
              child: Text(getTranslated(context, 'no')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
