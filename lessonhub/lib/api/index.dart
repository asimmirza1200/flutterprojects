import 'package:lesson_flutter/models/Unit.dart';

class ApiHandler {
  static const String environment = "production";

  static const String BASE_URL = environment == "development_local"
      ? "http://1419ab9effca.ngrok.io/"
      : "http://13.234.240.2/lessonhub/";
  static const String MEDIA_BASE_URL = "http://13.234.240.2/";

  static const Map MEDIA_URLS = {
    "books": "media/documents/",
    "images": "images/stories/guru/media/",
    "videos": "media/videos/",
  };

  static String getMediaUrl(String pathName, String basePath, String type) {
    if (pathName != null) {
      return MEDIA_BASE_URL + type + "/" + MEDIA_URLS[basePath] + pathName;
    }

    return "";
  }

  static String getClassFigure(String className) {
    Map values = {"tenth": "10th"};

    return values[className];
  }

  static String getKeralaUrl(Unit unit) {
    return "psc_${getClassFigure(unit.schoolClass.alias.split("-")[0])}_${unit.schoolClass.name}";
  }
}
