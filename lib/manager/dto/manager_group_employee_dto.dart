import 'package:flutter/cupertino.dart';

class ManagerGroupEmployeeDto {
  final int id;
  final String info;
  final String nationality;
  final String currency;
  final double averageEmployeeRating;
  final int numberOfHoursWorked;
  final double moneyPerHour;
  final double amountOfEarnedMoney;

  ManagerGroupEmployeeDto({
    @required this.id,
    @required this.info,
    @required this.nationality,
    @required this.currency,
    @required this.averageEmployeeRating,
    @required this.numberOfHoursWorked,
    @required this.moneyPerHour,
    @required this.amountOfEarnedMoney,
  });

  factory ManagerGroupEmployeeDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupEmployeeDto(
      id: json['id'] as int,
      info: json['info'] as String,
      nationality: json['nationality'] as String,
      currency: json['currency'] as String,
      averageEmployeeRating: json['averageEmployeeRating'] as double,
      numberOfHoursWorked: json['numberOfHoursWorked'] as int,
      moneyPerHour: json['moneyPerHour'] as double,
      amountOfEarnedMoney: json['amountOfEarnedMoney'] as double,
    );
  }
}
