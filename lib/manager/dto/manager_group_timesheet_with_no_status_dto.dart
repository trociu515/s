import 'package:flutter/cupertino.dart';

class ManagerGroupTimesheetWithNoStatusDto {
  final int id;
  final int year;
  final String month;

  ManagerGroupTimesheetWithNoStatusDto({
    @required this.id,
    @required this.year,
    @required this.month,
  });

  factory ManagerGroupTimesheetWithNoStatusDto.fromJson(
      Map<String, dynamic> json) {
    return ManagerGroupTimesheetWithNoStatusDto(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as String,
    );
  }
}
