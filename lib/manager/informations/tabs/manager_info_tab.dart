import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_job/employee/model/information.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

Container managerInfoTab(BuildContext context, ManagerDto manager) {
  String username = utf8.decode(manager.username != null
      ? manager.username.runes.toList()
      : getTranslated(context, 'empty'));
  String nationality =
      manager.nationality != null && manager.nationality != 'Brak'
          ? LanguageUtil.findFlagByNationality(manager.nationality) +
              ' ' +
              utf8.decode(manager.nationality.runes.toList())
          : getTranslated(context, 'empty');
  String email = utf8.decode(manager.email != null
      ? manager.email.runes.toList()
      : getTranslated(context, 'empty'));
  String phoneNumber = utf8.decode(manager.phoneNumber != null
      ? manager.phoneNumber.runes.toList()
      : getTranslated(context, 'empty'));
  String viberNumber = utf8.decode(manager.viberNumber != null
      ? manager.viberNumber.runes.toList()
      : getTranslated(context, 'empty'));
  String whatsAppNumber = utf8.decode(manager.whatsAppNumber != null
      ? manager.whatsAppNumber.runes.toList()
      : getTranslated(context, 'empty'));
  int numberOfGroups = manager.numberOfGroups;
  int numberOfEmployeesInGroups = manager.numberOfEmployeesInGroups;

  informations = [
    Information(
      getTranslated(context, 'basicInformations'),
      [
        getTranslated(context, 'username') + '//$username',
        getTranslated(context, 'nationality') + '//$nationality',
      ],
      iconWhite(Icons.person_outline),
    ),
    Information(
      getTranslated(context, 'contact'),
      [
        getTranslated(context, 'email') + '//$email',
        getTranslated(context, 'phoneNumber') + '//$phoneNumber',
        getTranslated(context, 'viberNumber') + '//$viberNumber',
        getTranslated(context, 'whatsAppNumber') + '//$whatsAppNumber',
      ],
      iconWhite(Icons.phone_in_talk),
    ),
    Information(
      getTranslated(context, 'group'),
      [
        getTranslated(context, 'numberOfGroups') + '//$numberOfGroups',
        getTranslated(context, 'numberOfEmployeesInGroups') +
            '//$numberOfEmployeesInGroups',
      ],
      iconWhite(Icons.people),
    ),
  ];

  return Container(
    child: ListView.builder(
      itemCount: informations.length,
      itemBuilder: (context, i) {
        return ExpansionTile(
          initiallyExpanded: true,
          backgroundColor: BRIGHTER_DARK,
          title: text20WhiteItalic(informations[i].title),
          children: <Widget>[
            Column(
              children: _buildExpandableContent(informations[i], manager),
            ),
          ],
          leading: informations[i].icon,
        );
      },
    ),
  );
}

_buildExpandableContent(Information information, ManagerDto manager) {
  List<Widget> columnContent = [];

  for (String content in information.titleContents)
    columnContent.add(
      ListTile(
        title: textWhiteBold(content.split('//')[0]),
        subtitle: textWhite(content.split('//')[1]),
      ),
    );

  return columnContent;
}

List<Information> informations = [];
