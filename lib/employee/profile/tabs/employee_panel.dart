import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

import 'contact/manager_contact.dart';

Container employeePanel(BuildContext context, EmployeeDto employee) {
  String managerEmail = employee.groupManagerEmail;
  String managerPhone = employee.groupManagerPhone;
  String managerViber = employee.groupManagerViber;
  String managerWhatsApp = employee.groupManagerWhatsApp;
  return Container(
    child: SingleChildScrollView(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              color: BRIGHTER_DARK,
              child: InkWell(
                onTap: () => showManagerContact(context, managerEmail,
                    managerPhone, managerViber, managerWhatsApp),
                child: _buildScrollableContainer(
                    context, Icons.phone, 'contact', 'contactWithYourManager'),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: Material(color: DARK)),
        ],
      ),
    ),
  );
}

Widget _buildScrollableContainer(
    BuildContext context, IconData icon, String title, String subtitle) {
  return Container(
    height: 120,
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          icon50Green(icon),
          text18WhiteBold(getTranslated(context, title)),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: textCenter13White(getTranslated(context, subtitle))),
          SizedBox(height: 10)
        ],
      ),
    ),
  );
}
