import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/main.dart';
import 'package:http/http.dart';

class EmployeeService {
  final String _baseEmployeeUrl = SERVER_IP + '/mobile/employees';

  Future<EmployeeDto> findById(String id, String authHeader) async {
    Response res = await get(
      _baseEmployeeUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return EmployeeDto.fromJson(jsonDecode(res.body));
    }
    throw 'Cannot find employee by id';
  }
}
