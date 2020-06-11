import 'package:flutter/material.dart';
import 'package:give_job/internationalization/language/language.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';

import '../main.dart';

void _changeLanguage(Language language, BuildContext context) async {
  Locale _temp = await setLocale(language.languageCode);
  MyApp.setLocale(context, _temp);
}

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
    ),
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: DropdownButton(
          underline: SizedBox(),
          hint: Text(
            'Language',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
      ),
    ],
  );
}
