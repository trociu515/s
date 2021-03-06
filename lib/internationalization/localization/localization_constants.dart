import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demo_localization.dart';

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).getTranslatedValue(key);
}

const String BELARUSIAN = 'be';
const String ENGLISH = 'en';
const String FRENCH = 'fr';
const String GEORGIA = 'pt';
const String GERMAN = 'de';
const String MOLDAVIAN = 'ro';
const String NETHERLANDS = 'nl';
const String NORWAY = 'it';
const String POLISH = 'pl';
const String RUSSIAN = 'ru';
const String SPAIN = 'es';
const String SWEDEN = 'ca';
const String UKRAINIAN = 'uk';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LANGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch (languageCode) {
    case BELARUSIAN:
      _temp = Locale(languageCode, 'BY');
      break;
    case ENGLISH:
      _temp = Locale(languageCode, 'EN');
      break;
    case FRENCH:
      _temp = Locale(languageCode, 'FR');
      break;
    case GEORGIA:
      _temp = Locale(languageCode, 'PT');
      break;
    case GERMAN:
      _temp = Locale(languageCode, 'DE');
      break;
    case MOLDAVIAN:
      _temp = Locale(languageCode, 'RO');
      break;
    case NETHERLANDS:
      _temp = Locale(languageCode, 'NL');
      break;
    case NORWAY:
      _temp = Locale(languageCode, 'IT');
      break;
    case POLISH:
      _temp = Locale(languageCode, 'PL');
      break;
    case RUSSIAN:
      _temp = Locale(languageCode, 'RU');
      break;
    case SPAIN:
      _temp = Locale(languageCode, 'ES');
      break;
    case SWEDEN:
      _temp = Locale(languageCode, 'CA');
      break;
    case UKRAINIAN:
      _temp = Locale(languageCode, 'UA');
      break;
    default:
      _temp = Locale(ENGLISH, 'EN');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? ENGLISH;
  return _locale(languageCode);
}
