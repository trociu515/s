import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:give_job/manager/dto/manager_group_details_dto.dart';
import 'package:give_job/manager/dto/manager_group_dto.dart';
import 'package:give_job/manager/dto/manager_group_employees_time_sheet_dto.dart';
import 'package:give_job/manager/dto/manager_group_time_sheet_dto.dart';
import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class ManagerService {
  static const String _baseUrl = '/mobile';
  static const String _baseManagerUrl = SERVER_IP + '$_baseUrl/managers';
  static const String _baseGroupUrl = SERVER_IP + '$_baseUrl/groups';
  static const String _baseEmployeeUrl = SERVER_IP + '$_baseUrl/employees';
  static const String _baseTimeSheetUrl = SERVER_IP + '$_baseUrl/time-sheets';
  static const String _baseWorkdayUrl = SERVER_IP + '$_baseUrl/workdays';

  Future<ManagerDto> findById(String id, String authHeader) async {
    Response res = await get(
      _baseManagerUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? ManagerDto.fromJson(jsonDecode(res.body))
        : throw 'Cannot find manager by id';
  }

  Future<List<ManagerGroupDto>> findGroupsManager(
      String id, String authHeader) async {
    Response res = await get(
      _baseGroupUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => ManagerGroupDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<ManagerGroupDetailsDto>> findEmployeesGroupDetails(
      String groupId, String authHeader) async {
    Response res = await get(
      _baseEmployeeUrl + '/groups/${int.parse(groupId)}/details',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => ManagerGroupDetailsDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<EmployeeTimeSheetDto>>
      findEmployeeTimeSheetsByGroupIdAndEmployeeId(
          String groupId, String employeeId, String authHeader) async {
    Response res = await get(
      _baseTimeSheetUrl +
          '/groups/${int.parse(groupId)}/employees/${int.parse(employeeId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => EmployeeTimeSheetDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<ManagerGroupTimeSheetDto>> findTimeSheetsByGroupId(
      String groupId, String authHeader) async {
    Response res = await get(
      _baseTimeSheetUrl + '/groups/${int.parse(groupId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => ManagerGroupTimeSheetDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<ManagerGroupEmployeesTimeSheetDto>>
      findAllEmployeesOfTimeSheetByGroupIdAndTimeSheetYearMonthStatusForMobile(
          int groupId,
          int year,
          int month,
          String status,
          String authHeader) async {
    Response res = await get(
      _baseEmployeeUrl + '/groups/$groupId/time-sheets/$year/$month/$status',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => ManagerGroupEmployeesTimeSheetDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<WorkdayDto>> findWorkdaysByTimeSheetId(
      String timeSheetId, String authHeader) async {
    Response res = await get(
      _baseWorkdayUrl + '/${int.parse(timeSheetId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkdayDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<dynamic> updateWorkdaysHours(
      Set<int> workdayIds, int hours, String authHeader) async {
    Map<String, dynamic> map = {
      'workdayIds': workdayIds.map((el) => el.toString()).toList(),
      'hours': hours
    };
    Response res = await put(
      _baseWorkdayUrl + '/hours',
      body: jsonEncode(map),
      headers: {
        HttpHeaders.authorizationHeader: authHeader,
        "content-type": "application/json"
      },
    );
    return res.statusCode == 200
        ? res
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<dynamic> updateWorkdaysRating(
      Set<int> workdayIds, int rating, String authHeader) async {
    Map<String, dynamic> map = {
      'workdayIds': workdayIds.map((el) => el.toString()).toList(),
      'rating': rating
    };
    Response res = await put(
      _baseWorkdayUrl + '/rating',
      body: jsonEncode(map),
      headers: {
        HttpHeaders.authorizationHeader: authHeader,
        "content-type": "application/json"
      },
    );
    return res.statusCode == 200
        ? res
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<dynamic> updateWorkdaysComment(
      Set<int> workdayIds, String comment, String authHeader) async {
    Map<String, dynamic> map = {
      'workdayIds': workdayIds.map((el) => el.toString()).toList(),
      'comment': comment
    };
    Response res = await put(
      _baseWorkdayUrl + '/comment',
      body: jsonEncode(map),
      headers: {
        HttpHeaders.authorizationHeader: authHeader,
        "content-type": "application/json"
      },
    );
    return res.statusCode == 200
        ? res
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<dynamic> updateEmployeesHours(
      int hours,
      String dateFrom,
      String dateTo,
      List<int> employeesId,
      int timeSheetYear,
      int timeSheetMonth,
      String timeSheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'hours': hours,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId,
      'timeSheetYear': timeSheetYear,
      'timeSheetMonth': timeSheetMonth,
      'timeSheetStatus': timeSheetStatus,
    };
    Response res = await put(
      _baseWorkdayUrl + '/group/hours',
      body: jsonEncode(map),
      headers: {
        HttpHeaders.authorizationHeader: authHeader,
        "content-type": "application/json"
      },
    );
    return res.statusCode == 200
        ? res
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<dynamic> updateEmployeesRating(
      int rating,
      String dateFrom,
      String dateTo,
      List<int> employeesId,
      int timeSheetYear,
      int timeSheetMonth,
      String timeSheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'rating': rating,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId,
      'timeSheetYear': timeSheetYear,
      'timeSheetMonth': timeSheetMonth,
      'timeSheetStatus': timeSheetStatus,
    };
    Response res = await put(
      _baseWorkdayUrl + '/group/rating',
      body: jsonEncode(map),
      headers: {
        HttpHeaders.authorizationHeader: authHeader,
        "content-type": "application/json"
      },
    );
    return res.statusCode == 200
        ? res
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }
}
