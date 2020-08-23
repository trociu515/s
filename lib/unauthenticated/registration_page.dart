import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _passwordVisible = false;
  bool _rePasswordVisible = false;
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _phoneController = new TextEditingController();
  final TextEditingController _viberController = new TextEditingController();
  final TextEditingController _whatsAppController = new TextEditingController();
  DateTime _dateOfBirth = DateTime.now();
  DateTime _passportReleaseDate = DateTime.now();
  DateTime _passportExpirationDate = DateTime.now();
  DateTime _expirationDateOfWork = DateTime.now();
  String _myActivity;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _rePasswordVisible = false;
    _myActivity = '';
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
          padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
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
                          _buildLoginSection(),
                          _buildBasicSection(),
                          _buildAddressSection(),
                          _buildContactSection(),
                          _buildPassportSection(),
                          _buildOtherSection(),
                          _buildRegisterButton(),
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

  Widget _buildLoginSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader('LOGIN SECTION',
            'Through the information in this section you will be able to log into the application. Please remember them.'),
        _buildRequiredTextField(
            26, 'Username', 'Username is required', Icons.person),
        _buildPasswordTextField(),
        _buildRePasswordTextField(),
      ],
    );
  }

  Widget _buildBasicSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader('BASIC SECTION',
            'This section contains very basic informations about you like for example name or surname.'),
        _buildRequiredTextField(
            26, 'Name', 'Name is required', Icons.person_outline),
        _buildRequiredTextField(
            26, 'Surname', 'Surname is required', Icons.person_outline),
        _buildRequiredTextField(26, 'Father\'s name',
            'Father\'s name is required', Icons.directions_walk),
        _buildRequiredTextField(26, 'Mother\'s name',
            'Mother\'s name is required', Icons.pregnant_woman),
        _buildDateOfBirthField(),
        _buildNationalityDropdown(),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader('ADDRESS SECTION',
            'This section contains information about your home address.'),
        _buildRequiredTextField(
            100, 'Locality', 'Locality is required', Icons.location_city),
        _buildRequiredTextField(12, 'Zip code', 'Accommodation is required',
            Icons.local_post_office),
        _buildRequiredTextField(
            100, 'Street', 'Street is required', Icons.directions),
        _buildRequiredTextField(
            4, 'House number', 'House number is required', Icons.home),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader('CONTACT SECTION',
            'To be in touch, please provide one of the three forms of contact.'),
        _buildContactNumField(_phoneController, 'Phone number', Icons.phone),
        _buildContactNumField(
            _viberController, 'Viber number', Icons.phone_in_talk),
        _buildContactNumField(
            _whatsAppController, 'Whats app number', Icons.perm_phone_msg),
      ],
    );
  }

  Widget _buildPassportSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader('PASSPORT SECTION',
            'This section is NOT REQUIRED, so that means you don\'t need to fill in given fields.'),
        _buildNotRequiredNumField('Passport number', Icons.card_travel),
        _buildNotRequiredDate(_passportReleaseDate, 'Passport release date'),
        _buildNotRequiredDate(
            _passportExpirationDate, 'Passport expiration date'),
      ],
    );
  }

  Widget _buildOtherSection() {
    return Column(
      children: <Widget>[
        _buildSectionHeader('OTHER SECTION',
            'This section is NOT REQUIRED, so that means you don\'t need to fill in given fields.'),
        _buildEmailField(),
        _buildNotRequiredDate(_expirationDateOfWork, 'Expiration date of work'),
        _buildNotRequiredNumField('NIP', Icons.language),
        _buildNotRequiredTextField(
            28, 'Bank account number', Icons.monetization_on),
        _buildNotRequiredTextField(30, 'Driving licenses', Icons.drive_eta),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15),
        Align(alignment: Alignment.topLeft, child: text25GreenUnderline(title)),
        SizedBox(height: 5),
        Align(alignment: Alignment.topLeft, child: text13White(subtitle)),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Column(
      children: <Widget>[
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
    );
  }

  Widget _buildRequiredTextField(
      int maxLength, String labelText, String errorText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: maxLength,
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

  Widget _buildNotRequiredTextField(
      int maxLength, String labelText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: maxLength,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: labelText,
              prefixIcon: iconWhite(icon),
              labelStyle: TextStyle(color: WHITE)),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildContactNumField(
      TextEditingController controller, String labelText, IconData icon) {
    String validate(String value) {
      String phone = _phoneController.text;
      String viber = _viberController.text;
      String whatsApp = _whatsAppController.text;
      if (phone.isNotEmpty || viber.isNotEmpty || whatsApp.isNotEmpty) {
        return null;
      }
      return 'Please provide one of the three forms of contact.';
    }

    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: 15,
          controller: controller,
          style: TextStyle(color: WHITE),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: labelText,
              prefixIcon: iconWhite(icon),
              labelStyle: TextStyle(color: WHITE)),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildNotRequiredNumField(String labelText, IconData icon) {
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: 9,
          style: TextStyle(color: WHITE),
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: labelText,
              prefixIcon: iconWhite(icon),
              labelStyle: TextStyle(color: WHITE)),
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
          obscureText: !_passwordVisible,
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
              suffixIcon: IconButton(
                icon: iconWhite(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(
                  () => _passwordVisible = !_passwordVisible,
                ),
              ),
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
          obscureText: !_rePasswordVisible,
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
              suffixIcon: IconButton(
                icon: iconWhite(_rePasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () => setState(
                  () => _rePasswordVisible = !_rePasswordVisible,
                ),
              ),
              labelStyle: TextStyle(color: WHITE)),
          validator: (value) => validate(value),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    String validate(value) {
      if (_dateOfBirth.toString().substring(0, 10) ==
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
              selectDate(context, _dateOfBirth);
            });
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: WHITE, width: 2)),
            border: OutlineInputBorder(),
            hintText: _dateOfBirth.toString().substring(0, 10) ==
                    DateTime.now().toString().substring(0, 10)
                ? 'Date of birth'
                : _dateOfBirth.toString().substring(0, 10) + ' (Date of birth)',
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

  Future<Null> selectDate(BuildContext context, DateTime date) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1950),
        lastDate: DateTime(2050),
        initialDatePickerMode: DatePickerMode.year);
    if (_datePicker != null && _datePicker != date) {
      setState(() {
        date = _datePicker;
      });
    }
  }

  Widget _buildNationalityDropdown() {
    return Theme(
      data: ThemeData(hintColor: DARK, splashColor: GREEN),
      child: Column(
        children: <Widget>[
          Container(
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
                  'display':
                      'Беларус ' + LanguageUtil.findFlagByNationality('BE'),
                  'value': 'BE'
                },
                {
                  'display':
                      'English ' + LanguageUtil.findFlagByNationality('EN'),
                  'value': 'EN'
                },
                {
                  'display':
                      'Français ' + LanguageUtil.findFlagByNationality('FR'),
                  'value': 'FR'
                },
                {
                  'display':
                      'ქართული ' + LanguageUtil.findFlagByNationality('GE'),
                  'value': 'GE'
                },
                {
                  'display':
                      'Deutsche ' + LanguageUtil.findFlagByNationality('DE'),
                  'value': 'DE'
                },
                {
                  'display':
                      'Română ' + LanguageUtil.findFlagByNationality('RO'),
                  'value': 'RO'
                },
                {
                  'display':
                      'Nederlands ' + LanguageUtil.findFlagByNationality('NL'),
                  'value': 'NL'
                },
                {
                  'display':
                      'Norsk ' + LanguageUtil.findFlagByNationality('NO'),
                  'value': 'NO'
                },
                {
                  'display':
                      'Polska ' + LanguageUtil.findFlagByNationality('PL'),
                  'value': 'PL'
                },
                {
                  'display':
                      'русский ' + LanguageUtil.findFlagByNationality('RU'),
                  'value': 'RU'
                },
                {
                  'display':
                      'Español ' + LanguageUtil.findFlagByNationality('ES'),
                  'value': 'ES'
                },
                {
                  'display':
                      'Svenska ' + LanguageUtil.findFlagByNationality('SE'),
                  'value': 'SE'
                },
                {
                  'display':
                      'Українська ' + LanguageUtil.findFlagByNationality('UK'),
                  'value': 'UK'
                },
                {
                  'display':
                      'Other ' + LanguageUtil.findFlagByNationality('OTHER'),
                  'value': 'OTHER'
                },
              ],
              textField: 'display',
              valueField: 'value',
              required: true,
              autovalidate: true,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNotRequiredDate(DateTime date, String dateName) {
    return Column(
      children: <Widget>[
        TextFormField(
          readOnly: true,
          onTap: () {
            setState(() {
              selectDate(context, date);
            });
          },
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: WHITE, width: 2)),
            border: OutlineInputBorder(),
            hintText: date.toString().substring(0, 10) ==
                    DateTime.now().toString().substring(0, 10)
                ? dateName
                : date.toString().substring(0, 10) + ' (' + dateName + ')',
            hintStyle: TextStyle(color: WHITE),
            prefixIcon: iconWhite(Icons.date_range),
            labelStyle: TextStyle(color: WHITE),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      children: <Widget>[
        TextFormField(
          autocorrect: true,
          cursorColor: WHITE,
          maxLength: 255,
          style: TextStyle(color: WHITE),
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: WHITE, width: 2)),
              counterStyle: TextStyle(color: WHITE),
              border: OutlineInputBorder(),
              labelText: 'Email',
              prefixIcon: iconWhite(Icons.alternate_email),
              labelStyle: TextStyle(color: WHITE)),
          validator: EmailValidator(errorText: 'Wrong email address format'),
        ),
        SizedBox(height: 10),
      ],
    );
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
