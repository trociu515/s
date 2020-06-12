import 'package:flutter/cupertino.dart';

class ManagerGroupOverviewDto {
  final int id;
  final String name;
  final int numberOfEmployees;

  ManagerGroupOverviewDto({
    @required this.id,
    @required this.name,
    @required this.numberOfEmployees,
  });

  factory ManagerGroupOverviewDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupOverviewDto(
      id: json['id'] as int,
      name: json['name'] as String,
      numberOfEmployees: json['numberOfEmployees'] as int,
    );
  }
}
