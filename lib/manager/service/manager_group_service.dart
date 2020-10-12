import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:http/http.dart';

class ManagerGroupService {
  final BuildContext context;
  final String authHeader;

  ManagerGroupService(this.context, this.authHeader);

  static const String _baseUrl = '/mobile';
  static const String _baseGroupUrl = SERVER_IP + '$_baseUrl/groups';

  Future<dynamic> updateGroupName(int id, String name) async {
    Response res = await put(_baseGroupUrl + '/name',
        body: jsonEncode({'id': id, 'name': name}),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          'content-type': 'application/json'
        });
    if (res.statusCode == 200) {
      return res;
    } else if (res.statusCode == 401) {
      return Logout.handle401WithLogout(context);
    } else {
      return Future.error(res.body);
    }
  }

  Future<dynamic> updateGroupDescription(int id, String description) async {
    Response res = await put(_baseGroupUrl + '/description',
        body: jsonEncode({'id': id, 'description': description}),
        headers: {
          HttpHeaders.authorizationHeader: authHeader,
          'content-type': 'application/json'
        });
    if (res.statusCode == 200) {
      return res;
    } else if (res.statusCode == 401) {
      return Logout.handle401WithLogout(context);
    } else {
      return Future.error(res.body);
    }
  }
}
