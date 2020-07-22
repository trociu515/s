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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (e) => false);
                ToastService.showToast(
                    getTranslated(context, 'logoutSuccessfully'), Color(0xffb5d76d));
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
