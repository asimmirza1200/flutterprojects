import 'package:flutter/material.dart';

class AppRoutes {
  static const String HOME = '/';
  static const String SUBJECT_SELECTION = '/subject-selection';
  static const String CLASS_SELECTION = '/class-selection';
  static const String MENU_SELECTION = '/menu-selection';
  static const String UNIT_SELECTION = '/unit-selection';
  static const String SUBJECT_SELECTION_ONE = '/subject-selection-one';
  static const String SUBJECT_SELECTION_TWO = '/subject-selection-two';
  static const String SUBJECT_SELECTION_SECOND = '/subject-selection-second';
  static const String SUBJECT_SELECTION_THREE = '/subject-selection-three';
  static const String SUBJECT_SELECTION_FOUR = '/subject-selection-four';
  static const String SUBJECT_SELECTION_FIVE = '/subject-selection-five';
  static const String SUBJECT_SELECTION_SIX = '/subject-selection-six';
  static const String SUBJECT_SELECTION_SEVEN = '/subject-selection-seven';
  static const String SUBJECT_SELECTION_EIGHT = '/subject-selection-eight';
  static const String SUBJECT_SELECTION_NINE = '/subject-selection-nine';
  static const String SUBJECT_SELECTION_TEN = '/subject-selection-ten';
  static const String SUBJECT_SELECTION_SUB = '/subject-selection-sub';
  static const String SUBJECT_SELECTION_ELEVEN = '/subject-selection-eleven';
  static const String SUBJECT_SELECTION_TWELVE = '/subject-selection-twelve';
  static const String CHOOSE_LANGUAGE = '/choose-language';
  static const String COURSE_ACTIVITY = '/main-activity';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String OTP_VERIFICATION = '/otp-verification';
  static const String QUIZ_SCREEN = '/quiz-screen';
  static const String PLAY_SCREEN = '/play-screen';
  static const String PROFILE_SCREEN = '/profile-screen';
  static const String VIDEO_PAGE = '/video-page';
  static const String LOCAL_VIDEO_PAGE = '/local-video-page';
  static const String LEADERBOARD = '/leaderboard';
  static const String QUIZ_SUBMISSION = '/submit-quiz';
  static const String PAYMENT_SCREEN = '/payment-screen';
  static const String MY_ORDERS = '/orders-screen';
  static const String OFFLINE_PAYMENT = '/offline-payment';
  static const String CLASS_SCREEN = '/class-screen';
  static const String UPSC_MENU = '/upsc-screen';
  static const String TECHNOLOGY_MENU = '/technology-screen';
  static const String KERELA_MENU = '/kerela-screen';
  static const String KERALA_CLASS_SELECTION = '/kerela-class_selection';
  static const String KERALA_UNIT_SELECTION = '/kerela-unit_selection';
  static const String KERALA_COURSE_ACTIVITY = '/kerela-course-activity';
  static const String KERALA_SLIDE_PAGE = '/kerela-slide-page';
  static const String KERALA_QUIZ_SCREEN = '/kerela-quiz-screen';
  static const String KERALA_PLAY_SCREEN = '/kerela-play-screen';
  static const String KERALA_PLAY_ACTIVITY = '/kerela-play-activity';
  static const String KERALA_PAYMENT_SCREEN = '/kerela-payment-screen';

  static void nextScreen(context, path, {arguments}) {
    Navigator.of(context).pushNamed(path, arguments: arguments);
  }
  static void replaceScreen(context, path, {arguments}) {

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (BuildContext context) => MenuSelection()),
    //         (Route<dynamic> route) => false
    // );
  }
  static List<String> classRoutes = [
    AppRoutes.SUBJECT_SELECTION_ONE,
    AppRoutes.SUBJECT_SELECTION_TWO,
    AppRoutes.SUBJECT_SELECTION_THREE,
    AppRoutes.SUBJECT_SELECTION_FOUR,
    AppRoutes.SUBJECT_SELECTION_FIVE,
    AppRoutes.SUBJECT_SELECTION_SIX,
    AppRoutes.SUBJECT_SELECTION_SEVEN,
    AppRoutes.SUBJECT_SELECTION_EIGHT,
    AppRoutes.SUBJECT_SELECTION_NINE,
    AppRoutes.SUBJECT_SELECTION_TEN,
    AppRoutes.SUBJECT_SELECTION_ELEVEN,
    AppRoutes.SUBJECT_SELECTION_TWELVE,
  ];
}
