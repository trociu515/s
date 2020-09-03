import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class WorkdayUtil {
  static void showPlanDetails(BuildContext context, String plan) {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Plan details'),
            SizedBox(height: 20),
            text20White(plan != null
                ? utf8.decode(plan.runes.toList())
                : getTranslated(context, 'empty')),
          ],
        ),
      ),
    );
  }

  static void showOpinionDetails(BuildContext context, String opinion) {
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Opinion details'),
            SizedBox(height: 20),
            text20White(opinion != null
                ? utf8.decode(opinion.runes.toList())
                : getTranslated(context, 'empty')),
          ],
        ),
      ),
    );
  }
}
