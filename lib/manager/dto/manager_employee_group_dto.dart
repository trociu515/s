import 'package:flutter/cupertino.dart';

class ManagerEmployeeGroupDto {
  final int employeeId;
  final String employeeInfo;
  final int numberOfHoursWorked;
  final double moneyPerHour;
  final double amountOfEarnedMoney;
  final int groupId;
  final String groupName;
  final String groupDescription;

  ManagerEmployeeGroupDto({
    @required this.employeeId,
    @required this.employeeInfo,
    @required this.numberOfHoursWorked,
    @required this.moneyPerHour,
    @required this.amountOfEarnedMoney,
    @required this.groupId,
    @required this.groupName,
    @required this.groupDescription,
  });

  factory ManagerEmployeeGroupDto.fromJson(Map<String, dynamic> json) {
    return ManagerEmployeeGroupDto(
      employeeId: json['employeeId'] as int,
      employeeInfo: json['employeeInfo'] as String,
      numberOfHoursWorked: json['numberOfHoursWorked'] as int,
      moneyPerHour: json['moneyPerHour'] as double,
      amountOfEarnedMoney: json['amountOfEarnedMoney'] as double,
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      groupDescription: json['groupDescription'] as String,
    );
  }
}
