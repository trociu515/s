import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:give_job/unauthenticated/login_page.dart';

class RegistrationPage extends StatefulWidget {
  final String _tokenId;

  RegistrationPage(this._tokenId);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();
  String _myActivity;
  String _myActivityResult;

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  @override
  Widget build(BuildContext context) {
    if (widget._tokenId == null) {
      return LoginPage();
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: DARK,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: iconWhite(Icons.arrow_back),
            onPressed: () => _exitDialog(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Center(
            child: Form(
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
                              'Username', 'Username is required', Icons.person),
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
                              'Name', 'Name is required', Icons.person_outline),
                          _buildRequiredTextField('Surname',
                              'Surname is required', Icons.person_outline),
                          _buildRequiredTextField(
                              'Father\'s name',
                              'Father\'s name is required',
                              Icons.directions_walk),
                          _buildRequiredTextField(
                              'Mother\'s name',
                              'Mother\'s name is required',
                              Icons.pregnant_woman),
                          _buildDateOfBirthField(),
                          Theme(
                            data:
                                ThemeData(hintColor: DARK, splashColor: GREEN),
                            child: Container(
                              color: Colors.white,
                              child: DropDownFormField(
                                titleText: 'Nationality',
                                hintText: 'Please choose your nationality',
                                value: _myActivity,
                                onSaved: (value) {
                                  setState(() {
                                    _myActivity = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _myActivity = value;
                                  });
                                },
                                dataSource: [
                                  {
                                    'display': 'Беларус ' + LanguageUtil.findFlagByNationality('BE'),
                                    'value': 'BE',
                                  },
                                  {
                                    'display': 'English ' + LanguageUtil.findFlagByNationality('EN'),
                                    'value': 'EN',
                                  },
                                  {
                                    'display': 'Français ' + LanguageUtil.findFlagByNationality('FR'),
                                    'value': 'FR',
                                  },
                                  {
                                    'display': 'ქართული ' + LanguageUtil.findFlagByNationality('GE'),
                                    'value': 'GE',
                                  },
                                  {
                                    'display': 'Deutsche ' + LanguageUtil.findFlagByNationality('DE'),
                                    'value': 'DE',
                                  },
                                  {
                                    'display': 'Română ' + LanguageUtil.findFlagByNationality('RO'),
                                    'value': 'RO',
                                  },
                                  {
                                    'display': 'Nederlands ' + LanguageUtil.findFlagByNationality('NL'),
                                    'value': 'NL',
                                  },
                                  {
                                    'display': 'Norsk ' + LanguageUtil.findFlagByNationality('NO'),
                                    'value': 'NO',
                                  },
                                  {
                                    'display': 'Polska ' + LanguageUtil.findFlagByNationality('PL'),
                                    'value': 'PL',
                                  },
                                  {
                                    'display': 'русский ' + LanguageUtil.findFlagByNationality('RU'),
                                    'value': 'RU',
                                  },
                                  {
                                    'display': 'Español ' + LanguageUtil.findFlagByNationality('ES'),
                                    'value': 'ES',
                                  },
                                  {
                                    'display': 'Svenska ' + LanguageUtil.findFlagByNationality('SE'),
                                    'value': 'SE',
                                  },
                                  {
                                    'display': 'Українська ' + LanguageUtil.findFlagByNationality('UK'),
                                    'value': 'UK',
                                  },
                                  {
                                    'display': 'Other ' + LanguageUtil.findFlagByNationality('OTHER'),
                                    'value': 'OTHER',
                                  },
                                ],
                                textField: 'display',
                                valueField: 'value',
                                required: true,
                                autovalidate: true,
                              ),
                            ),
                          ),
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
            ),
          ),
        ),
      ),
    );
  }

  bool _isValid() {
    return formKey.currentState.validate();
  }

  Widget _buildRequiredTextField(
      String labelText, String errorText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
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
              prefixIcon: iconWhite(icon),
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
              prefixIcon: iconWhite(Icons.lock),
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
              prefixIcon: iconWhite(Icons.lock),
              labelStyle: TextStyle(color: WHITE)),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    String validate(value) {
      if (_date.toString().substring(0, 10) ==
          DateTime.now().toString().substring(0, 10)) {
        return 'Date of birth is required';
      }
      return null;
    }

    return Column(
      children: <Widget>[
        TextFormField(
          readOnly: true,
          onTap: () {
            setState(() {
              selectDate(context);
            });
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: WHITE, width: 2)),
            border: OutlineInputBorder(),
            hintText: _date.toString().substring(0, 10) ==
                    DateTime.now().toString().substring(0, 10)
                ? 'Date of birth'
                : _date.toString().substring(0, 10) + ' (Date of birth)',
            hintStyle: TextStyle(color: WHITE),
            prefixIcon: iconWhite(Icons.date_range),
            labelStyle: TextStyle(color: WHITE),
          ),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  DateTime _date = DateTime.now();

  Future<Null> selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1950),
        lastDate: DateTime(2030),
        initialDatePickerMode: DatePickerMode.year);
    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
      });
    }
  }

  void _resetAndOpenPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      ModalRoute.withName('/'),
    );
  }

  Future<bool> _onWillPop() async {
    return _exitDialog() ?? false;
  }

  _exitDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen(getTranslated(context, 'confirmation')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(getTranslated(context, 'exitRegistrationContent')),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'exitAgree')),
              onPressed: () =>
                  {Navigator.of(context).pop(), _resetAndOpenPage()},
            ),
            FlatButton(
              child: textWhite(getTranslated(context, 'no')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
