import 'package:flutter/cupertino.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';

import 'constants.dart';

class MonthUtil {
  static String translateMonth(BuildContext context, String toTranslate) {
    switch (toTranslate) {
      case JANUARY:
        return getTranslated(context, 'january');
      case FEBRUARY:
        return getTranslated(context, 'february');
      case MARCH:
        return getTranslated(context, 'march');
      case APRIL:
        return getTranslated(context, 'april');
      case MAY:
        return getTranslated(context, 'may');
      case JUNE:
        return getTranslated(context, 'june');
      case JULY:
        return getTranslated(context, 'july');
      case AUGUST:
        return getTranslated(context, 'august');
      case SEPTEMBER:
        return getTranslated(context, 'september');
      case OCTOBER:
        return getTranslated(context, 'october');
      case NOVEMBER:
        return getTranslated(context, 'november');
      case DECEMBER:
        return getTranslated(context, 'december');
    }
    throw 'Wrong month to translate!';
  }
}
