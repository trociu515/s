import 'dart:convert';
import 'dart:io';

import 'package:give_job/main.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:http/http.dart';

class ManagerService {
  final String baseManagerUrl = SERVER_IP + '/mobile/managers';

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
}
