import 'package:flutter/cupertino.dart';

class IdNameGroupDto {
  final int id;
  final String groupName;

  IdNameGroupDto({
    @required this.id,
    @required this.groupName,
  });

  factory IdNameGroupDto.fromJson(Map<String, dynamic> json) {
    return IdNameGroupDto(
      id: json['id'] as int,
      groupName: json['groupName'] as String,
    );
  }
}
