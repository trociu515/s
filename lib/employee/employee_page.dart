import 'package:flutter/material.dart';
import 'package:lets_work/language/language.dart';
import 'package:lets_work/localization/localization_constants.dart';
import 'package:lets_work/main.dart';
import 'package:lets_work/shared/logout.dart';

import '../shared/constants.dart';

class EmployeePage extends StatefulWidget {
  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: DropdownButton(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                onChanged: (Language language) {
                  _changeLanguage(language);
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
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Logout.showAlert(context);
                },
                child: Icon(Icons.exit_to_app),
              ),
            ),
          ],
        ),
        body: Center(
          //child: Text('Its works!')
          child: ListView(
            children: <Widget>[Text(getTranslated(context, 'home_page'))],
          ),
        ),
      ),
    );
  }
}
