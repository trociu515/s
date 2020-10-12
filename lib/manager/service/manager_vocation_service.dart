import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:http/http.dart';

class ManagerVocationService {
  final BuildContext context;
  final String authHeader;

  ManagerVocationService(this.context, this.authHeader);

  static const String _baseUrl = '/mobile';
  static const String _baseVocationUrl = SERVER_IP + '$_baseUrl/vocations';

  Future<dynamic> updateVocationVerification(
      int vocationId, bool verified) async {
    Response res = await put(_baseVocationUrl + '/verify',
        body: jsonEncode({'id': vocationId, 'verified': verified}),
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

  Future<dynamic> removeVocation(int vocationId) async {
    Response res = await delete(_baseVocationUrl + '/$vocationId', headers: {
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
