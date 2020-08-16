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

  static String validateUpdatingHours(int hours, BuildContext context) {
    String invalidMessage;
    if (hours.isNegative) {
      invalidMessage = getTranslated(context, 'hoursCannotBeLowerThan0');
    } else if (hours > 24) {
      invalidMessage = getTranslated(context, 'hoursCannotBeHigherThan24');
    }
    return invalidMessage;
  }

  static String validateUpdatingRating(int rating, BuildContext context) {
    String invalidMessage;
    if (rating < 1) {
      invalidMessage = getTranslated(context, 'ratingCannotBeLowerThan1');
    } else if (rating > 10) {
      invalidMessage = getTranslated(context, 'ratingCannotBeHigherThan10');
    }
    return invalidMessage;
  }

  static String validateUpdatingComment(String comment, BuildContext context) {
    return comment != null && comment.length > 510
        ? getTranslated(context, 'commentLengthCannotBeHigherThan510')
        : null;
  }

  static String validateUpdatingPassword(
      String newPassword, String reNewPassword) {
    if (newPassword == null) {
      return 'Please enter your new password';
    } else if (newPassword.length < 6) {
      return 'Password should contain at least 6 characters';
    } else if (reNewPassword == null) {
      return 'Please retype new password';
    } else if (reNewPassword != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
