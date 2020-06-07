import 'package:flutter/cupertino.dart';
import 'package:give_job/shared/group.dto/id_name_group_dto.dart';

class EmployeeDto {
  final int id;
  final String username;
  final String name;
  final String surname;
  final DateTime dateOfBirth;
  final String fatherName;
  final String motherName;
  final DateTime expirationDateOfWorkInPoland;
  final String nip;
  final String bankAccountNumber;
  final double moneyPerHour;
  final String drivingLicense;
  final int houseNumber;
  final String street;
  final String zipCode;
  final String locality;
  final String passportNumber;
  final DateTime passportReleaseDate;
  final DateTime passportExpirationDate;
  final IdNameGroupDto groupDto;

  EmployeeDto({
    @required this.id,
    @required this.username,
    @required this.name,
    @required this.surname,
    @required this.dateOfBirth,
    @required this.fatherName,
    @required this.motherName,
    @required this.expirationDateOfWorkInPoland,
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
    @required this.groupDto,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      id: json['id'] as int,
      username: json['username'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      dateOfBirth: json['dateOfBirth'] as DateTime,
      fatherName: json['fatherName'] as String,
      motherName: json['motherName'] as String,
      expirationDateOfWorkInPoland:
          json['expirationDateOfWorkInPoland'] as DateTime,
      nip: json['nip'] as String,
      bankAccountNumber: json['bankAccountNumber'] as String,
      moneyPerHour: json['moneyPerHour'] as double,
      drivingLicense: json['drivingLicense'] as String,
      houseNumber: json['houseNumber'] as int,
      street: json['street'] as String,
      zipCode: json['zipCode'] as String,
      locality: json['locality'] as String,
      passportNumber: json['passportNumber'] as String,
      passportReleaseDate: json['passportReleaseDate'] as DateTime,
      passportExpirationDate: json['passportExpirationDate'] as DateTime,
      groupDto: json['groupDto'] as IdNameGroupDto,
    );
  }
}
