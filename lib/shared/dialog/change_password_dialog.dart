import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/user_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../service/logout_service.dart';

changePasswordDialog(
    BuildContext context, String username, String authHeader) {
  final _userService = new UserService();
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      final newPasswordController = new TextEditingController();
      TextFormField newPasswordField = TextFormField(
        controller: newPasswordController,
        obscureText: true,
        autofocus: true,
        keyboardType: TextInputType.text,
        maxLength: 60,
        style: TextStyle(color: WHITE),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: WHITE),
          labelStyle: TextStyle(color: WHITE),
          labelText: getTranslated(context, 'newPassword'),
        ),
      );
      final reNewPasswordController = new TextEditingController();
      TextFormField reNewPasswordField = TextFormField(
        controller: reNewPasswordController,
        obscureText: true,
        keyboardType: TextInputType.text,
        maxLength: 60,
        style: TextStyle(color: WHITE),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: WHITE),
          labelStyle: TextStyle(color: WHITE),
          labelText: getTranslated(context, 'retypeNewPassword'),
        ),
      );
      return AlertDialog(
        backgroundColor: DARK,
        title: textWhite(getTranslated(context, 'changePassword')),
        content: Container(
          height: 165,
          child: Column(
            children: <Widget>[
              Container(child: newPasswordField),
              Container(child: reNewPasswordField),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: textWhite(getTranslated(context, 'save')),
            onPressed: () {
              String newPassword = newPasswordController.text;
              String reNewPassword = reNewPasswordController.text;
              String invalidMessage = ValidatorService.validateUpdatingPassword(
                  newPassword, reNewPassword, context);
              if (invalidMessage != null) {
                ToastService.showToast(invalidMessage, Colors.red);
                return;
              }
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: DARK,
                    title: textWhite(getTranslated(context, 'warning')),
                    content: textWhite(getTranslated(
                            context, 'changePasswordWarningFirstContent') +
                        '\n' +
                        getTranslated(
                            context, 'changePasswordWarningFirstContent')),
                    actions: <Widget>[
                      FlatButton(
                        child: textWhite(getTranslated(
                            context, 'changePasswordAgreeButtonText')),
                        onPressed: () => {
                          _userService
                              .updatePassword(username, newPassword, authHeader)
                              .then((res) {
                            Navigator.of(context).pop();
                            Logout.logoutWithoutConfirm(
                                context,
                                getTranslated(
                                    context, 'changePasswordSuccessMsg'));
                          })
                        },
                      ),
                      FlatButton(
                          child: textWhite(getTranslated(context, 'no')),
                          onPressed: () => Navigator.of(context).pop()),
                    ],
                  );
                },
              );
            },
          ),
          FlatButton(
            child: textWhite(getTranslated(context, 'close')),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
}
