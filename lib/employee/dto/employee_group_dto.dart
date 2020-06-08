import 'package:flutter/cupertino.dart';

class EmployeeGroupDto {
  final int groupId;
  final String groupName;
  final String groupDescription;
  final String groupManager;

  EmployeeGroupDto({
    @required this.groupId,
    @required this.groupName,
    @required this.groupDescription,
    @required this.groupManager,
  });

  factory EmployeeGroupDto.fromJson(Map<String, dynamic> json) {
    return EmployeeGroupDto(
      groupId: json['groupId'] as int,
      groupName: json['groupName'] as String,
      groupDescription: json['groupDescription'] as String,
      groupManager: json['groupManager'] as String,
    );
  }
}
