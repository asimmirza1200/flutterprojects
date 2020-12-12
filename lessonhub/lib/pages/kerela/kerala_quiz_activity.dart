import 'package:flutter/material.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/widgets/loader.dart';

class KeralaQuizActivity extends StatelessWidget {
  final List quizzes;

  KeralaQuizActivity({this.quizzes});

  @override
  Widget build(BuildContext context) {
    List<Unit> displayQuiz = Quiz.getQuizzes(this.quizzes);
    return ListView.builder(
      itemCount: displayQuiz.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            AppRoutes.nextScreen(
              context,
              AppRoutes.KERALA_QUIZ_SCREEN,
              arguments: {"quiz": displayQuiz[index], "type": "quiz"},
            );
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                18.0,
              ),
              color: AppConstants.kBlueColor,
            ),
            height: 120.0,
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  width: 90.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      18.0,
                    ),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 30.0,
                ),
                Expanded(
                  child: Text(
                    "Puzzle - ${index + 1}",
                    // unitNameToTitle(displayQuiz[index].name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
