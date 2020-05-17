import 'package:flutter/cupertino.dart';
import 'package:lets_work/internationalization/localization/localization_constants.dart';

class ValidatorService {
  static String validateLoginCredentials(
      String username, String password, BuildContext context) {
    String invalidMessage;
    if (username.isEmpty && password.isEmpty) {
      invalidMessage = getTranslated(context, 'usernameAndPasswordRequired');
    } else if (username.isEmpty) {
      invalidMessage = getTranslated(context, 'usernameRequired');
    } else if (password.isEmpty) {
      invalidMessage = getTranslated(context, 'passwordRequired');
    }
    return invalidMessage;
  }
}
