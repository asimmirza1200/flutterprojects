import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/models/QuizQuestion.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/toast.dart';

class Slide {
  static List getSlides(List allMedia) {
    List<Unit> returnAllMedia = [];
    List unitTestMedia =
        allMedia.where((element) => element.name.contains("slide")).toList();

    List uniqueKeys =
        uniqueList(unitTestMedia.map((e) => e.alias).toList()).toList();
    for (int i = 0; i < uniqueKeys.length; i++) {
      returnAllMedia.add(allMedia
          .where((element) => element.alias == uniqueKeys[i])
          .toList()[0]);
    }

    return returnAllMedia;
  }

  static String getImageUrl(String pathname) {
    return pathname + ".jpg";
  }

  static Map<int, List<Unit>> groupSlides(List<Unit> slides) {
    Map<int, List<Unit>> returnValue = {};
    for (int i = 0; i < slides.length; i++) {
      if (returnValue[int.parse(slides[i].name.substring(0, 1))] == null) {
        returnValue[int.parse(slides[i].name.substring(0, 1))] = [slides[i]];
      } else {
        returnValue[int.parse(slides[i].name.substring(0, 1))].add(slides[i]);
      }
    }
    return returnValue;
  }
}
