class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇧🇾', 'Belarusian', 'be'),
      Language(2, '🏴󠁧󠁢󠁥󠁮󠁧󠁿', 'English', 'en'),
      Language(3, '🇫🇷', 'French', 'fr'),
      Language(4, '🇬🇪', 'Georgia', 'pt'),
      Language(5, '🇩🇪', 'German', 'de'),
      Language(6, '🇲🇩', 'Moldavian', 'ro'),
      Language(7, '🇳🇱', 'Netherlands', 'nl'),
      Language(8, '🇵🇱', 'Polish', 'pl'),
      Language(9, '🇷🇺', 'Russian', 'ru'),
      Language(10, '🇪🇸', 'Spain', 'es'),
      Language(11, '🇸🇪', 'Sweden', 'ca'),
      Language(12, '🇺🇦', 'Ukrainian', 'uk'),
    ];
  }
}
