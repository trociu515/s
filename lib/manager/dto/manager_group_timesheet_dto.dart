import 'package:flutter/cupertino.dart';

class ManagerGroupTimesheetDto {
  final int id;
  final int year;
  final String month;
  final String status;

  ManagerGroupTimesheetDto({
    @required this.id,
    @required this.year,
    @required this.month,
    @required this.status,
  });

  factory ManagerGroupTimesheetDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupTimesheetDto(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as String,
      status: json['status'] as String,
    );
  }
}
