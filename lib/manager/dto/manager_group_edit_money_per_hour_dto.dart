import 'package:flutter/cupertino.dart';

class ManagerGroupEditMoneyPerHourDto {
  final int employeeId;
  final String employeeInfo;
  final String employeeNationality;
  final String currency;
  final double moneyPerHour;

  ManagerGroupEditMoneyPerHourDto({
    @required this.employeeId,
    @required this.employeeInfo,
    @required this.employeeNationality,
    @required this.currency,
    @required this.moneyPerHour,
  });

  factory ManagerGroupEditMoneyPerHourDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupEditMoneyPerHourDto(
      employeeId: json['employeeId'] as int,
      employeeInfo: json['employeeInfo'] as String,
      employeeNationality: json['employeeNationality'] as String,
      currency: json['currency'] as String,
      moneyPerHour: json['moneyPerHour'] as double,
    );
  }
}
