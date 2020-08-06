import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';

Container employeeInfoTab(BuildContext context, EmployeeDto employee) {
  // Basic informations //
  String username = utf8.decode(employee.username != null
      ? employee.username.runes.toList()
      : getTranslated(context, 'empty'));
  String dateOfBirth = employee.dateOfBirth != null
      ? employee.dateOfBirth
      : getTranslated(context, 'empty');
  String fatherName = employee.fatherName != null
      ? utf8.decode(employee.fatherName.runes.toList())
      : getTranslated(context, 'empty');
  String motherName = employee.motherName != null
      ? utf8.decode(employee.motherName.runes.toList())
      : getTranslated(context, 'empty');
  String expirationDateOfWork = employee.expirationDateOfWork != null
      ? employee.expirationDateOfWork
      : getTranslated(context, 'empty');
  String nip =
      employee.nip != null ? employee.nip : getTranslated(context, 'empty');
  String bankAccountNumber = employee.bankAccountNumber != null
      ? employee.bankAccountNumber
      : getTranslated(context, 'empty');
  String moneyPerHour = employee.moneyPerHour != null
      ? employee.moneyPerHour.toString()
      : getTranslated(context, 'empty');
  String drivingLicense = employee.drivingLicense != null
      ? employee.drivingLicense
      : getTranslated(context, 'empty');

  // Passport //
  String passportNumber = employee.passportNumber != null
      ? employee.passportNumber
      : getTranslated(context, 'empty');
  String passportReleaseDate = employee.passportReleaseDate != null
      ? employee.passportReleaseDate
      : getTranslated(context, 'empty');
  String passportExpirationDate = employee.passportExpirationDate != null
      ? employee.passportExpirationDate
      : getTranslated(context, 'empty');

  // Address //
  String locality = employee.locality != null
      ? utf8.decode(employee.locality.runes.toList())
      : getTranslated(context, 'empty');
  String zipCode = employee.zipCode != null
      ? employee.zipCode
      : getTranslated(context, 'empty');
  String street = employee.street != null
      ? utf8.decode(employee.street.runes.toList())
      : getTranslated(context, 'empty');
  String houseNumber = employee.houseNumber != null
      ? employee.houseNumber.toString()
      : getTranslated(context, 'empty');

  // Contact //
  String email =
      employee.email != null ? employee.email : getTranslated(context, 'empty');
  String phoneNumber = employee.phoneNumber != null
      ? employee.phoneNumber
      : getTranslated(context, 'empty');
  String viberNumber = employee.viberNumber != null
      ? employee.viberNumber
      : getTranslated(context, 'empty');
  String whatsAppNumber = employee.whatsAppNumber != null
      ? employee.whatsAppNumber
      : getTranslated(context, 'empty');

  // Group //
  String groupId = employee.groupId != null
      ? employee.groupId.toString()
      : getTranslated(context, 'empty');
  String groupName = employee.groupName != null && employee.groupName != 'Brak'
      ? utf8.decode(employee.groupName.runes.toList())
      : getTranslated(context, 'empty');
  String groupCountryOfWork = employee.groupCountryOfWork != null &&
          employee.groupCountryOfWork != 'Brak'
      ? utf8.decode(employee.groupCountryOfWork.runes.toList())
      : getTranslated(context, 'empty');
  String groupDescription =
      employee.groupDescription != null && employee.groupDescription != 'Brak'
      ? utf8.decode(employee.groupDescription.runes.toList())
      : getTranslated(context, 'empty');
  String groupManager =
      employee.groupManager != null && employee.groupManager != 'Brak'
      ? utf8.decode(employee.groupManager.runes.toList())
      : getTranslated(context, 'empty');

  informations = [
    new Information(
      getTranslated(context, 'info'),
      [
        getTranslated(context, 'username') + '//$username',
        getTranslated(context, 'dateOfBirth') + '//$dateOfBirth',
        getTranslated(context, 'fatherName') + '//$fatherName',
        getTranslated(context, 'motherName') + '//$motherName',
        getTranslated(context, 'expirationDateOfWork') + '//$expirationDateOfWork',
        getTranslated(context, 'nip') + '//$nip',
        getTranslated(context, 'bankAccountNumber') + '//$bankAccountNumber',
        getTranslated(context, 'moneyPerHour') + '//$moneyPerHour',
        getTranslated(context, 'drivingLicense') + '//$drivingLicense',
        getTranslated(context, 'passportNumber') + '//$passportNumber',
        getTranslated(context, 'passportReleaseDate') + '//$passportReleaseDate',
        getTranslated(context, 'passportExpirationDate') + '//$passportExpirationDate'
      ],
      Icon(
        Icons.person_outline,
        color: WHITE,
      ),
    ),
    new Information(
      'Passport',
      [
        getTranslated(context, 'passportNumber') + '//$passportNumber',
        getTranslated(context, 'passportReleaseDate') + '//$passportReleaseDate',
        getTranslated(context, 'passportExpirationDate') + '//$passportExpirationDate',
      ],
      Icon(
        Icons.credit_card,
        color: WHITE,
      ),
    ),
    new Information(
      getTranslated(context, 'address'),
      [
        getTranslated(context, 'locality') + '//$locality',
        getTranslated(context, 'zipCode') + '//$zipCode',
        getTranslated(context, 'street') + '//$street',
        getTranslated(context, 'houseNumber') + '//$houseNumber'
      ],
      Icon(
        Icons.person_pin,
        color: WHITE,
      ),
    ),
    new Information(
      getTranslated(context, 'contact'),
      [
        getTranslated(context, 'email') + '//$email',
        getTranslated(context, 'phoneNumber') + '//$phoneNumber',
        getTranslated(context, 'viberNumber') + '//$viberNumber',
        getTranslated(context, 'whatsAppNumber') + '//$whatsAppNumber',
      ],
      Icon(
        Icons.phone_in_talk,
        color: WHITE,
      ),
    ),
    new Information(
      getTranslated(context, 'group'),
      [
        getTranslated(context, 'groupId') + '//$groupId',
        getTranslated(context, 'groupName') + '//$groupName',
        getTranslated(context, 'groupCountryOfWork') + '//$groupCountryOfWork',
        getTranslated(context, 'groupDescription') + '//$groupDescription',
        getTranslated(context, 'groupManager') + '//$groupManager',
      ],
      Icon(
        Icons.people,
        color: WHITE,
      ),
    ),
  ];

  return Container(
    child: ListView.builder(
      itemCount: informations.length,
      itemBuilder: (context, i) {
        return ExpansionTile(
          title: Text(
            informations[i].title,
            style: TextStyle(
                color: WHITE,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          children: <Widget>[
            Column(
              children: _buildExpandableContent(informations[i], employee),
            ),
          ],
        );
      },
    ),
  );
}

_buildExpandableContent(Information information, EmployeeDto employee) {
  List<Widget> columnContent = [];

  for (String content in information.titleContents)
    columnContent.add(
      ListTile(
        title: Text(
          content.split('//')[0],
          style: TextStyle(color: WHITE, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          content.split('//')[1],
          style: TextStyle(color: WHITE),
        ),
      ),
    );

  return columnContent;
}

class Information {
  final String title;
  List<String> titleContents = [];
  final Icon icon;

  Information(this.title, this.titleContents, this.icon);
}

List<Information> informations = [];
