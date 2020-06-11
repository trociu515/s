import 'dart:convert';
import 'dart:io';

import 'package:give_job/employee/dto/employee_time_sheet_dto.dart';
import 'package:http/http.dart';

import '../../main.dart';

class EmployeeTimeSheetService {
  final String baseEmployeeUrl = SERVER_IP + '/mobile/time-sheets';

  Future<List<EmployeeTimeSheetDto>> findEmployeeTimeSheetsById(
      String id, String authHeader) async {
    Response res = await get(
      baseEmployeeUrl + '/${int.parse(id)}',
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
}
