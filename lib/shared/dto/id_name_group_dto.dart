import 'package:flutter/cupertino.dart';

class IdNameGroupDto {
  final int id;
  final String name;

  IdNameGroupDto({
    @required this.id,
    @required this.name,
  });

  factory IdNameGroupDto.fromJson(Map<String, dynamic> json) {
    return IdNameGroupDto(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
