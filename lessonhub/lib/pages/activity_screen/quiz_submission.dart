import 'package:flutter/material.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/MediaItems/Video.dart';
import 'package:lesson_flutter/pages/kerela/kerela_menu.dart';
import 'package:lesson_flutter/pages/main_activity.dart';
import 'package:lesson_flutter/providers/quiz_question_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:async/async.dart';

class QuizSubmission extends StatefulWidget {
  final Map arguments;
  QuizSubmission({this.arguments});

  @override
  _QuizSubmissionState createState() => _QuizSubmissionState();
}

class _QuizSubmissionState extends State<QuizSubmission> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  bool _submitted = false;

  Map getScore(List answers) {
    int correctAnswers = 0;
    int totalQuestions = answers.length;
    for (int i = 0; i < answers.length; i++) {
      correctAnswers += answers[i] == null
          ? 0
          : answers[i]["is_correct"]
              ? 1
              : 0;
    }
    return {"correct": correctAnswers, "total": totalQuestions};
  }

  @override
  Widget build(BuildContext context) {
    final QuizQuestionProvider qp = Provider.of<QuizQuestionProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) {
            return MainActivity(
              arguments: {"class": this.widget.arguments["unit"]},
            );
          },
        ), (Route route) {
          return route.settings.name == AppRoutes.UNIT_SELECTION;
        });
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
            future: this._memoizer.runOnce(() async {
              String category =
                  await SharedPrefs.getString("category", "mysql_school");
              if (!_submitted) {
                var data;
                if (this.widget.arguments["type"] == "unit") {
                  data = UnitTest.submitUnitTest(
                    this.widget.arguments["answers"],
                    this.widget.arguments["quizId"],
                    this.widget.arguments["programId"],
                    category,
                  );
                } else {
                  data = Quiz.submitQuiz(
                    this.widget.arguments["answers"],
                    this.widget.arguments["quizId"],
                    this.widget.arguments["programId"],
                  );
                }
                setState(() {
                  _submitted = true;
                });
                return data;
              }
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Loader(),
                );
              }

              Map data =
                  getScore(this.widget.arguments["answers"].values.toList());
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  "assets/bg-full.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Image.asset(
                            "assets/blue-top-pattern.png",
                            width: 350.0,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: Image.asset(
                            "assets/blue-bottom-pattern.png",
                            width: 200.0,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF1f6bd1),
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 35.0,
                                ),
                                child: Text(
                                  "YOUR SCORE",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    color: Color(0xFF1f6bd1),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF1f6bd1),
                                  border: Border.all(
                                    color: Color(0xFF1f6bd1),
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 35.0,
                                ),
                                child: Text(
                                  "${data['correct']} / ${data['total']}",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 70.0,
                              ),
                              InkWell(
                                onTap: () async {
                                  String category = await SharedPrefs.getString(
                                      "category", "mysql_school");
                                  if (this.widget.arguments["unit"] == null &&
                                      category == "mysql_psc") {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return KerelaMenu();
                                        },
                                      ),
                                      (route) =>
                                          route.settings.name ==
                                          AppRoutes.MENU_SELECTION,
                                    );
                                  } else {
                                    AppRoutes.nextScreen(
                                      context,
                                      category == "mysql_school"
                                          ? AppRoutes.COURSE_ACTIVITY
                                          : AppRoutes.KERALA_COURSE_ACTIVITY,
                                      arguments: category == "mysql_school"
                                          ? {
                                              "class":
                                                  this.widget.arguments["unit"]
                                            }
                                          : {
                                              "courseData": this
                                                  .widget
                                                  .arguments["unit"]
                                                  .subject
                                            },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xFF1f6bd1),
                                      border: Border.all(
                                        color: Color(0xFF1f6bd1),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  width: 200.0,
                                  height: 45.0,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Go Home",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              this.widget.arguments["type"] == "unit"
                                  ? InkWell(
                                      onTap: () {
                                        AppRoutes.nextScreen(
                                          context,
                                          AppRoutes.LEADERBOARD,
                                          arguments: {
                                            "quizId":
                                                this.widget.arguments["quizId"],
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: 200.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1f6bd1),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                            color: Color(0xFF1f6bd1),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 35.0,
                                        ),
                                        child: Container(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              "Leaderboard",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        qp.questionAnswers = {};
                                        qp.displayCorrectAnswer = false;
                                        qp.currentIndex = 0;
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        width: 200.0,
                                        height: 45.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1f6bd1),
                                          borderRadius: BorderRadius.circular(
                                            20.0,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFF1f6bd1),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 35.0,
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            "Play Again",
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
