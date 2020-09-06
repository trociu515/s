import 'package:flutter/cupertino.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/internationalization/model/language.dart';

class LanguageUtil {

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, '🇧🇾', 'BLR', 'be'),
      Language(2, '🇬🇧', 'GBR', 'en'),
      Language(3, '🇫🇷', 'FRA', 'fr'),
      Language(4, '🇬🇪', 'GEO', 'pt'),
      Language(5, '🇩🇪', 'DEU', 'de'),
      Language(6, '🇲🇩', 'ROU', 'ro'),
      Language(7, '🇳🇱', 'NLD', 'nl'),
      Language(8, '🇳🇴', 'NOR', 'it'),
      Language(9, '🇵🇱', 'POL', 'pl'),
      Language(10, '🇷🇺', 'RUS', 'ru'),
      Language(11, '🇪🇸', 'ESP', 'es'),
      Language(12, '🇸🇪', 'SWE', 'ca'),
      Language(13, '🇺🇦', 'UKR', 'uk'),
    ];
  }

  static String findFlagByNationality(String nationality) {
    switch (nationality) {
      case 'BE': return '🇧🇾';
      case 'EN': return '🇬🇧';
      case 'FR': return '🇫🇷';
      case 'GE': return '🇬🇪';
      case 'DE': return '🇩🇪';
      case 'RO': return '🇲🇩';
      case 'NL': return '🇳🇱';
      case 'NO': return '🇳🇴';
      case 'PL': return '🇵🇱';
      case 'RU': return '🇷🇺';
      case 'ES': return '🇪🇸';
      case 'SE': return '🇸🇪';
      case 'UK': return '🇺🇦';
      case 'OTHER': return '🏳️';
      default: return '🇬🇧';
    }
  }

  static String convertShortNameToFullName(BuildContext context, String nationality) {
    switch (nationality) {
      case 'BE': return getTranslated(context, 'belarus');
      case 'EN': return getTranslated(context, 'england');
      case 'FR': return getTranslated(context, 'france');
      case 'GE': return getTranslated(context, 'georgia');
      case 'DE': return getTranslated(context, 'germany');
      case 'RO': return getTranslated(context, 'romania');
      case 'NL': return getTranslated(context, 'netherlands');
      case 'NO': return getTranslated(context, 'norway');
      case 'PL': return getTranslated(context, 'poland');
      case 'RU': return getTranslated(context, 'russia');
      case 'ES': return getTranslated(context, 'spain');
      case 'SE': return getTranslated(context, 'sweden');
      case 'UK': return getTranslated(context, 'ukraine');
      case 'OTHER': return getTranslated(context, 'other');
      default: return getTranslated(context, 'england');
    }
  }
}
