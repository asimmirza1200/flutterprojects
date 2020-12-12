import 'dart:convert';

import 'package:lesson_flutter/models/Answer.dart';

class Question {
  final int id;
  final String type;
  final String questionContent;
  final int points;
  final String image;
  final List<Answer> answers;

  Question({
    this.id,
    this.type,
    this.questionContent,
    this.points,
    this.image,
    this.answers,
  });

  factory Question.fromJson(Map json) {
    return Question(
      id: json["id"],
      type: json["type"],
      questionContent: json["question_content"],
      points: json["points"],
      image: json["media"] != null ? json["media"]["image"] : null,
      answers: json["answers"]
          .map<Answer>((answer) => Answer.fromJson(answer))
          .toList(),
    );
  }
}
