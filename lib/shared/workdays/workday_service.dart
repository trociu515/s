import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_workday_dto.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class SharedWorkdayService {
  final String _baseTimesheetUrl = SERVER_IP + '/mobile/workdays';

  Future<List<WorkdayDto>> findWorkdaysByTimesheetId(
      String timesheetId, String authHeader) async {
    Response res = await get(
      _baseTimesheetUrl + '/${int.parse(timesheetId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => WorkdayDto.fromJson(data))
          .toList();
    } else if (res.statusCode == 400) {
      return Future.error(res.body);
    }
    return null;
  }

  Future<List<EmployeeWorkdayDto>> findEmployeeWorkdaysByTimesheetId(
      String timesheetId, String authHeader) async {
    Response res = await get(
      _baseTimesheetUrl + '/${int.parse(timesheetId)}/employee',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => EmployeeWorkdayDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }
}
