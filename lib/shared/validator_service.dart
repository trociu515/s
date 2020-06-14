import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';

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

  static String validateUpdatingHours(int hours) {
    String invalidMessage;
    if (hours.isNegative) {
      invalidMessage = 'Hours cannot be lower than 0';
    } else if (hours > 24) {
      invalidMessage = 'Hours cannot be higher than 24';
    }
    return invalidMessage;
  }

  static String validateUpdatingRating(int rating) {
    String invalidMessage;
    if (rating.isNegative) {
      invalidMessage = 'Rating cannot be lower than 0';
    } else if (rating > 5) {
      invalidMessage = 'Rating cannot be higher than 24';
    }
    return invalidMessage;
  }
}
