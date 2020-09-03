import 'dart:convert';
import 'dart:io';

import 'package:give_job/manager/dto/workday_dto.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class SharedWorkdayService {
  final String _baseTimesheetUrl = SERVER_IP + '/mobile/workdays';

  Future<List<WorkdayDto>> findWorkdaysByTimeSheetId(
      String timeSheetId, String authHeader) async {
    Response res = await get(
      _baseTimesheetUrl + '/${int.parse(timeSheetId)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    return res.statusCode == 200
        ? (json.decode(res.body) as List)
            .map((data) => WorkdayDto.fromJson(data))
            .toList()
        : res.statusCode == 400 ? Future.error(res.body) : null;
  }
}
