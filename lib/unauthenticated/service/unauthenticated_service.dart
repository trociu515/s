import 'dart:convert';

import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/unauthenticated/dto/create_employee_dto.dart';
import 'package:http/http.dart';

class UnauthenticatedService {
  final String _baseUnauthenticatedUrl =
      SERVER_IP + '/mobile/unauthenticated-employees';

  Future<dynamic> registerEmployee(CreateEmployeeDto dto) async {
    Response res = await post(_baseUnauthenticatedUrl,
        body: jsonEncode(CreateEmployeeDto.jsonEncode(dto)));
    return res.statusCode == 200 ? res : Future.error(res.body);
  }
}
