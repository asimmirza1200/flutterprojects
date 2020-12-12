import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/models/QuizQuestion.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';

class UnitTest {
  static List getUnitTests(List allMedia) {
    List<Unit> returnAllMedia = [];
    List unitTestMedia =
        allMedia.where((element) => element.name.contains("Unit")).toList();

    List uniqueKeys =
        uniqueList(unitTestMedia.map((e) => e.alias).toList()).toList();
    for (int i = 0; i < uniqueKeys.length; i++) {
      returnAllMedia.add(allMedia
          .where((element) => element.alias == uniqueKeys[i])
          .toList()[0]);
    }

    return returnAllMedia;
  }

  static List getSlides(List allMedia) {
    List<Unit> returnAllMedia = [];
    List unitTestMedia =
        allMedia.where((element) => element.name.contains("slide")).toList();

    List uniqueKeys =
        uniqueList(unitTestMedia.map((e) => e.alias).toList()).toList();
    for (int i = 0; i < uniqueKeys.length; i++) {
      returnAllMedia.add(allMedia
          .where((element) => element.alias == uniqueKeys[i])
          .toList()[0]);
    }

    return returnAllMedia;
  }

  static String getUnitTestId(Unit unit) {
    try {
      String unitTestNumber =
          unit.name.split("-").last.trim().replaceAll(" ", "-").toLowerCase();

      unitTestNumber =
          RegExp("[0-9]").hasMatch(unitTestNumber[unitTestNumber.length - 1])
              ? unitTestNumber
              : unitTestNumber + "1";
      return "${unit.schoolClass.classNumber}-${unit.unit}-${getLanguageCode(unit.subject.alias, unit)}-${unit.subject.alias}-unit-test-$unitTestNumber"
          .replaceAll("unit-test-unit-test", "unit-test");
    } catch (e) {
      return null;
    }
  }

  static String getLanguageCode(String alias, Unit unit) {
    print("ALias is ${unit.schoolClass.language}");
    return alias.toLowerCase().contains("english") ||
            alias.toLowerCase().contains("malayalam")
        ? "em"
        : unit.schoolClass.language.substring(1) == "e"
            ? "e"
            : "m";
  }

  static Future getLeaderboard(int unitTestId) async {
    try {
      String connection =
          await SharedPrefs.getString("category", "mysql_school");
      return RequestHelper.getApi("/leaderboard", queryParameters: {
        "unit_test_id": unitTestId,
        "connection": connection,
      });
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> getUnitTestQuestions(String unitTestId) {
    try {
      var res = RequestHelper.getApi("/quiz/$unitTestId");
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
      return null;
    }
  }

  static Future<dynamic> getGroupedUnitTestQuestions(String unitTestId,
      [String connection]) {
    try {
      var res = RequestHelper.getApi("/grouped-quiz", queryParameters: {
        "connection": connection,
        "quiz_query": unitTestId
      });
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
      return null;
    }
  }

  static Future<dynamic> createUnitTest(
      Map answers, int quizId, int programId, int totalQuestions,
      [String connection]) async {
    try {
      var res = await RequestHelper.postApi("/create-quiz-taken", {
        "answers": answers,
        "quiz_id": quizId,
        "program_id": programId,
        "question_count": totalQuestions,
        "connection": connection,
      });
      if (res != null && res["success"]) {
        return res;
      } else {
        return res;
      }
    } catch (e) {
      print(e);
      return {
        "success": false,
        "message": e != null ? e["message"] : "Error while creating quiz"
      };
    }
  }

  // create-quiz-taken

  static Future<dynamic> submitUnitTest(Map answers, int quizId, int programId,
      [String connection]) async {
    try {
      var res = await RequestHelper.postApi("/submit-quiz", {
        "answers": answers,
        "quiz_id": quizId,
        "program_id": programId,
        "type": "unit_test",
        "connection": connection
      });
      if (res != null && res["success"]) {
        doAlert(message: res["message"], type: "success");
      }
    } catch (e) {
      doAlert(message: "Error while submitting quiz", type: "danger");
    }
  }
}
