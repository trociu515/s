import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class TokenService {
  final String _baseTokenUrl = SERVER_IP + '/mobile/tokens';

  Future<bool> isCorrect(String id) async {
    Response res = await get(_baseTokenUrl + '/is-correct/${int.parse(id)}');
    return res.body.toString() == 'true';
  }
}
