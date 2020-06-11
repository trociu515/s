import 'package:flutter/cupertino.dart';

class EmployeeTimeSheetDto {
  final int id;
  final int year;
  final String month;
  final String groupName;
  final String status;
  final int totalHours;
  final double averageEmployeeRating;
  final double totalMoneyEarned;

  EmployeeTimeSheetDto({
    @required this.id,
    @required this.year,
    @required this.month,
    @required this.groupName,
    @required this.status,
    @required this.totalHours,
    @required this.averageEmployeeRating,
    @required this.totalMoneyEarned,
  });

  factory EmployeeTimeSheetDto.fromJson(Map<String, dynamic> json) {
    return EmployeeTimeSheetDto(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as String,
      groupName: json['groupName'] as String,
      status: json['status'] as String,
      totalHours: json['totalHours'] as int,
      averageEmployeeRating: json['averageEmployeeRating'] as double,
      totalMoneyEarned: json['totalMoneyEarned'] as double,
    );
  }
}
