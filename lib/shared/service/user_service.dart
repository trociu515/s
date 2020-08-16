import 'dart:convert';
import 'dart:io';

import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class UserService {
  final String _baseUserUrl = SERVER_IP + '/mobile/users';

  Future<dynamic> updatePassword(
      String username, String newPassword, String authHeader) async {
    Map<String, dynamic> map = {
      'username': username,
      'newPassword': newPassword
    };
    Response res = await put(
      _baseUserUrl + '/password',
      body: jsonEncode(map),
      headers: {
        HttpHeaders.authorizationHeader: authHeader,
        "content-type": "application/json"
      },
    );
    if (res.statusCode == 200) {
      return res;
    }
    return Future.error(res.body);
  }
}
