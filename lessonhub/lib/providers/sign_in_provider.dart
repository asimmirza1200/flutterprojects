import 'package:flutter/material.dart';

class SignInProvider with ChangeNotifier {
  bool _codeSent = false;
  Map _mobileData = {};
  String _category;
  String _language;

  String get category {
    return _category;
  }

  set category(String val) {
    _category = val;
    notifyListeners();
  }

  String get language {
    return _language;
  }

  set language(String val) {
    _language = val;
    notifyListeners();
  }

  bool get codeSent {
    return _codeSent;
  }

  set codeSent(bool val) {
    _codeSent = val;
    notifyListeners();
  }

  resetLoginPage() {
    _codeSent = false;
  }

  Map get mobileData {
    return _mobileData;
  }

  set mobileData(Map val) {
    _mobileData = val;
    notifyListeners();
  }
}
