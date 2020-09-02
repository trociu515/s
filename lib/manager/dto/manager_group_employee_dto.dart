import 'package:flutter/cupertino.dart';

class ManagerGroupEmployeeDto {
  final int employeeId;
  final String employeeInfo;
  final String employeeNationality;
  final String currency;
  final double averageEmployeeRating;
  final int numberOfHoursWorked;
  final double moneyPerHour;
  final double amountOfEarnedMoney;

  ManagerGroupEmployeeDto({
    @required this.employeeId,
    @required this.employeeInfo,
    @required this.employeeNationality,
    @required this.currency,
    @required this.averageEmployeeRating,
    @required this.numberOfHoursWorked,
    @required this.moneyPerHour,
    @required this.amountOfEarnedMoney,
  });

  factory ManagerGroupEmployeeDto.fromJson(
      Map<String, dynamic> json) {
    return ManagerGroupEmployeeDto(
      employeeId: json['employeeId'] as int,
      employeeInfo: json['employeeInfo'] as String,
      employeeNationality: json['employeeNationality'] as String,
      currency: json['currency'] as String,
      averageEmployeeRating: json['averageEmployeeRating'] as double,
      numberOfHoursWorked: json['numberOfHoursWorked'] as int,
      moneyPerHour: json['moneyPerHour'] as double,
      amountOfEarnedMoney: json['amountOfEarnedMoney'] as double,
    );
  }
}
