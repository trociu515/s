import 'package:flutter/cupertino.dart';

class ManagerEmployeeContactDto {
  final String email;
  final String phoneNumber;
  final String viberNumber;
  final String whatsAppNumber;

  ManagerEmployeeContactDto({
    @required this.email,
    @required this.phoneNumber,
    @required this.viberNumber,
    @required this.whatsAppNumber,
  });

  factory ManagerEmployeeContactDto.fromJson(Map<String, dynamic> json) {
    return ManagerEmployeeContactDto(
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      viberNumber: json['viberNumber'] as String,
      whatsAppNumber: json['whatsAppNumber'] as String,
    );
  }
}
