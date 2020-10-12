import 'package:give_job/shared/libraries/constants.dart';
import 'package:http/http.dart';

class TokenService {
  final String _baseTokenUrl = SERVER_IP + '/mobile/tokens';

  Future<String> isCorrect(String id) async {
    Response res = await get(_baseTokenUrl + '/is-correct/${int.parse(id)}');
    return res.statusCode == 200 ? res.body : Future.error(res.body);
  }
}
