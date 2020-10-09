import 'dart:convert';
import 'dart:io';

import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class ManagerGroupService {
  static const String _baseUrl = '/mobile';
  static const String _baseGroupUrl = SERVER_IP + '$_baseUrl/groups';

  Future<dynamic> updateGroupName(
      int id, String name, String authHeader) async {
    Map<String, dynamic> map = {'id': id, 'name': name};
    Response res = await put(
      _baseGroupUrl + '/name',
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

  Future<dynamic> updateGroupDescription(
      int id, String description, String authHeader) async {
    Map<String, dynamic> map = {'id': id, 'description': description};
    Response res = await put(
      _baseGroupUrl + '/description',
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
