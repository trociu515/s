import 'package:flutter/cupertino.dart';

class EmployeeDto {
  final int id;
  final String username;
  final String name;
  final String surname;
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

  EmployeeDto({
    @required this.id,
    @required this.username,
    @required this.name,
    @required this.surname,
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
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
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
    );
  }
}
