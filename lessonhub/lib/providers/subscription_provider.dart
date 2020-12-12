import 'package:flutter/material.dart';

class SubscriptionProvider extends ChangeNotifier {
  static bool _hasRated;
  static String _status;
  static String _userSub;
  static bool _loadingPayment = false;
  static bool _paymentError = false;
  static Map _subscribed = {
    "school": [],
    "kerala": [],
  };
  get userSub {
    return _userSub;
  }

  Map get subscribed {
    return _subscribed;
  }

  get loadingPayment {
    return _loadingPayment;
  }

  get paymentError {
    return _paymentError;
  }

  get hasRated {
    return _hasRated;
  }

  get status {
    return _status;
  }

  set hasRated(bool value) {
    _hasRated = value;
    notifyListeners();
  }

  set subscribed(Map value) {
    _subscribed = value;
    notifyListeners();
  }

  void loadSubscribed(List value, String category) {
    _subscribed[category] = value;
  }

  set loadingPayment(bool value) {
    _loadingPayment = value;
    notifyListeners();
  }

  set paymentError(bool value) {
    _paymentError = value;
    notifyListeners();
  }

  set status(String value) {
    _status = value;
    notifyListeners();
  }

  set userSub(String subValue) {
    _userSub = subValue;
    notifyListeners();
  }
}
