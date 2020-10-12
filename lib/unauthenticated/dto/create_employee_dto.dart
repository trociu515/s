import 'package:flutter/cupertino.dart';

class CreateEmployeeDto {
  final String username;
  final String password;
  final String name;
  final String surname;
  final String fatherName;
  final String motherName;
  final String dateOfBirth;
  final String nationality;
  final String locality;
  final String zipCode;
  final String street;
  final String houseNumber;
  final String phoneNumber;
  final String viberNumber;
  final String whatsAppNumber;
  final String passportNumber;
  final String passportReleaseDate;
  final String passportExpirationDate;
  final String email;
  final String expirationDateOfWork;
  final String nip;
  final String bankAccountNumber;
  final String drivingLicense;
  final String tokenId;
  final String accountExpirationDate;

  CreateEmployeeDto({
    @required this.username,
    @required this.password,
    @required this.name,
    @required this.surname,
    @required this.fatherName,
    @required this.motherName,
    @required this.dateOfBirth,
    @required this.nationality,
    @required this.locality,
    @required this.zipCode,
    @required this.street,
    @required this.houseNumber,
    @required this.phoneNumber,
    @required this.viberNumber,
    @required this.whatsAppNumber,
    @required this.passportNumber,
    @required this.passportReleaseDate,
    @required this.passportExpirationDate,
    @required this.email,
    @required this.expirationDateOfWork,
    @required this.nip,
    @required this.bankAccountNumber,
    @required this.drivingLicense,
    @required this.tokenId,
    @required this.accountExpirationDate,
  });

  static Map<String, dynamic> jsonEncode(CreateEmployeeDto dto) {
    Map<String, dynamic> map = new Map();
    map['username'] = dto.username;
    map['password'] = dto.password;
    map['name'] = dto.name;
    map['surname'] = dto.surname;
    map['fatherName'] = dto.fatherName;
    map['motherName'] = dto.motherName;
    map['dateOfBirth'] = dto.dateOfBirth;
    map['nationality'] = dto.nationality;
    map['locality'] = dto.locality;
    map['zipCode'] = dto.zipCode;
    map['street'] = dto.street;
    map['houseNumber'] = dto.houseNumber;
    map['phoneNumber'] = dto.phoneNumber;
    map['viberNumber'] = dto.viberNumber;
    map['whatsAppNumber'] = dto.whatsAppNumber;
    map['passportNumber'] = dto.passportNumber;
    map['passportReleaseDate'] = dto.passportReleaseDate;
    map['passportExpirationDate'] = dto.passportExpirationDate;
    map['email'] = dto.email;
    map['expirationDateOfWork'] = dto.expirationDateOfWork;
    map['nip'] = dto.nip;
    map['bankAccountNumber'] = dto.bankAccountNumber;
    map['drivingLicense'] = dto.drivingLicense;
    map['tokenId'] = dto.tokenId;
    map['accountExpirationDate'] = dto.accountExpirationDate;
    return map;
  }
}
