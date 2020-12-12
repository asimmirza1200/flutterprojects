import 'package:flutter/material.dart';
import 'package:lesson_flutter/pages/activity_screen/leaderboard.dart';
import 'package:lesson_flutter/pages/choose_language.dart';
import 'package:lesson_flutter/pages/class_selection.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_one.dart';
import 'package:lesson_flutter/pages/login_screen.dart';
import 'package:lesson_flutter/pages/main_activity.dart';
import 'package:lesson_flutter/pages/menu_selection.dart';
import 'package:lesson_flutter/pages/otp_verification.dart';
import 'package:lesson_flutter/pages/payment_detail.dart';
import 'package:lesson_flutter/pages/signup_screen.dart';
import 'package:lesson_flutter/pages/unit_selection.dart';
import 'package:lesson_flutter/pages/walkthrough.dart';
import 'package:lesson_flutter/providers/language_provider.dart';
import 'package:lesson_flutter/providers/quiz_question_provider.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/providers/subscription_provider.dart';
import 'package:lesson_flutter/router/index.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lesson_flutter/utils/global_values.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initApp() async {
    await Firebase.initializeApp();
    var logged = await SharedPrefs.getBool("logged"+await SharedPrefs.getString("category", ""), false);
    var language = await SharedPrefs.getString("language", "");
    var category = await SharedPrefs.getString("category", "");
    var openedBefore = await SharedPrefs.getBool("opened_before", false);
    return {
      "logged"+await SharedPrefs.getString("category", ""): logged,
      "language": language,
      "category": category,
      "opened_before": openedBefore,
    };
  }

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizQuestionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubscriptionProvider(),
        ),
      ],
      child: FutureBuilder(
        // Initialize FlutterFire
        future: initApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: CircularProgressIndicator(),
              ),
            );
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              navigatorKey: GlobalsValues.globalScaffold,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: onGenerateRoute,
              home: snapshot.data != null
                  ? getAfterLoginWidget(snapshot.data)
                  : Walkthrough(),
            );
          }

          return MaterialApp(
            home: Scaffold(
              body: CircularProgressIndicator(),
            ),
          );

          // Otherwise, show something whilst waiting for initialization to complete
        },
      ),
    ),
  );
}

Widget getAfterLoginWidget(Map data) {
  if (!data["opened_before"]) {
    return Walkthrough();
  }

  return MenuSelection();
  // return data["provider_category"] != null && data["provider_category"]
  //     ? ClassSelection()
  //     : MenuSelection();
}
