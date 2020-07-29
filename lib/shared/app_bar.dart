import 'package:flutter/material.dart';
import 'package:give_job/internationalization/language/language.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/colors.dart';

import '../main.dart';

void _changeLanguage(Language language, BuildContext context) async {
  Locale _temp = await setLocale(language.languageCode);
  MyApp.setLocale(context, _temp);
}

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: DARK),
    ),
    actions: <Widget>[
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Container(
            width: 100,
            child: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: DARK,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    underline: SizedBox(),
                    hint: Container(
                      alignment: Alignment.centerRight,
                      width: 75,
                      child: Icon(Icons.language),
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
            ),
          )),
    ],
  );
}
