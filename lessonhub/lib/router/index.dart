import 'package:flutter/material.dart';
import 'package:lesson_flutter/pages/activity_screen/leaderboard.dart';
import 'package:lesson_flutter/pages/activity_screen/local_video_player.dart';
import 'package:lesson_flutter/pages/activity_screen/play_screen.dart';
import 'package:lesson_flutter/pages/activity_screen/quiz_activity.dart';
import 'package:lesson_flutter/pages/activity_screen/quiz_screen.dart';
import 'package:lesson_flutter/pages/activity_screen/quiz_submission.dart';
import 'package:lesson_flutter/pages/activity_screen/video_player.dart';
import 'package:lesson_flutter/pages/choose_language.dart';
import 'package:lesson_flutter/pages/class_screen.dart';
import 'package:lesson_flutter/pages/class_selection.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_eight.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_eleven.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_four.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_nine.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_one.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_seven.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_six.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_ten.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_three.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_twelve.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_two.dart';
import 'package:lesson_flutter/pages/kerela/kerala_class_selection.dart';
import 'package:lesson_flutter/pages/kerela/kerala_course_activity.dart';
import 'package:lesson_flutter/pages/kerela/kerala_payment_screen.dart';
import 'package:lesson_flutter/pages/kerela/kerala_play_activity.dart';
import 'package:lesson_flutter/pages/kerela/kerala_play_screen.dart';
import 'package:lesson_flutter/pages/kerela/kerala_quiz_activity.dart';
import 'package:lesson_flutter/pages/kerela/kerala_quiz_screen.dart';
import 'package:lesson_flutter/pages/kerela/kerala_slides_page.dart';
import 'package:lesson_flutter/pages/kerela/kerela_menu.dart';
import 'package:lesson_flutter/pages/kerela/kerela_unit_selection.dart';
import 'package:lesson_flutter/pages/login_screen.dart';
import 'package:lesson_flutter/pages/main_activity.dart';
import 'package:lesson_flutter/pages/menu_selection.dart';
import 'package:lesson_flutter/pages/offline_payment.dart';
import 'package:lesson_flutter/pages/orders.dart';
import 'package:lesson_flutter/pages/otp_verification.dart';
import 'package:lesson_flutter/pages/payment_detail.dart';
import 'package:lesson_flutter/pages/profile.dart';
import 'package:lesson_flutter/pages/signup_screen.dart';
import 'package:lesson_flutter/pages/sub_class_selection.dart';
import 'package:lesson_flutter/pages/subject_selection.dart';
import 'package:lesson_flutter/pages/classes/subject_selection_five.dart';
import 'package:lesson_flutter/pages/subject_selection_second.dart';
import 'package:lesson_flutter/pages/subject_selection_third.dart';
import 'package:lesson_flutter/pages/technology/technology_menu.dart';
import 'package:lesson_flutter/pages/unit_selection.dart';
import 'package:lesson_flutter/pages/upsc/upsc_menu.dart';
import 'package:lesson_flutter/router/routes.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.CLASS_SELECTION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => ClassSelection(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.KERALA_CLASS_SELECTION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaClassSelection(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.MENU_SELECTION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => MenuSelection(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
        ),
      );
    case AppRoutes.UNIT_SELECTION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => UnitSelection(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.KERALA_UNIT_SELECTION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaUnitSelection(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_SECOND:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionSecond(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_FOUR:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionFour(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_FIVE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionFive(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_SIX:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionSix(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF5b6d66),
          leftPatternColor: Color(0xFF789182),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_SEVEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionSeven(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF9d1f85),
          leftPatternColor: Color(0xFFf7bdcb),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_EIGHT:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionEight(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF772904),
          leftPatternColor: Color(0xFFf1bf87),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_NINE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionNine(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffc8b8),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_TEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionTen(
          themeColor: Color(0xFFd4f6c5),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFe2f5c2),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_ELEVEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionEleven(
          themeColor: Color(0xFFd4f6c5),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFe2f5c2),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_TWELVE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionTwelve(
          themeColor: Color(0xFFd4f6c5),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFe2f5c2),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_THREE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionThree(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.CHOOSE_LANGUAGE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => ChooseLanguage(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_ONE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionOne(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_TWO:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionTwo(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.SUBJECT_SELECTION_SUB:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelectionSub(
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.LOGIN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => LoginScreen(),
      );
    case AppRoutes.COURSE_ACTIVITY:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => MainActivity(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERALA_COURSE_ACTIVITY:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaCourseActivity(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERALA_SLIDE_PAGE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaSlidePage(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.VIDEO_PAGE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => VideoPlayer(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.LOCAL_VIDEO_PAGE:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => LocalVideoPlayer(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERALA_PLAY_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaPlayScreen(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERALA_PLAY_ACTIVITY:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaPlayActivity(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.QUIZ_SUBMISSION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => QuizSubmission(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.QUIZ_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => QuizScreen(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERALA_QUIZ_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaQuizScreen(
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.PLAY_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => PlayScreen(
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.REGISTER:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SignUpScreen(),
      );
    case AppRoutes.OTP_VERIFICATION:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => OtpVerification(),
      );
    case AppRoutes.PROFILE_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => Profile(),
      );
    case AppRoutes.LEADERBOARD:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => LeaderBoard(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.PAYMENT_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => PaymentDetail(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERALA_PAYMENT_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KeralaPaymentDetail(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.MY_ORDERS:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => Orders(
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.CLASS_SCREEN:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => ClassScreen(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.OFFLINE_PAYMENT:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => OfflinePayment(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.UPSC_MENU:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => UpscMenu(
          arguments: settings.arguments,
        ),
      );

    case AppRoutes.TECHNOLOGY_MENU:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => TechnologyMenu(
          arguments: settings.arguments,
        ),
      );
    case AppRoutes.KERELA_MENU:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => KerelaMenu(
          arguments: settings.arguments,
        ),
      );
    default:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => SubjectSelection(
          themeColor: Color(0xFFffc8b8),
          leftTextColor: Color(0xFF6a3e0a),
          leftPatternColor: Color(0xFFffe6ca),
        ),
      );
  }
}
