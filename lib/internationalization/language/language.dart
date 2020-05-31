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
      Language(3, '🇩🇪', 'German', 'de'),
      Language(4, '🇲🇩', 'Moldavian', 'ro'),
      Language(5, '🇵🇱', 'Polish', 'pl'),
      Language(6, '🇷🇺', 'Russian', 'ru'),
      Language(7, '🇺🇦', 'Ukrainian', 'uk'),
    ];
  }
}
