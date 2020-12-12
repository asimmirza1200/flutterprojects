import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter/main.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:provider/provider.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> logoutUser(BuildContext context) async {
    SharedPrefs.setBool("logged"+await SharedPrefs.getString("category", ""), false);
    SharedPrefs.setString("token", null);
    Provider.of<SignInProvider>(context, listen: false).codeSent = false;
  }

  static Future authenticateUser(phoneNumber, String userEmail,
      BuildContext context, setLoader, bool isNew) async {
    // loginUserToServer(
    //     context, {"email": "olayemiiofficial@gmail.com"}, setLoader);
    // return;
    try {
      bool res = false;
      if (userEmail.isNotEmpty) {
        try {
          res = await checkEmailValidity(userEmail, phoneNumber);
        } catch (e) {}
      } else {
        try {
          var response = await RequestHelper.getApiZero(
              "auth/get-email?phone=$phoneNumber");

          print(response);
          if (response != null &&
              response["data"] != null &&
              response["data"]["email"] != null) {
            userEmail = response["data"]["email"];
            res = true;
          } else if (!isNew) {
            doAlert(message: "No user with this mobile number");
            res = false;
            setLoader();
            return;
          } else {
            doAlert(message: "Something went wrong");
            setLoader();
            res = false;
            return;
          }
        } catch (e) {
          print(e);
          res = false;
        }
      }
      if (res) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            print(e);
            setLoader();
            doAlert(message: e.message);
          },
          codeSent: (String verificationId, int resendToken) {
            Provider.of<SignInProvider>(context, listen: false).codeSent = true;
            Provider.of<SignInProvider>(context, listen: false).mobileData = {
              "verificationId": verificationId,
              "resendToken": resendToken,
              "email": userEmail,
              "username": phoneNumber,
              "isNew": isNew
            };
            setLoader();
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        setLoader();
      }
    } catch (e) {
      print(e);
      doAlert(message: "Error logging in");
    }
  }

  static Future<bool> checkEmailValidity(String email, String phone) async {
    Map res = await RequestHelper.postApiZero(
      "/auth/email-availability",
      {"email": email, "phone": phone},
    );

    if (res != null) {
      return true;
    }

    return false;
  }

  static Future registerUserToServer(
      BuildContext context, Map data, stopLoader) async {
    var response = await RequestHelper.postApiZero("/auth/register", data);
    if (response != null) {
      var category = await SharedPrefs.getString("category", "");
      String token = response["data"]["token"]["access_token"];
      String refresh = response["data"]["token"]["refresh_token"];
      SharedPrefs.setString("user", json.encode(response["data"]["user"]));

      List loggedCategories = json
          .decode((await SharedPrefs.getString("logged_categories")) ?? "[]");
      SharedPrefs.setString("token", token);
      SharedPrefs.setString("refresh", refresh);
      doAlert(message: "Account verified successfully", type: "success");
      stopLoader();
      var language = await SharedPrefs.getString("language", "");
      var openedBefore = await SharedPrefs.getBool("opened_before", false);
      if (category.isNotEmpty && !loggedCategories.contains(category)) {
        loggedCategories.add(category);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return getAfterLoginWidget({
          "logged"+category: true,
          "language": language,
          "category": category,
          "opened_before": openedBefore
        });
      }));
    } else {
      stopLoader();
    }
  }

  static Future loginUserToServer(
      BuildContext context, Map data, stopLoader) async {
    var response = await RequestHelper.postApiZero("/auth/login", data);
    if (response != null) {
      SharedPrefs.setString("user", json.encode(response["data"]["user"]));
      var category = await SharedPrefs.getString("category", "");
      String token = response["data"]["token"]["access_token"];
      String refresh = response["data"]["token"]["refresh_token"];
      SharedPrefs.setString("token", token);
      SharedPrefs.setString("refresh", refresh);
      String loggedCategoriesStr =
          await SharedPrefs.getString("logged_categories", "[]");
      List loggedCategories = json.decode(loggedCategoriesStr);
      doAlert(message: "Account verified successfully", type: "success");
      stopLoader();
      var language = await SharedPrefs.getString("language", "");
      var openedBefore = await SharedPrefs.getBool("opened_before", false);

      if (category.isNotEmpty && !loggedCategories.contains(category)) {
        loggedCategories.add(category);
      }
      SharedPrefs.setString("logged_categories", json.encode(loggedCategories));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) {
        return getAfterLoginWidget({
          "logged"+category: true,
          "language": language,
          "provider_category":
              Provider.of<SignInProvider>(context).category != null,
          "category": category,
          "opened_before": openedBefore
        });
      }));
    } else {
      stopLoader();
    }
  }
}
