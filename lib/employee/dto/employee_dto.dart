import 'package:flutter/cupertino.dart';

class EmployeeDto {
  final String username;
  final String nationality;
  final String dateOfBirth;
  final String fatherName;
  final String motherName;
  final String expirationDateOfWork;
  final String nip;
  final String bankAccountNumber;
  final double moneyPerHour;
  final String drivingLicense;
  final int houseNumber;
  final String street;
  final String zipCode;
  final String locality;
  final String passportNumber;
  final String passportReleaseDate;
  final String passportExpirationDate;
  final String email;
  final String phoneNumber;
  final String viberNumber;
  final String whatsAppNumber;
  final int groupId;
  final String groupName;
  final String groupCountryOfWork;
  final String groupDescription;
  final String groupManager;
  final String currentDate;
  final num daysWorkedInCurrentMonth;
  final num ratingInCurrentMonth;
  final num earnedMoneyInCurrentMonth;

  EmployeeDto({
    @required this.username,
    @required this.nationality,
    @required this.dateOfBirth,
    @required this.fatherName,
    @required this.motherName,
    @required this.expirationDateOfWork,
    @required this.nip,
    @required this.bankAccountNumber,
    @required this.moneyPerHour,
    @required this.drivingLicense,
    @required this.houseNumber,
    @required this.street,
    @required this.zipCode,
    @required this.locality,
    @required this.passportNumber,
    @required this.passportReleaseDate,
    @required this.passportExpirationDate,
    @required this.email,
    @required this.phoneNumber,
    @required this.viberNumber,
    @required this.whatsAppNumber,
    @required this.groupId,
    @required this.groupName,
    @required this.groupCountryOfWork,
    @required this.groupDescription,
    @required this.groupManager,
    @required this.currentDate,
    @required this.daysWorkedInCurrentMonth,
    @required this.ratingInCurrentMonth,
    @required this.earnedMoneyInCurrentMonth,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      username: json['username'] as String,
      nationality: json['nationality'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      fatherName: json['fatherName'] as String,
      motherName: json['motherName'] as String,
      expirationDateOfWork: json['expirationDateOfWork'] as String,
      nip: json['nip'] as String,
      bankAccountNumber: json['bankAccountNumber'] as String,
      moneyPerHour: json['moneyPerHour'] as double,
      drivingLicense: json['drivingLicense'] as String,
      houseNumber: json['houseNumber'] as int,
      street: json['street'] as String,
      zipCode: json['zipCode'] as String,
      locality: json['locality'] as String,
      passportNumber: json['passportNumber'] as String,
      passportReleaseDate: json['passportReleaseDate'] as String,
      passportExpirationDate: json['passportExpirationDate'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      viberNumber: json['viberNumber'] as String,
      whatsAppNumber: json['whatsAppNumber'] as String,
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      groupCountryOfWork: json['groupCountryOfWork'] as String,
      groupDescription: json['groupDescription'] as String,
      groupManager: json['groupManager'] as String,
      currentDate: json['currentDate'] as String,
      daysWorkedInCurrentMonth: json['daysWorkedInCurrentMonth'] as num,
      ratingInCurrentMonth: json['ratingInCurrentMonth'] as num,
      earnedMoneyInCurrentMonth: json['earnedMoneyInCurrentMonth'] as num,
    );
  }
}
