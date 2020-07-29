import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:give_job/employee/employee_page.dart';
import 'package:give_job/main.dart';
import 'package:give_job/manager/manager_page.dart';
import 'package:give_job/shared/toastr_service.dart';
import 'package:give_job/shared/validator_service.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

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

    final ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: getTranslated(context, 'loading'),
      messageTextStyle: TextStyle(color: Color(0xffb5d76d)),
    );
    final logo = Image(image: AssetImage('images/logo.png'), height: 250);

    final username = TextFormField(
      controller: usernameController,
      autofocus: false,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: getTranslated(context, 'username'),
        hintStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffb5d76d), width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffb5d76d), width: 2.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: getTranslated(context, 'password'),
        hintStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffb5d76d), width: 2.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffb5d76d), width: 2.0)),
      ),
    );

    final loginButton = RaisedButton(
      color: Color(0xffb5d76d),
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
        progressDialog.show();
        login(usernameController.text, passwordController.text).then((res) {
          FocusScope.of(context).unfocus();
          if (res.statusCode == 200) {
            String authHeader =
                'Basic ' + base64Encode(utf8.encode('$username:$password'));
            storage.write(key: 'authorization', value: authHeader);
            Map map = json.decode(res.body);
            String role = map['role'];
            String id = map['id'];
            String userInfo = map['userInfo'];
            storage.write(key: 'role', value: role);
            storage.write(key: 'id', value: id);
            storage.write(key: 'userInfo', value: userInfo);
            if (role == ROLE_EMPLOYEE) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EmployeePage(id, userInfo, authHeader)));
            } else if (role == ROLE_MANAGER) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ManagerPage(id, userInfo, authHeader)));
            }
            ToastService.showToast(
                getTranslated(context, 'loginSuccessfully'), Color(0xffb5d76d));
          } else {
            progressDialog.hide();
            ToastService.showToast(
                getTranslated(context, 'wrongUsernameOrPassword'), Colors.red);
          }
        }, onError: (e) {
          progressDialog.hide();
          ToastService.showToast(
              getTranslated(context, 'cannotConnectToServer'), Colors.red);
        });
      },
    );

    final languageButton = Center(
      child: Container(
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            iconEnabledColor: Colors.lightGreen,
            underline: SizedBox(),
            hint: Text(
              '🇧🇾 🇬🇪 🏴󠁧󠁢󠁥󠁮󠁧󠁿 🇵🇱 ...',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            onChanged: (Language language) {
              _changeLanguage(language, context);
            },
            items: Language.getLanguages()
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
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
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
