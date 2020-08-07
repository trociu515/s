import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../login_page.dart';
import '../../main.dart';

class Logout {
  static logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: textDark(getTranslated(context, 'logout')),
          content: textDark(getTranslated(context, 'logoutConfirm')),
          actions: <Widget>[
            FlatButton(
              child: textDark(getTranslated(context, 'yes')),
              onPressed: () {
                storage.delete(key: 'authorization');
                storage.delete(key: 'role');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (e) => false);
                ToastService.showToast(
                    getTranslated(context, 'logoutSuccessfully'), GREEN);
              },
            ),
            FlatButton(
                child: textDark(getTranslated(context, 'no')),
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }
}
