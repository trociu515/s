import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_dto.dart';
import 'package:give_job/main.dart';
import 'package:http/http.dart';

class EmployeeService {
  final String baseEmployeeUrl = SERVER_IP + '/mobile/employees';

  Future<EmployeeDto> findById(String id) async {
    print(storage.read(key: 'authorization').then((String authHeader) async {
      if (authHeader == null) {
        throw 'User is not authenticated';
      }
      Response res = await get(
        baseEmployeeUrl + '/${int.parse(id)}',
        headers: {HttpHeaders.authorizationHeader: authHeader},
      );
      if (res.statusCode == 200) {
        dynamic body = jsonDecode(res.body);
        return EmployeeDto.fromJson(body);
      }
      throw 'Cannot find employee by id';
    }));
  }
}
