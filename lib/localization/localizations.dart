import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:it_delivery/network_utils/dio.dart';
// import 'package:hubdesk_app/CONFIGURATION.dart';
// import 'package:hubdesk_app/provider/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MasterLocalizations {
  final Locale locale;

  static const LocalizationsDelegate<MasterLocalizations> delegate =
      DemoLocalizationsDelegate();

  MasterLocalizations(this.locale);

  static MasterLocalizations of(BuildContext context) {
    return Localizations.of<MasterLocalizations>(context, MasterLocalizations);
  }

  static Map<String, dynamic> _localizedValues = {};

  Future<void> loadLanguage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');

  
    // if (true) {
    final response = await dio().get('translation/${locale.languageCode}');

    if (response.statusCode == 200) {
      final words = response.data as List;
      _localizedValues =  Map.fromIterable(words,key: (e) => e['word'], value: (e) => e['translation']);
    } else {
      _localizedValues = {};
    }
    // } else {
    //   _localizedValues = {};
    // }
  }

  String getTranslatedValue(String key) {
    return _localizedValues[key] ?? key;
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<MasterLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar', 'in', 'ur', 'nep'].contains(locale.languageCode);

  @override
  Future<MasterLocalizations> load(Locale locale) async {
    MasterLocalizations localization = MasterLocalizations(locale);
    await localization.loadLanguage();
    return localization;
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
