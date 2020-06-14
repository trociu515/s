import 'package:flutter/cupertino.dart';

class ManagerGroupDetailsDto {
  final int employeeId;
  final String employeeInfo;
  final int numberOfHoursWorked;
  final double moneyPerHour;
  final double amountOfEarnedMoney;

  ManagerGroupDetailsDto({
    @required this.employeeId,
    @required this.employeeInfo,
    @required this.numberOfHoursWorked,
    @required this.moneyPerHour,
    @required this.amountOfEarnedMoney,
  });

  factory ManagerGroupDetailsDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupDetailsDto(
      employeeId: json['employeeId'] as int,
      employeeInfo: json['employeeInfo'] as String,
      numberOfHoursWorked: json['numberOfHoursWorked'] as int,
      moneyPerHour: json['moneyPerHour'] as double,
      amountOfEarnedMoney: json['amountOfEarnedMoney'] as double,
    );
  }
}
