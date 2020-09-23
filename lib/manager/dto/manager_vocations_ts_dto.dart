import 'package:flutter/cupertino.dart';

class ManagerVocationsTsDto {
  final int id;
  final String info;
  final String nationality;

  ManagerVocationsTsDto({
    @required this.id,
    @required this.info,
    @required this.nationality,
  });

  factory ManagerVocationsTsDto.fromJson(Map<String, dynamic> json) {
    return ManagerVocationsTsDto(
      id: json['id'] as int,
      info: json['info'] as String,
      nationality: json['nationality'] as String,
    );
  }
}
