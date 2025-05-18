import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
//multi user orvol tuhain tohirgoog session-based bolgoj oor oor humuusd tus tus hadgalah heregtei.

//interfeisiin hel songoltiig hadgalsan
class LanguageService {
  final SharedPreferences _prefs;
  static const String _languageKey = 'language';

  LanguageService(this._prefs);

  String get currentLanguage => _prefs.getString(_languageKey) ?? 'en';
//set language funkts ni hereglegchiin songoson heliig
//_languagekey nerteigeer sharedPreferences hesegt hadgaldag.
  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }

//shared preferences oos hagdalagdsan helniii utgiig avsan
  Future<void> initializeLanguage(BuildContext context) async {
    final savedLanguage = currentLanguage;
    await context.setLocale(Locale(savedLanguage));
  }
}
