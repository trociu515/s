import 'dart:convert';
import 'dart:io';

import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class ManagerVocationService {
  static const String _baseUrl = '/mobile';
  static const String _baseVocationUrl = SERVER_IP + '$_baseUrl/vocations';

  Future<dynamic> updateVocationVerification(
      int vocationId, bool verified, String authHeader) async {
    Map<String, dynamic> map = {'id': vocationId, 'verified': verified};
    Response res = await put(
      _baseVocationUrl + '/verify',
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

  Future<dynamic> removeVocation(int vocationId, String authHeader) async {
    Response res = await delete(
      _baseVocationUrl + '/$vocationId',
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
