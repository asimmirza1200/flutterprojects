import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/MediaItems/Slide.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/widgets/loader.dart';

class KerelaSlideActivity extends StatelessWidget {
  final List slides;

  KerelaSlideActivity({this.slides});
  String getSlideGroupName(String aliasType) {
    List parts = aliasType.split("-");
    parts = parts.sublist(1, parts.length - 1);

    return StringUtils.capitalize(parts.join(" "), allWords: true);
  }

  @override
  Widget build(BuildContext context) {
    List<Unit> slides = Slide.getSlides(this.slides);
    Map<int, List<Unit>> slidesPerChapter = Slide.groupSlides(slides);
    return Container(
      child: ListView.separated(
        itemCount: slidesPerChapter.keys.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox();
        },
        itemBuilder: (BuildContext context, int index) {
          List currentSlides =
              slidesPerChapter[slidesPerChapter.keys.toList()[index]];
          return GestureDetector(
            onTap: () {
              AppRoutes.nextScreen(
                context,
                AppRoutes.KERALA_SLIDE_PAGE,
                arguments: {"slides": currentSlides},
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
                      getSlideGroupName(slides[index].name),
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
      ),
    );
  }
}
