class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, '🇧🇾', 'BE', 'be'),
      Language(2, '🏴󠁧󠁢󠁥󠁮󠁧󠁿', 'EN', 'en'),
      Language(3, '🇫🇷', 'FR', 'fr'),
      Language(4, '🇬🇪', 'GE', 'pt'),
      Language(5, '🇩🇪', 'DE', 'de'),
      Language(6, '🇲🇩', 'RO', 'ro'),
      Language(7, '🇳🇱', 'NL', 'nl'),
      Language(8, '🇵🇱', 'PL', 'pl'),
      Language(9, '🇷🇺', 'RU', 'ru'),
      Language(10, '🇪🇸', 'ES', 'es'),
      Language(11, '🇸🇪', 'SE', 'ca'),
      Language(12, '🇺🇦', 'UK', 'uk'),
    ];
  }
}
