import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';

class ValidatorService {
  static String validateLoginCredentials(
      String username, String password, BuildContext context) {
    if (username.isEmpty && password.isEmpty) {
      return getTranslated(context, 'usernameAndPasswordRequired');
    } else if (username.isEmpty) {
      return getTranslated(context, 'usernameRequired');
    } else if (password.isEmpty) {
      return getTranslated(context, 'passwordRequired');
    }
    return null;
  }

  static String validateUpdatingHours(int hours, BuildContext context) {
    if (hours.isNegative) {
      return getTranslated(context, 'hoursCannotBeLowerThan0');
    } else if (hours > 24) {
      return getTranslated(context, 'hoursCannotBeHigherThan24');
    }
    return null;
  }

  static String validateUpdatingRating(int rating, BuildContext context) {
    if (rating < 1) {
      return getTranslated(context, 'ratingCannotBeLowerThan1');
    } else if (rating > 10) {
      return getTranslated(context, 'ratingCannotBeHigherThan10');
    }
    return null;
  }

  static String validateUpdatingComment(String comment, BuildContext context) {
    return comment != null && comment.length > 510
        ? getTranslated(context, 'commentLengthCannotBeHigherThan510')
        : null;
  }

  static String validateUpdatingPassword(
      String newPassword, String reNewPassword, BuildContext context) {
    if (newPassword == null) {
      return getTranslated(context, 'newPasswordIsRequired');
    } else if (newPassword.length < 6) {
      return getTranslated(context, 'newPasswordWrongLength');
    } else if (reNewPassword == null) {
      return getTranslated(context, 'reNewPasswordIsRequired');
    } else if (reNewPassword != newPassword) {
      return getTranslated(context, 'passwordsDoNotMatch');
    }
    return null;
  }
}
