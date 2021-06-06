import 'package:flutter/material.dart';
import 'package:it_delivery/model/language.dart';
import './localizations.dart';
// import 'package:hubdesk_app/model/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

String T(BuildContext context, String key) {
  return MasterLocalizations.of(context).getTranslatedValue(key.trim()) ?? key;
}

Future<Locale> setLocal(String languangeCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('language', languangeCode);
  
  return _local(languangeCode);
}

Locale _local(String languangeCode) {
  // Locale _temp = Locale(language.languageCode, language.languagePrefix);
  final language = Language.languageList()
      .firstWhere((element) => element.languageCode == languangeCode);
  return Locale(language.languageCode, language.languagePrefix);
}

Future<Locale> getLocal() async {
  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String language = prefs.getString('language') ?? 'en';
  return _local(language);
}
