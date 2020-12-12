import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/widgets/loader.dart';

class PlayActivity extends StatelessWidget {
  final List plays;

  PlayActivity({this.plays});

  @override
  Widget build(BuildContext context) {
    List<Unit> displayUnitTest = UnitTest.getUnitTests(this.plays);
    return Container(
      child: ListView.builder(
        itemCount: displayUnitTest.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              AppRoutes.nextScreen(
                context,
                AppRoutes.PLAY_SCREEN,
                arguments: {
                  "quiz": displayUnitTest[index],
                  "type": "unit_test",
                },
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  28.0,
                ),
                child: Image.network(
                  ApiHandler.getMediaUrl(
                    UnitTest.getUnitTestId(displayUnitTest[index]) + ".jpg",
                    "images",
                    "school",
                  ),
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent event) {
                    if (event == null) {
                      return child;
                    }
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppConstants.kBlueColor),
                        borderRadius: BorderRadius.circular(
                          28.0,
                        ),
                      ),
                      child: Wrap(
                        children: [
                          Image.asset(
                            "assets/playstore.png",
                            width: 120.0,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              height: 400.0,
              width: MediaQuery.of(context).size.width * 0.75,
            ),
          );
        },
      ),
    );
  }
}
