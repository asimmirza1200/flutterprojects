import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/utils/toast.dart';

class Category {
  final int id;
  final String name;
  final String alias;
  final String description;
  final String image;

  Category({this.alias, this.name, this.id, this.description, this.image});

  factory Category.fromJson(Map json) {
    return Category(
      id: json["id"],
      name: json["name"],
      alias: json["alias"],
      description: json["description"],
      image: json["image"],
    );
  }

  static Future<dynamic> getData([String connection]) {
    try {
      var res = RequestHelper.getApi("/category",
          queryParameters: {"connection": connection});
      return res;
    } catch (e) {
      doAlert(message: "Something went wrong");
    }
    return null;
  }
}
