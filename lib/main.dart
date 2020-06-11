import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:give_job/shared/constants.dart';

import 'employee/employee_page.dart';
import 'internationalization/localization/demo_localization.dart';
import 'internationalization/localization/localization_constants.dart';
import 'login_page.dart';
import 'manager/manager_page.dart';

const SERVER_IP = 'http://10.0.2.2:8080/api';
final storage = new FlutterSecureStorage();

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  Future<Map<String, String>> get authOrEmpty async {
    var auth = await storage.read(key: 'authorization');
    var role = await storage.read(key: 'role');
    var userInfo = await storage.read(key: 'userInfo');
    Map<String, String> map = new Map();
    map['authorization'] = auth;
    map['role'] = role;
    map['userInfo'] = userInfo;
    return map.isNotEmpty ? map : null;
  }

  @override
  Widget build(BuildContext context) {
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        title: APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        locale: _locale,
        supportedLocales: [
          Locale('be', 'BY'),
          Locale('en', 'US'),
          Locale('pt', 'PT'),
          Locale('de', 'DE'),
          Locale('ro', 'RO'),
          Locale('pl', 'PL'),
          Locale('ru', 'RU'),
          Locale('uk', 'UA'),
        ],
        localizationsDelegates: [
          DemoLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode &&
                locale.countryCode == deviceLocale.countryCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: authOrEmpty,
          builder: (context, snapshot) {
            Map<String, String> data = snapshot.data;
            if (data == null) {
              return LoginPage();
            }
            String role = data['role'];
            String id = data['id'];
            String userInfo = data['userInfo'];
            String authHeader = data['authorization'];
            if (role == ROLE_EMPLOYEE) {
              return EmployeePage(
                  id == null ? '' : id, userInfo == null ? '' : userInfo, authHeader == null ? '' : authHeader);
            } else if (role == ROLE_MANAGER) {
              return ManagerPage(
                  id == null ? '' : id, userInfo == null ? '' : userInfo);
            } else {
              return LoginPage();
            }
          },
        ),
      );
    }
  }
}
