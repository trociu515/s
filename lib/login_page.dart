import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:lets_work/employee/employee_page.dart';
import 'package:lets_work/main.dart';
import 'package:lets_work/manager/manager_page.dart';
import 'package:lets_work/shared/toastr_service.dart';
import 'package:lets_work/shared/validator_service.dart';

import 'internationalization/language/language.dart';
import 'internationalization/localization/localization_constants.dart';
import 'shared/constants.dart';

class LoginPage extends StatefulWidget {
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
    void _changeLanguage(Language language, BuildContext context) async {
      Locale _temp = await setLocale(language.languageCode);
      MyApp.setLocale(context, _temp);
    }

    final title = TextField(
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40,
      ),
      decoration: InputDecoration(border: InputBorder.none, hintText: APP_NAME),
    );

    final username = TextFormField(
      controller: usernameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: getTranslated(context, 'username'),
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
        hintText: getTranslated(context, 'password'),
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
      child: Text(
        getTranslated(context, 'login'),
      ),
      onPressed: () async {
        String username = usernameController.text;
        String password = passwordController.text;

        String invalidMessage = ValidatorService.validateLoginCredentials(
            username, password, context);
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
            String role = res.body;
            storage.write(key: 'role', value: role);
            if (role == ROLE_EMPLOYEE) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EmployeePage()));
            } else if (role == ROLE_MANAGER) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ManagerPage()));
            }
            ToastService.showToast(
                getTranslated(context, 'loginSuccessfully'), Colors.green);
          } else {
            ToastService.showToast(
                getTranslated(context, 'wrongUsernameOrPassword'), Colors.red);
          }
        }, onError: (e) {
          ToastService.showToast(
              getTranslated(context, 'cannotConnectToServer'), Colors.red);
        });
      },
    );

    final languageButton = Center(
      child: DropdownButton(
        iconEnabledColor: Colors.blueAccent,
        underline: SizedBox(),
        hint: Text(
          '🇧🇾 🇺🇸 🇩🇪 🇲🇩 🇵🇱 🇷🇺 🇺🇦',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        onChanged: (Language language) {
          _changeLanguage(language, context);
        },
        items: Language.languageList()
            .map<DropdownMenuItem<Language>>(
              (lang) => DropdownMenuItem(
                value: lang,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(lang.flag),
                    Text(lang.name),
                  ],
                ),
              ),
            )
            .toList(),
      ),
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
            loginButton,
            SizedBox(height: 8.0),
            languageButton
          ],
        ),
      ),
    );
  }
}
