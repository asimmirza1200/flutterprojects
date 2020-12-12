import 'package:flutter/material.dart';
import 'package:lesson_flutter/models/Answer.dart';
import 'package:lesson_flutter/models/Question.dart';
import 'package:lesson_flutter/models/QuizQuestion.dart';
import 'package:lesson_flutter/models/Unit.dart';

class QuizQuestionProvider with ChangeNotifier {
  bool _answerChosen = false;
  bool _startedPlaying = false;
  int _currentIndex = 0;
  bool _displayCorrectAnswer = false;
  Map _questionAnswers = {};

  void answerQuestion(
    String index,
    Answer answer,
    Question question,
  ) {
    _questionAnswers[index] = {
      "answer": answer == null ? null : answer.answerContent,
      "is_correct": answer == null ? false : answer.correctAnswer,
      "points": question.points,
    };
    this.notifyListeners();
  }

  set questionAnswers(Map value) {
    _questionAnswers = value;
    this.notifyListeners();
  }

  get questionAnswers {
    return _questionAnswers;
  }

  set answerChosen(bool val) {
    _answerChosen = val;
    this.notifyListeners();
  }

  get answerChosen {
    return _answerChosen;
  }

  set displayCorrectAnswer(bool val) {
    _displayCorrectAnswer = val;
    this.notifyListeners();
  }

  get displayCorrectAnswer {
    return _displayCorrectAnswer;
  }

  set startedPlaying(bool val) {
    _startedPlaying = val;
    this.notifyListeners();
  }

  get startedPlaying {
    return _startedPlaying;
  }

  set currentIndex(int val) {
    _currentIndex = val;
    this.notifyListeners();
  }

  get currentIndex {
    return _currentIndex;
  }
}
