import 'package:lesson_flutter/models/Question.dart';
import 'package:lesson_flutter/utils/toast.dart';

class QuizQuestion {
  final int id;
  final String name;
  final String description;
  final DateTime startPublish;
  final DateTime endPublish;
  final int maxScore;
  final int limitTime;
  final List<Question> questions;
  QuizQuestion({
    this.id,
    this.name,
    this.description,
    this.startPublish,
    this.endPublish,
    this.maxScore,
    this.limitTime,
    this.questions,
  });
  factory QuizQuestion.fromJson(Map json) {
    try {
      return QuizQuestion(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        startPublish: DateTime.parse(json["startpublish"]),
        endPublish: DateTime.parse(json["endpublish"]),
        maxScore: json["max_score"],
        limitTime: json["limit_time"],
        questions: json["questions"]
            .map<Question>((question) => Question.fromJson(question))
            .toList(),
      );
    } catch (e) {
      doAlert(message: "Error while loading quiz");
      return null;
    }
  }
}
