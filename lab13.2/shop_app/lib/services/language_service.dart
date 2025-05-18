import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

//classni shared preferences ashiglan hadgalah mon hadgalsan heliig easy localization ashiglan dahin sergeeh uuregtei
class LanguageService {
  final SharedPreferences _prefs;
  static const String _languageKey = 'language';
//omnoh hel hadgalagdsan
  LanguageService(this._prefs);

  String get currentLanguage =>
      _prefs.getString(_languageKey) ?? 'en'; //default

  Future<void> setLanguage(String language) async {
    await _prefs.setString(_languageKey, language);
  }//set language ni herglegch yag helee songoj baih yed ajillaj sh/p d hadgalagdana.

  Future<void> initializeLanguage(BuildContext context) async {
    final savedLanguage = currentLanguage;
    await context.setLocale(Locale(
        savedLanguage)); //omno ni songoson heleer interfeisiig avtomataar haruulsan,easylocalization aas irdeg funkts
  }
}
