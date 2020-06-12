import 'package:flutter/cupertino.dart';

class ManagerDto {
  final String username;
  final String name;
  final String surname;
  final int numberOfGroups;
  final int numberOfEmployeesInGroups;

  ManagerDto({
    @required this.username,
    @required this.name,
    @required this.surname,
    @required this.numberOfGroups,
    @required this.numberOfEmployeesInGroups,
  });

  factory ManagerDto.fromJson(Map<String, dynamic> json) {
    return ManagerDto(
      username: json['username'] as String,
      name: json['name'] as String,
      surname: json['surname'] as String,
      numberOfGroups: json['numberOfGroups'] as int,
      numberOfEmployeesInGroups: json['numberOfEmployeesInGroups'] as int,
    );
  }
}
