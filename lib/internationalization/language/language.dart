class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, '🇧🇾', 'BE', 'be'),
      Language(2, '🇬🇧', 'EN', 'en'),
      Language(3, '🇫🇷', 'FR', 'fr'),
      Language(4, '🇬🇪', 'GE', 'pt'),
      Language(5, '🇩🇪', 'DE', 'de'),
      Language(6, '🇲🇩', 'RO', 'ro'),
      Language(7, '🇳🇱', 'NL', 'nl'),
      Language(8, '🇳🇴', 'NO', 'no'),
      Language(9, '🇵🇱', 'PL', 'pl'),
      Language(10, '🇷🇺', 'RU', 'ru'),
      Language(11, '🇪🇸', 'ES', 'es'),
      Language(12, '🇸🇪', 'SE', 'ca'),
      Language(13, '🇺🇦', 'UK', 'uk'),
    ];
  }
}
