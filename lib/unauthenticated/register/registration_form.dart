import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

Form registrationForm() {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  bool _isValid() {
    return formKey.currentState.validate();
  }

  Widget _buildRequiredTextField(
      bool autofocus, String labelText, String errorText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          autofocus: autofocus,
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: 26,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: labelText,
              icon: iconWhite(icon),
              labelStyle: TextStyle(color: WHITE)),
          validator: RequiredValidator(errorText: errorText),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          obscureText: true,
          cursorColor: WHITE,
          maxLength: 60,
          controller: _passwordController,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: 'Password',
              icon: iconWhite(Icons.lock),
              labelStyle: TextStyle(color: WHITE)),
          validator: MultiValidator([
            RequiredValidator(errorText: 'Password is required'),
            MinLengthValidator(6,
                errorText: 'Password should contain at least 6 characters'),
          ]),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildRePasswordTextField() {
    validate(String value) {
      if (value.isEmpty) {
        return 'Please retype your password';
      } else if (value != _passwordController.text) {
        return 'Password and retyped password do not match';
      }
      return null;
    }

    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          obscureText: true,
          cursorColor: WHITE,
          maxLength: 60,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: 'Retyped password',
              icon: iconWhite(Icons.lock),
              labelStyle: TextStyle(color: WHITE)),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  return Form(
    autovalidate: true,
    key: formKey,
    child: Column(
      children: <Widget>[
        textCenter28GreenBold('Registration form'),
        Divider(color: WHITE),
        SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: text25GreenUnderline('LOGIN SECTION'),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.topLeft,
                  child: text13White(
                      'Through the information in this section you will be able to log into the application. Please remember them.'),
                ),
                SizedBox(height: 20),
                _buildRequiredTextField(
                    true, 'Username', 'Username is required', Icons.person),
                _buildPasswordTextField(),
                _buildRePasswordTextField(),
                SizedBox(height: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: text25GreenUnderline('BASIC SECTION'),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.topLeft,
                  child: text13White(
                      'This section contains very basic informations about you like for example name or surname.'),
                ),
                SizedBox(height: 20),
                _buildRequiredTextField(
                    true, 'Name', 'Name is required', Icons.person_outline),
                _buildRequiredTextField(true, 'Surname', 'Surname is required',
                    Icons.person_outline),
                // PLACE FOR DATE OF BIRTH
                _buildRequiredTextField(true, 'Father\'s name',
                    'Father\'s name is required', Icons.directions_walk),
                _buildRequiredTextField(true, 'Mother\'s name',
                    'Mother\'s name is required', Icons.pregnant_woman),
                SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () => {if (!_isValid()) {}},
                  color: GREEN,
                  child: text20White('Register'),
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
