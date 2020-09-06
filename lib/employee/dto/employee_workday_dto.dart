import 'package:flutter/cupertino.dart';

class EmployeeWorkdayDto {
  final int id;
  final int number;
  final int hours;
  final String plan;
  final double money;

  EmployeeWorkdayDto({
    @required this.id,
    @required this.number,
    @required this.hours,
    @required this.plan,
    @required this.money,
  });

  factory EmployeeWorkdayDto.fromJson(Map<String, dynamic> json) {
    return EmployeeWorkdayDto(
      id: json['id'] as int,
      number: json['number'] as int,
      hours: json['hours'] as int,
      plan: json['plan'] as String,
      money: json['money'] as double,
    );
  }
}
