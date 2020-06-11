import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/employee/dto/employee_group_dto.dart';
import 'package:give_job/main.dart';
import 'package:give_job/shared/group.dto/id_name_group_dto.dart';
import 'package:http/http.dart';

class EmployeeService {
  final String baseEmployeeUrl = SERVER_IP + '/mobile/employees';

  Future<EmployeeDto> findById(String id, String authHeader) async {
    Response res = await get(
      baseEmployeeUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      IdNameGroupDto groupDto = IdNameGroupDto.fromJson(body['groupDto']);
      body['groupId'] = groupDto.id;
      body['groupName'] = groupDto.name;
      return EmployeeDto.fromJson(body);
    }
    throw 'Cannot find employee by id';
  }

  Future<EmployeeGroupDto> findGroupById(String id, String authHeader) async {
    Response res = await get(
      baseEmployeeUrl + '/${int.parse(id)}/group',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      dynamic body = jsonDecode(res.body);
      return EmployeeGroupDto.fromJson(body);
    } else if (res.statusCode == 400) {
      return Future.error(res.body);
    }
    return null;
  }
}
