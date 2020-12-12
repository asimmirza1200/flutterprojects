import 'dart:convert';

import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/utils/toast.dart';

enum UnitTypes { dtask }

class Unit {
  final String name;
  final int id;
  final int taskId;
  final String alias;
  final String description;
  final String image;
  final String duration;
  final int ordering;
  final int published;
  final String difficulty;
  final Subject subject;
  final int points;
  final int unit;
  final SchoolClass schoolClass;
  final int mediaId;

  Unit({
    this.name,
    this.id,
    this.taskId,
    this.alias,
    this.subject,
    this.description,
    this.image,
    this.duration,
    this.ordering,
    this.published,
    this.difficulty,
    this.points,
    this.unit,
    this.schoolClass,
    this.mediaId,
  });

  factory Unit.fromJson(Map json) {
    var nameSplit = json["task"]["name"].split("-");
    return Unit(
      name: json["task"]["name"],
      id: json["id"],
      taskId: json["task"]["id"],
      alias: json["task"]["alias"],
      subject: Subject.fromJson(json["subject"]),
      description: json["task"]["description"],
      image: json["task"]["image"],
      duration: json["task"]["duration"],
      ordering: json["task"]["ordering"],
      published: json["task"]["published"],
      difficulty: json["task"]["difficultylevel"],
      points: json["task"]["points"],
      mediaId: json["media_id"],
      unit: nameSplit.length > 1 &&
              RegExp(r"^[0-9]+$").hasMatch(nameSplit[0].trim())
          ? int.parse(nameSplit[0])
          : 0,
      schoolClass: SchoolClass.fromJson(json["subject"]["class"]),
    );
  }

  static String getUnitName(List unitObjects) {
    return unitObjects[0].name.split("-")[1].trim();
  }

  static Future<dynamic> getData(int topicId, [String connection]) {
    try {
      var res = RequestHelper.getApi(
        "/topic/$topicId",
        queryParameters: {
          "connection": connection,
        },
      );
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
      return null;
    }
  }
}
