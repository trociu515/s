import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/employee_page.dart';
import 'package:give_job/get_started_page.dart';
import 'package:give_job/main.dart';
import 'package:give_job/manager/manager_page.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'internationalization/localization/localization_constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;

  Future<http.Response> login(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var res = await http
        .get('$SERVER_IP/login/mobile', headers: {'authorization': basicAuth});
    return res;
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: '  ' + getTranslated(context, 'loading'),
      messageTextStyle: TextStyle(color: DARK),
      progressWidget: CircularProgressIndicator(
        backgroundColor: GREEN,
        valueColor: new AlwaysStoppedAnimation(Colors.white),
      ),
    );

    return Scaffold(
      backgroundColor: DARK,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute<Null>(
                builder: (BuildContext context) {
                  return new GetStartedPage();
                },
              ),
            );
          },
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Text(
              getTranslated(context, 'loginTitle'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20),
            Text(
              getTranslated(context, 'loginDescription'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(
              height: 50,
            ),
            _buildUsernameField(),
            SizedBox(height: 20),
            //_buildUsernameField(passwordController, Icons.lock, 'Password'),
            _buildPasswordField(),
            SizedBox(height: 30),
            MaterialButton(
              elevation: 0,
              minWidth: double.maxFinite,
              height: 50,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              onPressed: () {
                String username = usernameController.text;
                String password = passwordController.text;

                String invalidMessage =
                    ValidatorService.validateLoginCredentials(
                        username, password, context);
                if (invalidMessage != null) {
                  ToastService.showToast(invalidMessage, Colors.red);
                  return;
                }
                progressDialog.show();
                login(usernameController.text, passwordController.text).then(
                    (res) {
                  FocusScope.of(context).unfocus();
                  if (res.statusCode == 200) {
                    String authHeader = 'Basic ' +
                        base64Encode(utf8.encode('$username:$password'));
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
                              builder: (context) => EmployeeInformationPage(
                                  id, userInfo, authHeader)));
                    } else if (role == ROLE_MANAGER) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ManagerDetails(id, userInfo, authHeader)));
                    }
                    ToastService.showToast(
                        getTranslated(context, 'loginSuccessfully'),
                        Color(0xffb5d76d));
                  } else {
                    progressDialog.hide();
                    ToastService.showToast(
                        getTranslated(context, 'wrongUsernameOrPassword'),
                        Colors.red);
                  }
                }, onError: (e) {
                  progressDialog
                      .hide(); // TODO progress dialog doesn't hide when error is catched
                  ToastService.showToast(
                      getTranslated(context, 'cannotConnectToServer'),
                      Colors.red);
                });
              },
              color: GREEN,
              child: Text(getTranslated(context, 'login'),
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              textColor: Colors.white,
            ),
            SizedBox(height: 100),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildFooterLogo(),
            )
          ],
        ),
      ),
    );
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/logo.png',
          height: 40,
        ),
        Text(
          'Give Job  ',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _buildUsernameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DARK),
      ),
      child: TextField(
        controller: usernameController,
        style: TextStyle(color: DARK),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: getTranslated(context, 'username'),
          labelStyle: TextStyle(color: DARK),
          icon: Icon(
            Icons.account_circle,
            color: DARK,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  _buildPasswordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DARK),
      ),
      child: TextField(
        controller: passwordController,
        style: TextStyle(color: DARK),
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: getTranslated(context, 'password'),
          labelStyle: TextStyle(color: DARK),
          icon: Icon(
            Icons.lock,
            color: DARK,
          ),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(
                () {
                  _passwordVisible = !_passwordVisible;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
