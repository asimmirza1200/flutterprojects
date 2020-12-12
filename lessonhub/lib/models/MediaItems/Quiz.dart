import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/models/QuizQuestion.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/toast.dart';

class Quiz {
  static List getQuizzes(List allMedia) {
    List<Unit> returnAllMedia = [];
    List quizMedia =
        allMedia.where((element) => element.name.contains("Quiz")).toList();

    List uniqueKeys =
        uniqueList(quizMedia.map((e) => e.alias).toList()).toList();
    for (int i = 0; i < uniqueKeys.length; i++) {
      returnAllMedia.add(allMedia
          .where((element) => element.alias == uniqueKeys[i])
          .toList()[0]);
    }

    return returnAllMedia;
  }

  static String getQuizId(Unit unit, [String conj = ""]) {
    try {
      String quizNumber = unit.name
          .split("-")
          .last
          .trim()
          .replaceAll(RegExp(r"\s+"), "-")
          .toLowerCase();
      print("The quiz number is ${unit.name}");
      quizNumber = RegExp("[0-9]").hasMatch(quizNumber[quizNumber.length - 1])
          ? quizNumber
          : quizNumber + "1";
      return "${unit.schoolClass.classNumber}-${unit.unit}-${getLanguageCode(unit.subject.alias, unit)}-${unit.subject.alias}$conj-$quizNumber";
    } catch (e) {
      return null;
    }
  }

  static String getLanguageCode(String alias, Unit unit) {
    print("ALias is ${unit.schoolClass.language.substring(1)}");
    return alias.toLowerCase().contains("english") ||
            alias.toLowerCase().contains("malayalam")
        ? "em"
        : unit.schoolClass.language.substring(1) == "e"
            ? "e"
            : "m";
  }

  static Future<dynamic> getQuizQuestions(String quizId, [String connection]) {
    try {
      var res = RequestHelper.getApi("/quiz/$quizId",
          queryParameters: {"connection": connection});
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
    }
  }

  static Future<dynamic> submitQuiz(
      Map answers, int quizId, int programId) async {
    try {
      var res = await RequestHelper.postApi("/submit-quiz", {
        "answers": answers,
        "quiz_id": quizId,
        "program_id": programId,
        "type": "quiz"
      });
      if (res != null && res["success"]) {
        doAlert(message: res["message"], type: "success");
      } else {
        doAlert(message: "Error while submitting quiz", type: "danger");
      }
    } catch (e) {
      doAlert(message: "Error while submitting quiz", type: "danger");
      return null;
    }
  }
}
