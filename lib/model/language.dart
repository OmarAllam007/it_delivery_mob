class Language {
  final int id;
  final String name;
  final String flag;
  final String languageCode;
  final String languagePrefix;

  Language(
      {this.id, this.name, this.flag, this.languageCode, this.languagePrefix});

  static List<Language> languageList() {
    return <Language>[
      Language(
          id: 1,
          name: 'English',
          flag: '🇺🇸 ',
          languageCode: 'en',
          languagePrefix: 'US'),
      Language(
        id: 2,
        name: 'العربية',
        flag: '🇸🇦 ',
        languageCode: 'ar',
        languagePrefix: 'SA',
      ),
    ];
  }
}
