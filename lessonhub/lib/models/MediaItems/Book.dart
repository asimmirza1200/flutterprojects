import 'package:lesson_flutter/api/request_helper.dart';

class Book {
  final int id;
  final String name;
  final String description;
  final String image;
  final int access;
  final String url;
  final String local;
  final int mediaId;

  Book({
    this.id,
    this.mediaId,
    this.url,
    this.name,
    this.image,
    this.local,
    this.description,
    this.access,
  });

  factory Book.fromJson(Map json) {
    return Book(
      id: json["id"],
      mediaId: json["mediaId"],
      url: json["url"],
      name: json["name"],
      local: json["local"],
      image: json["image"],
      description: json["description"],
      access: json["access"],
    );
  }

  static List getBooks(List allMedia) {
    return allMedia
        .where((element) => element.name.contains("Text Book"))
        .toList();
  }

  static Future getBooksFromList(List allMedia) {
    return RequestHelper.getApi("/topic-media", queryParameters: {
      "type": "docs",
      "type_ids": getBooks(allMedia).map((e) => e.taskId).toList()
    });
  }
}
