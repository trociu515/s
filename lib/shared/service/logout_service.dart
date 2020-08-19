import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../unauthenticated/login_page.dart';
import '../../main.dart';

class Logout {
  static logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textWhite(getTranslated(context, 'logout')),
          content: textWhite(getTranslated(context, 'logoutConfirm')),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'yes')),
              onPressed: () => logoutWithoutConfirm(
                  context, getTranslated(context, 'logoutSuccessfully')),
            ),
            FlatButton(
                child: textWhite(getTranslated(context, 'no')),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  static logoutWithoutConfirm(BuildContext context, String msg) {
    storage.delete(key: 'authorization');
    storage.delete(key: 'role');
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LoginPage()), (e) => false);
    ToastService.showToast(msg, GREEN);
  }
}
