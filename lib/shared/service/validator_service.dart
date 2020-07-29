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
    } else if (rating > 5) {
      invalidMessage = getTranslated(context, 'ratingCannotBeHigherThan5');
    }
    return invalidMessage;
  }

  static String validateUpdatingComment(String comment, BuildContext context) {
    return comment != null && comment.length > 510
        ? getTranslated(context, 'commentLengthCannotBeHigherThan510')
        : null;
  }
}
