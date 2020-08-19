import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:give_job/get_started_page.dart';
import 'package:give_job/shared/login/login_page.dart';
import 'package:give_job/manager/home/manager_home_page.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/own_http_overrides.dart';

import 'employee/home/employee_home_page.dart';
import 'internationalization/localization/demo_localization.dart';
import 'internationalization/localization/localization_constants.dart';

final storage = new FlutterSecureStorage();
final GlobalKey<RefreshIndicatorState> refreshIndicatorState =
    new GlobalKey<RefreshIndicatorState>();

void main() {
  HttpOverrides.global = new OwnHttpOverrides();
  runApp(new MyApp());
}

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
    var getStartedClick = await storage.read(key: 'getStartedClick');
    var auth = await storage.read(key: 'authorization');
    var role = await storage.read(key: 'role');
    var id = await storage.read(key: 'id');
    var info = await storage.read(key: 'info');
    var username = await storage.read(key: 'username');
    Map<String, String> map = new Map();
    map['getStartedClick'] = getStartedClick;
    map['authorization'] = auth;
    map['role'] = role;
    map['id'] = id;
    map['info'] = info;
    map['username'] = username;
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
        theme: ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
        locale: _locale,
        supportedLocales: [
          Locale('be', 'BY'),
          Locale('en', 'EN'),
          Locale('fr', 'FR'),
          Locale('pt', 'PT'), // GEORGIA
          Locale('de', 'DE'),
          Locale('ro', 'RO'),
          Locale('nl', 'NL'),
          Locale('it', 'IT'), // NORWAY
          Locale('pl', 'PL'),
          Locale('ru', 'RU'),
          Locale('es', 'ES'),
          Locale('ca', 'CA'), // SWEDEN
          Locale('uk', 'UA'),
        ],
        debugShowMaterialGrid: false,
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
              return GetStartedPage();
            }
            String getStartedClick = data['getStartedClick'];
            if (getStartedClick == null) {
              return GetStartedPage();
            }
            User user = new User().create(data);
            String role = user.role;
            if (role == ROLE_EMPLOYEE) {
              return EmployeeHomePage(user);
            } else if (role == ROLE_MANAGER) {
              return ManagerDetails(user);
            } else {
              return LoginPage();
            }
          },
        ),
      );
    }
  }
}
