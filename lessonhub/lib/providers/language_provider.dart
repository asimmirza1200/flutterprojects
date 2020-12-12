import 'package:flutter/material.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage;

  void loadLanguage() async {
    var language = await SharedPrefs.getString("language", "se");
    _selectedLanguage = language;
    notifyListeners();
  }

  set selectedLanguage(String val) {
    _selectedLanguage = val;
    this.notifyListeners();
  }

  get selectedLanguage {
    return _selectedLanguage;
  }
}
