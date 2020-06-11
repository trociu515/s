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
      Language(3, '🇬🇪', 'Georgia', 'pt'),
      Language(4, '🇩🇪', 'German', 'de'),
      Language(5, '🇲🇩', 'Moldavian', 'ro'),
      Language(6, '🇵🇱', 'Polish', 'pl'),
      Language(7, '🇷🇺', 'Russian', 'ru'),
      Language(8, '🇺🇦', 'Ukrainian', 'uk'),
    ];
  }
}
