import 'dart:convert';

import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/utils/toast.dart';

enum Languages { se, sm }

class SchoolClass {
  final int id;
  final String alias;
  final String description;
  final String image;
  final int categoryId;
  final String name;
  final int classNumber;
  final String language;

  SchoolClass({
    this.id,
    this.alias,
    this.description,
    this.image,
    this.categoryId,
    this.name,
    this.classNumber,
    this.language,
  });

  factory SchoolClass.fromJson(Map json) {
    String aliasReplaced = json["alias"].replaceAll(RegExp('[^0-9]'), '');
    return SchoolClass(
      id: json["id"],
      alias: json["alias"],
      description: json["description"],
      image: json["image"],
      categoryId: json["catid"],
      name: json["name"],
      language: json["alias"]
          .replaceAll("clas", "")
          .replaceAll(RegExp("\-[0-9]+"), ""),
      classNumber: int.parse(aliasReplaced == "" ? '0' : aliasReplaced),
    );
  }

  static Future<dynamic> getData(int catid, [String connection]) {
    // String lang = language == Languages.se ? "se" : "sm";
    try {
      var res = RequestHelper.getApi("/class",
          queryParameters: {"connection": connection, "catid": catid});
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
    }
    return null;
  }

  static Future<dynamic> getUserSubscriptions(String status,
      [String connection]) {
    try {
      var res = RequestHelper.getApi(
        "/user-payments?${status != null ? 'status=$status' : ''}",
        queryParameters: {
          "connection": connection,
        },
      );
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
    }
    return null;
  }
}
