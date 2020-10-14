import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../employee_app_bar.dart';
import '../../employee_side_bar.dart';

class EmployeeAboutMePage extends StatefulWidget {
  User _user;
  EmployeeDto _employee;

  EmployeeAboutMePage(this._user, this._employee);

  @override
  _EmployeeAboutMePageState createState() => _EmployeeAboutMePageState();
}

class _EmployeeAboutMePageState extends State<EmployeeAboutMePage> {
  User _user;
  EmployeeDto _employee;

  @override
  Widget build(BuildContext context) {
    this._user = widget._user;
    this._employee = widget._employee;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar:
            employeeAppBar(context, _user, getTranslated(context, 'aboutMe')),
        drawer: employeeSideBar(context, _user),
        body: SingleChildScrollView(
          child: _buildGroupSection(),
        ),
      ),
    );
  }

  Widget _buildGroupSection() {
    return Column(
      children: <Widget>[
        _buildSectionTitle(getTranslated(context, 'basicInformations')),
        _buildListTile(getTranslated(context, 'dateOfBirth'), _employee.dateOfBirth),
        _buildListTile(getTranslated(context, 'fatherName'), _employee.fatherName),
        _buildListTile(getTranslated(context, 'motherName'), _employee.motherName),
        _buildListTile(getTranslated(context, 'expirationDateOfWork'), _employee.expirationDateOfWork),
        _buildListTile(getTranslated(context, 'nip'), _employee.nip),
        _buildListTile(getTranslated(context, 'bankAccountNumber'), _employee.bankAccountNumber),
        _buildListTile(getTranslated(context, 'moneyPerHour'), _employee.moneyPerHour.toString()),
        _buildListTile(getTranslated(context, 'drivingLicense'), _employee.drivingLicense),
        _buildListTile(getTranslated(context, 'passportNumber'), _employee.passportNumber),
        _buildListTile(getTranslated(context, 'passportReleaseDate'), _employee.passportReleaseDate),
        _buildListTile(getTranslated(context, 'passportExpirationDate'), _employee.passportExpirationDate),
        _buildSectionTitle(getTranslated(context, 'passport')),
        _buildListTile(getTranslated(context, 'passportNumber'), _employee.passportNumber),
        _buildListTile(getTranslated(context, 'passportReleaseDate'), _employee.passportReleaseDate),
        _buildListTile(getTranslated(context, 'passportExpirationDate'), _employee.passportExpirationDate),
        _buildSectionTitle(getTranslated(context, 'address')),
        _buildListTile(getTranslated(context, 'locality'), _employee.locality),
        _buildListTile(getTranslated(context, 'zipCode'), _employee.zipCode),
        _buildListTile(getTranslated(context, 'street'), _employee.street),
        _buildListTile(getTranslated(context, 'houseNumber'), _employee.houseNumber),
        _buildSectionTitle(getTranslated(context, 'contact')),
        _buildListTile(getTranslated(context, 'email'), _employee.email),
        _buildListTile(getTranslated(context, 'phone'), _employee.phoneNumber),
        _buildListTile(getTranslated(context, 'viber'), _employee.viberNumber),
        _buildListTile(getTranslated(context, 'whatsApp'), _employee.whatsAppNumber),
        _buildSectionTitle(getTranslated(context, 'group')),
        _buildListTile(getTranslated(context, 'groupId'), _employee.groupId.toString()),
        _buildListTile(getTranslated(context, 'groupName'), _employee.groupName),
        _buildListTile(getTranslated(context, 'groupCountryOfWork'), _employee.groupCountryOfWork),
        _buildListTile(getTranslated(context, 'groupDescription'), _employee.groupDescription),
        SizedBox(height: 20)
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 15, bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: text20GreenBold(title),
      ),
    );
  }

  Widget _buildListTile(String title, String subtile) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15),
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft, child: textGreen(title)),
          Align(alignment: Alignment.topLeft, child: text16White(subtile)),
        ],
      ),
    );
  }
}
