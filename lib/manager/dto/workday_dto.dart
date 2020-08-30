import 'package:flutter/cupertino.dart';

class WorkdayDto {
  final int id;
  final int number;
  final int hours;
  final int rating;
  final String dayPlan;
  final String opinion;
  final double money;

  WorkdayDto({
    @required this.id,
    @required this.number,
    @required this.hours,
    @required this.rating,
    @required this.dayPlan,
    @required this.opinion,
    @required this.money,
  });

  factory WorkdayDto.fromJson(Map<String, dynamic> json) {
    return WorkdayDto(
      id: json['id'] as int,
      number: json['number'] as int,
      hours: json['hours'] as int,
      rating: json['rating'] as int,
      dayPlan: json['dayPlan'] as String,
      opinion: json['opinion'] as String,
      money: json['money'] as double,
    );
  }
}
