import 'package:lesson_flutter/api/request_helper.dart';

class Video {
  final int id;
  final String name;
  final String description;
  final String image;
  final int access;
  final String url;
  final int mediaId;

  Video({
    this.id,
    this.mediaId,
    this.url,
    this.name,
    this.image,
    this.description,
    this.access,
  });

  factory Video.fromJson(Map json) {
    return Video(
      id: json["id"],
      mediaId: json["mediaId"],
      url: json["url"] != null && json["url"].isNotEmpty
          ? json["url"]
          : json["local"],
      name: json["name"],
      image: json["image"],
      description: json["description"],
      access: json["access"],
    );
  }

  static List getVideos(List allMedia) {
    return allMedia.where((element) => element.name.contains("Video")).toList();
  }

  static Future getVideosFromList(List allMedia, [String connection]) {
    return RequestHelper.getApi("/topic-media", queryParameters: {
      "type": "video",
      "connection": connection,
      "type_ids": getVideos(allMedia).map((e) => e.taskId).toList()
    });
  }
}
