import 'dart:convert';
import 'dart:io';

import 'package:give_job/main.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:give_job/manager/dto/manager_group_overview_dto.dart';
import 'package:http/http.dart';

class ManagerService {
  final String baseManagerUrl = SERVER_IP + '/mobile/managers';
  final String baseGroupUrl = SERVER_IP + '/mobile/groups';

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

  Future<List<ManagerGroupOverviewDto>> findGroupsManager(
      String id, String authHeader) async {
    Response res = await get(
      baseGroupUrl + '/${int.parse(id)}',
      headers: {HttpHeaders.authorizationHeader: authHeader},
    );
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List)
          .map((data) => ManagerGroupOverviewDto.fromJson(data))
          .toList();
    } else if (res.statusCode == 400) {
      return Future.error(res.body);
    }
    return null;
  }
}
