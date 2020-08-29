import 'package:flutter/cupertino.dart';

class ManagerGroupTimeSheetDto {
  final int id;
  final int year;
  final String month;

  ManagerGroupTimeSheetDto({
    @required this.id,
    @required this.year,
    @required this.month,
  });

  factory ManagerGroupTimeSheetDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupTimeSheetDto(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as String,
    );
  }
}
