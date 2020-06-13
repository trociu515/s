import 'package:flutter/cupertino.dart';

class ManagerGroupOverviewDto {
  final int id;
  final String name;
  final String description;
  final int numberOfEmployees;

  ManagerGroupOverviewDto({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.numberOfEmployees,
  });

  factory ManagerGroupOverviewDto.fromJson(Map<String, dynamic> json) {
    return ManagerGroupOverviewDto(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      numberOfEmployees: json['numberOfEmployees'] as int,
    );
  }
}
