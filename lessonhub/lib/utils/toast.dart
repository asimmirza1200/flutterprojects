import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void doAlert({String message, type = "danger"}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: type == "danger" ? Colors.red : Colors.blue,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
