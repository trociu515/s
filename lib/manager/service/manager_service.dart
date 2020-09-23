import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_timesheet_dto.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:give_job/manager/dto/manager_employee_contact_dto.dart';
import 'package:give_job/manager/dto/manager_group_details_dto.dart';
import 'package:give_job/manager/dto/manager_group_dto.dart';
import 'package:give_job/manager/dto/manager_group_employee_dto.dart';
import 'package:give_job/manager/dto/manager_group_timesheet_dto.dart';
import 'package:give_job/manager/dto/manager_vocations_ts_dto.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class ManagerService {
  static const String _baseUrl = '/mobile';
  static const String _baseManagerUrl = SERVER_IP + '$_baseUrl/managers';
  static const String _baseGroupUrl = SERVER_IP + '$_baseUrl/groups';
  static const String _baseEmployeeUrl = SERVER_IP + '$_baseUrl/employees';
  static const String _baseTimesheetUrl = SERVER_IP + '$_baseUrl/timesheets';
  static const String _baseWorkdayUrl = SERVER_IP + '$_baseUrl/workdays';
  static const String _baseContactUrl = SERVER_IP + '$_baseUrl/contacts';

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

  Future<List<EmployeeTimesheetDto>>
      findEmployeeTimesheetsByGroupIdAndEmployeeId(
          String groupId, String employeeId, String authHeader) async {
    Response res = await get(
      _baseTimesheetUrl +
          '/groups/${int.parse(groupId)}/employees/${int.parse(employeeId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => EmployeeTimesheetDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<ManagerGroupTimesheetDto>> findTimesheetsByGroupId(
      String groupId, String authHeader) async {
    Response res = await get(
      _baseTimesheetUrl + '/groups/${int.parse(groupId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => ManagerGroupTimesheetDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<ManagerGroupEmployeeDto>>
      findAllEmployeesOfTimesheetByGroupIdAndTimesheetYearMonthStatusForMobile(
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
            .map((data) => ManagerGroupEmployeeDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<List<ManagerVocationsTsDto>>
      findAllForVocationsTsByGroupIdAndTimesheetYearMonthStatusForMobile(
          int groupId,
          int year,
          int month,
          String status,
          String authHeader) async {
    Response res = await get(
      _baseEmployeeUrl +
          '/groups/$groupId/vocations/time-sheets/$year/$month/$status',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => ManagerVocationsTsDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }

  Future<ManagerEmployeeContactDto> findEmployeeContactByEmployeeId(
      int employeeId, String authHeader) async {
    Response res = await get(
      _baseContactUrl + '/$employeeId',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? ManagerEmployeeContactDto.fromJson(jsonDecode(res.body))
        : throw 'Cannot find employee contact by employee id';
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

  Future<dynamic> updateWorkdaysPlan(
      Set<int> workdayIds, String plan, String authHeader) async {
    Map<String, dynamic> map = {
      'workdayIds': workdayIds.map((el) => el.toString()).toList(),
      'plan': plan
    };
    Response res = await put(
      _baseWorkdayUrl + '/plan',
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

  Future<dynamic> updateWorkdaysOpinion(
      Set<int> workdayIds, String opinion, String authHeader) async {
    Map<String, dynamic> map = {
      'workdayIds': workdayIds.map((el) => el.toString()).toList(),
      'opinion': opinion
    };
    Response res = await put(
      _baseWorkdayUrl + '/opinion',
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
      Set<int> employeesId,
      int timesheetYear,
      int timesheetMonth,
      String timesheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'hours': hours,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId.map((el) => el.toInt()).toList(),
      'timesheetYear': timesheetYear,
      'timesheetMonth': timesheetMonth,
      'timesheetStatus': timesheetStatus,
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
      Set<int> employeesId,
      int timesheetYear,
      int timesheetMonth,
      String timesheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'rating': rating,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId.map((el) => el.toInt()).toList(),
      'timesheetYear': timesheetYear,
      'timesheetMonth': timesheetMonth,
      'timesheetStatus': timesheetStatus,
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

  Future<dynamic> updateEmployeesPlan(
      String plan,
      String dateFrom,
      String dateTo,
      Set<int> employeesId,
      int timesheetYear,
      int timesheetMonth,
      String timesheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'plan': plan,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId.map((el) => el.toInt()).toList(),
      'timesheetYear': timesheetYear,
      'timesheetMonth': timesheetMonth,
      'timesheetStatus': timesheetStatus,
    };
    Response res = await put(
      _baseWorkdayUrl + '/group/plan',
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

  Future<dynamic> updateEmployeesOpinion(
      String opinion,
      String dateFrom,
      String dateTo,
      Set<int> employeesId,
      int timesheetYear,
      int timesheetMonth,
      String timesheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'opinion': opinion,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId.map((el) => el.toInt()).toList(),
      'timesheetYear': timesheetYear,
      'timesheetMonth': timesheetMonth,
      'timesheetStatus': timesheetStatus,
    };
    Response res = await put(
      _baseWorkdayUrl + '/group/opinion',
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

  Future<dynamic> updateGroupHoursOfTodaysDateInCurrentTimesheet(
      int groupId, String date, int hours, String authHeader) async {
    Map<String, dynamic> map = {
      'groupId': groupId,
      'date': date,
      'hours': hours,
    };
    Response res = await put(
      _baseTimesheetUrl + '/group/date/hours',
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

  Future<dynamic> updateGroupRatingOfTodaysDateInCurrentTimesheet(
      int groupId, String date, int rating, String authHeader) async {
    Map<String, dynamic> map = {
      'groupId': groupId,
      'date': date,
      'rating': rating,
    };
    Response res = await put(
      _baseTimesheetUrl + '/group/date/rating',
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

  Future<dynamic> updateGroupPlanOfTodaysDateInCurrentTimesheet(
      int groupId, String date, String plan, String authHeader) async {
    Map<String, dynamic> map = {
      'groupId': groupId,
      'date': date,
      'plan': plan,
    };
    Response res = await put(
      _baseTimesheetUrl + '/group/date/plan',
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

  Future<dynamic> updateGroupOpinionOfTodaysDateInCurrentTimesheet(
      int groupId, String date, String opinion, String authHeader) async {
    Map<String, dynamic> map = {
      'groupId': groupId,
      'date': date,
      'opinion': opinion,
    };
    Response res = await put(
      _baseTimesheetUrl + '/group/date/opinion',
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

  Future<dynamic> createOrUpdateVocation(
      String reason,
      String dateFrom,
      String dateTo,
      Set<int> employeesId,
      int timesheetYear,
      int timesheetMonth,
      String timesheetStatus,
      String authHeader) async {
    Map<String, dynamic> map = {
      'reason': reason,
      'isVerified': true,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'employeesId': employeesId.map((el) => el.toInt()).toList(),
      'timesheetYear': timesheetYear,
      'timesheetMonth': timesheetMonth,
      'timesheetStatus': timesheetStatus,
    };
    Response res = await post(
      _baseWorkdayUrl + '/group/vocations',
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
