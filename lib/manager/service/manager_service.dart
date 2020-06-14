import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/main.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:give_job/manager/dto/manager_group_details_dto.dart';
import 'package:give_job/manager/dto/manager_group_dto.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:http/http.dart';

class ManagerService {
  final String baseManagerUrl = SERVER_IP + '/mobile/managers';
  final String baseGroupUrl = SERVER_IP + '/mobile/groups';
  final String baseEmployeeUrl = SERVER_IP + '/mobile/employees';
  final String baseTimeSheetUrl = SERVER_IP + '/mobile/time-sheets';
  final String baseWorkdayUrl = SERVER_IP + '/mobile/workdays';

  Future<ManagerDto> findById(String id, String authHeader) async {
    Response res = await get(
      baseManagerUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return ManagerDto.fromJson(jsonDecode(res.body));
    }
    throw 'Cannot find manager by id';
  }

  Future<List<ManagerGroupDto>> findGroupsManager(
      String id, String authHeader) async {
    Response res = await get(
      baseGroupUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => ManagerGroupDto.fromJson(data))
          .toList();
    } else if (res.statusCode == 400) {
      return Future.error(res.body);
    }
    return null;
  }

  Future<List<ManagerGroupDetailsDto>> findEmployeesGroupDetails(
      String groupId, String authHeader) async {
    Response res = await get(
      baseEmployeeUrl + '/groups/${int.parse(groupId)}/details',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => ManagerGroupDetailsDto.fromJson(data))
          .toList();
    } else if (res.statusCode == 400) {
      return Future.error(res.body);
    }
    return null;
  }

  Future<List<EmployeeTimeSheetDto>>
      findEmployeeTimeSheetsByGroupIdAndEmployeeId(
          String groupId, String employeeId, String authHeader) async {
    Response res = await get(
      baseTimeSheetUrl +
          '/groups/${int.parse(groupId)}/employees/${int.parse(employeeId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => EmployeeTimeSheetDto.fromJson(data))
          .toList();
    } else if (res.statusCode == 400) {
      return Future.error(res.body);
    }
    return null;
  }

  Future<List<WorkdayDto>> findWorkdaysByTimeSheetId(
      String timeSheetId, String authHeader) async {
    Response res = await get(
      baseWorkdayUrl + '/${int.parse(timeSheetId)}',
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
}
