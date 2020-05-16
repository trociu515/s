import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lets_work/main.dart';
import 'package:lets_work/toastr_service.dart';
import 'package:lets_work/validator_service.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  Future<http.Response> login(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var res = await http
        .get('$SERVER_IP/login/mobile', headers: {'authorization': basicAuth});
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final title = TextField(
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40,
      ),
      decoration:
          InputDecoration(border: InputBorder.none, hintText: 'Lets work'),
    );

    final username = TextFormField(
      controller: usernameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Nazwa użytkownika',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Hasło',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );

    final loginButton = RaisedButton(
      color: Colors.lightBlueAccent,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text('Login'),
      onPressed: () async {
        String username = usernameController.text;
        String password = passwordController.text;

        String invalidMessage =
            ValidatorService.validateLoginCredentials(username, password);
        if (invalidMessage != null) {
          ToastService.showToast(invalidMessage, Colors.red);
          return;
        }

        login(usernameController.text, passwordController.text).then((res) {
          FocusScope.of(context).unfocus();
          if (res.statusCode == 200) {
            storage.write(
                key: 'authorization',
                value: 'Basic ' +
                    base64Encode(utf8.encode('$username:$password')));
            ToastService.showToast('Zalogowano pomyślnie!', Colors.green);
          } else {
            ToastService.showToast('Błędny login lub hasło', Colors.red);
          }
        }, onError: (e) {
          ToastService.showToast(
              'Nie można się połączyć z serwerem', Colors.red);
        });
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            title,
            SizedBox(height: 20.0),
            username,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton
          ],
        ),
      ),
    );
  }
}
