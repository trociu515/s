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

  static String convertShortNameToFullName(String nationality) {
    switch (nationality) {
      case 'BE': return 'Беларуская';
      case 'EN': return 'English';
      case 'FR': return 'French';
      case 'GE': return 'ქართველი';
      case 'DE': return 'Deutsche';
      case 'RO': return 'Română';
      case 'NL': return 'Nederlands';
      case 'NO': return 'Norsk';
      case 'PL': return 'Polska';
      case 'RU': return 'русский';
      case 'ES': return 'Español';
      case 'SE': return 'Svenska';
      case 'UK': return 'Український';
      case 'OTHER': return 'Other';
      default: return 'English';
    }
  }
}
