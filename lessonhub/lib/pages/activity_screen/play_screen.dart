import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/Answer.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Question.dart';
import 'package:lesson_flutter/models/QuizQuestion.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/providers/quiz_question_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/widgets/countdown_widget.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  final Map arguments;
  PlayScreen({this.arguments});
  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  int _index = 0;
  bool loading = true;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  Color getOptionColor(
      Answer answer, QuizQuestionProvider qp, Question quizQuestion) {
    if (qp.displayCorrectAnswer && answer.correctAnswer) {
      return Colors.green[600];
    } else if (qp.questionAnswers[quizQuestion.id.toString()] != null &&
        qp.questionAnswers[quizQuestion.id.toString()]["answer"] ==
            answer.answerContent) {
      return Colors.red;
    } else {
      return Colors.grey[300];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(microseconds: 0), () {
      QuizQuestionProvider qp =
          Provider.of<QuizQuestionProvider>(context, listen: false);
      qp.questionAnswers = {};
      qp.displayCorrectAnswer = false;
      qp.currentIndex = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final QuizQuestionProvider qp = Provider.of<QuizQuestionProvider>(context);
    String quizId = UnitTest.getUnitTestId(this.widget.arguments["quiz"]);
    print(quizId);
    QuizQuestion quizQuestions;
    Map quizArray;
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content:
                new Text('Do you want to quit quiz, progress wont be saved'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: FutureBuilder(
          future: this._memoizer.runOnce(() async {
            try {
              var data = await UnitTest.getUnitTestQuestions(quizId);
              quizArray = data["data"];
              quizQuestions = QuizQuestion.fromJson(quizArray);
              var res = await UnitTest.createUnitTest(
                {},
                quizQuestions.id,
                this.widget.arguments["quiz"].subject.id,
                quizQuestions.questions.length,
              );
              if (!res["success"]) {
                Navigator.of(context).pop();
              } else {
                return quizQuestions;
              }
            } catch (e) {
              return null;
            }
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loader(),
              );
            }
            if (snapshot.hasError) {
              return Container(
                child: Text("No quiz was loaded"),
              );
            }
            if (snapshot.hasData) {
              quizQuestions = snapshot.data;
              if (quizQuestions == null || quizQuestions.questions == null) {
                return Container(
                  child: Text("No quiz was loaded"),
                );
              }
              return Container(
                child: IndexedStack(
                  index: qp.currentIndex,
                  children: quizQuestions.questions.map((quizQuestion) {
                    return Container(
                      padding: EdgeInsets.all(0),
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        child: Image.network(
                          ApiHandler.getMediaUrl(
                            quizQuestion.image,
                            "images",
                            "school",
                          ),
                          fit: BoxFit.fill,
                          width: double.infinity,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent event) {
                            if (event != null && this.mounted && loading) {
                              Future.delayed(Duration.zero, () {
                                setState(() {
                                  loading = false;
                                });
                              });
                            }
                            Future.delayed(Duration(seconds: 3), () {
                              if (loading) {
                                setState(() {
                                  loading = false;
                                });
                              }
                            });
                            if (event != null || loading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: event == null
                                      ? null
                                      : event.expectedTotalBytes != null
                                          ? event.cumulativeBytesLoaded /
                                              event.expectedTotalBytes
                                          : null,
                                ),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          alignment: Alignment.topLeft,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: child,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0.0),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.arrow_back),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Html(
                                          data:
                                              "<div><strong>Q${qp.currentIndex + 1}/${quizQuestions.questions.length}.</strong> ${quizQuestion.questionContent.replaceAll("<p>", "<span>").replaceAll("</p>", "</span>")}</div>",
                                          style: {
                                            "p": Style(
                                              textAlign: TextAlign.center,
                                              fontSize: FontSize(18.0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                            "div": Style(
                                              textAlign: TextAlign.center,
                                              fontSize: FontSize(18.0),
                                            )
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GridView.count(
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.4,
                                  children: quizQuestion.answers.map((answer) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (qp.questionAnswers[
                                                    qp.currentIndex] !=
                                                null ||
                                            qp.displayCorrectAnswer) {
                                          return;
                                        }
                                        qp.answerQuestion(
                                          quizQuestion.id.toString(),
                                          answer,
                                          quizQuestion,
                                        );
                                        qp.displayCorrectAnswer = true;
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: getOptionColor(
                                              answer, qp, quizQuestion),
                                          borderRadius: BorderRadius.circular(
                                            15.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            answer.answerContent,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: qp.displayCorrectAnswer &&
                                                      answer.correctAnswer
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                qp.displayCorrectAnswer
                                    ? Center(
                                        child: FlatButton(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 45.0,
                                            vertical: 15.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          onPressed: () {
                                            if (qp.currentIndex !=
                                                (quizQuestions
                                                        .questions.length -
                                                    1)) {
                                              qp.displayCorrectAnswer = false;
                                              qp.currentIndex =
                                                  qp.currentIndex + 1;
                                            } else {
                                              AppRoutes.nextScreen(
                                                context,
                                                AppRoutes.QUIZ_SUBMISSION,
                                                arguments: {
                                                  "type": "unit",
                                                  "answers": qp.questionAnswers,
                                                  "quizId": quizQuestions.id,
                                                  "unit": this
                                                      .widget
                                                      .arguments["quiz"],
                                                  "programId": this
                                                      .widget
                                                      .arguments["quiz"]
                                                      .subject
                                                      .id
                                                },
                                              );
                                            }
                                          },
                                          child: Text(
                                            quizQuestions.questions.length -
                                                        1 ==
                                                    qp.currentIndex
                                                ? "Submit"
                                                : "Next",
                                          ),
                                          color: Colors.yellow[800],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 40.0,
                                      ),
                                qp.questionAnswers[
                                                quizQuestion.id.toString()] !=
                                            null ||
                                        this.widget.arguments["type"] == "quiz"
                                    ? SizedBox(height: 14.0)
                                    : CountdownWidget(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        currentIndex: qp.currentIndex,
                                        duration: 10,
                                        onFinishRound: () {
                                          qp.displayCorrectAnswer = true;
                                          qp.answerQuestion(
                                            quizQuestion.id.toString(),
                                            null,
                                            quizQuestion,
                                          );
                                        },
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
