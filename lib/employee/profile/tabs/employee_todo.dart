import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/widget/texts.dart';

Container employeeTodaysTodo(BuildContext context, String todaysPlan) {
  if (todaysPlan == null || todaysPlan.isEmpty) {
    return _handleData('You have nothing to do today', '-');
  }
  return _handleData('Todo for today', todaysPlan);
}

Widget _handleData(String title, String subtitle) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.center,
              child: text20GreenBold(title),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: SelectableText(
              subtitle,
              style: TextStyle(
                fontSize: 19,
                color: WHITE,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
