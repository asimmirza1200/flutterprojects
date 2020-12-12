import 'dart:convert';

import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/utils/toast.dart';

enum Languages { se, sm }

class Subject {
  final int id;
  final int programId;
  final String alias;
  final String title;
  final String description;
  final String image;
  final String publishedDate;

  Subject({
    this.publishedDate,
    this.id,
    this.alias,
    this.description,
    this.image,
    this.title,
    this.programId,
  });

  factory Subject.fromJson(Map json) {
    return Subject(
      id: json["id"],
      alias: json["alias"],
      description: json["description"],
      image: json["image"],
      programId: json["pid"],
      title: json["title"],
      publishedDate: json["publishedDate"],
    );
  }

  static Future<dynamic> getData(int classId, [String connection]) {
    try {
      var res = RequestHelper.getApi("/subject/$classId", queryParameters: {
        "connection": connection,
      });
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
    }
    return null;
  }
}
