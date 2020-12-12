class Answer {
  final int id;
  final String answerContent;
  final bool correctAnswer;

  Answer({this.id, this.answerContent, this.correctAnswer});

  factory Answer.fromJson(Map json) {
    return Answer(
      id: json["id"],
      answerContent: json["answer_content_text"],
      correctAnswer: json["correct_answer"] == 1,
    );
  }
}
