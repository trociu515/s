class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> getLanguages() {
    return <Language>[
      Language(1, '🇧🇾', 'BLR', 'be'),
      Language(2, '🇬🇧', 'GBR', 'en'),
      Language(3, '🇫🇷', 'FRA', 'fr'),
      Language(4, '🇬🇪', 'GEO', 'pt'),
      Language(5, '🇩🇪', 'DEU', 'de'),
      Language(6, '🇲🇩', 'ROU', 'ro'),
      Language(7, '🇳🇱', 'NLD', 'nl'),
      Language(8, '🇳🇴', 'NOR', 'no'),
      Language(9, '🇵🇱', 'POL', 'pl'),
      Language(10, '🇷🇺', 'RUS', 'ru'),
      Language(11, '🇪🇸', 'ESP', 'es'),
      Language(12, '🇸🇪', 'SWE', 'ca'),
      Language(13, '🇺🇦', 'UKR', 'uk'),
    ];
  }
}
