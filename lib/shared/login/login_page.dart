import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:give_job/get_started_page.dart';
import 'package:give_job/main.dart';
import 'package:give_job/manager/home/manager_home_page.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import '../../employee/home/employee_home_page.dart';
import '../../internationalization/localization/localization_constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  String _token;
  bool _onEditing = true;

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
          icon: iconWhite(Icons.arrow_back),
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
            textCenter28White(getTranslated(context, 'loginTitle')),
            SizedBox(height: 20),
            textCenter14White(getTranslated(context, 'loginDescription')),
            SizedBox(height: 50),
            _buildUsernameField(),
            SizedBox(height: 20),
            _buildPasswordField(),
            SizedBox(height: 30),
            MaterialButton(
              elevation: 0,
              minWidth: double.maxFinite,
              height: 50,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                String invalidMessage =
                    ValidatorService.validateLoginCredentials(
                        username, password, context);
                if (invalidMessage != null) {
                  ToastService.showToast(invalidMessage, Colors.red);
                  return;
                }
                progressDialog.show();
                _login(_usernameController.text, _passwordController.text).then(
                    (res) {
                  FocusScope.of(context).unfocus();
                  if (res.statusCode == 200) {
                    String authHeader = 'Basic ' +
                        base64Encode(utf8.encode('$username:$password'));
                    storage.write(key: 'authorization', value: authHeader);
                    Map map = json.decode(res.body);
                    User user = new User();
                    String role = map['role'];
                    String id = map['id'];
                    String info = map['info'];
                    storage.write(key: 'role', value: role);
                    storage.write(key: 'id', value: id);
                    storage.write(key: 'info', value: info);
                    storage.write(key: 'username', value: username);
                    user.id = id;
                    user.role = role;
                    user.username = username;
                    user.info = info;
                    user.authHeader = authHeader;
                    if (role == ROLE_EMPLOYEE) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmployeeHomePage(user)));
                    } else if (role == ROLE_MANAGER) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManagerDetails(user)));
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
              child: text20White(getTranslated(context, 'login')),
              textColor: Colors.white,
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () => _showCreateAccountDialog(),
              child: textCenter20WhiteBoldUnderline(
                  getTranslated(context, 'createNewAccount')),
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

  _buildUsernameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: DARK),
      ),
      child: TextField(
        controller: _usernameController,
        style: TextStyle(color: DARK),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: getTranslated(context, 'username'),
          labelStyle: TextStyle(color: DARK),
          icon: iconDark(Icons.account_circle),
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
        controller: _passwordController,
        style: TextStyle(color: DARK),
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: getTranslated(context, 'password'),
          labelStyle: TextStyle(color: DARK),
          icon: iconDark(Icons.lock),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(
              () => _passwordVisible = !_passwordVisible,
            ),
          ),
        ),
      ),
    );
  }

  Future<http.Response> _login(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    var res = await http
        .get('$SERVER_IP/login/mobile', headers: {'authorization': basicAuth});
    return res;
  }

  _showCreateAccountDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: DARK,
            title: Column(
              children: <Widget>[
                textCenterWhite(getTranslated(context, 'createNewAccount')),
                SizedBox(height: 5),
                textCenter14White(
                    getTranslated(context, 'createNewAccountPopupTitle')),
              ],
            ),
            content: Container(
              height: 50,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  VerificationCode(
                    textStyle: TextStyle(fontSize: 20.0, color: WHITE),
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    itemSize: 40,
                    length: 6,
                    onCompleted: (String value) {
                      setState(() {
                        _token = value;
                      });
                    },
                    onEditing: (bool value) {
                      setState(() {
                        _onEditing = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: textWhite(getTranslated(context, 'confirm')),
                onPressed: () {},
              ),
              FlatButton(
                child: textWhite(getTranslated(context, 'close')),
                onPressed: () {
                  Navigator.of(context).pop();
                  _token = null;
                },
              )
            ],
          );
        });
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('images/logo.png', height: 40),
        SizedBox(width: 5),
        text20WhiteBold(APP_NAME),
      ],
    );
  }
}
