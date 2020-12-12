class Setting {
  static final Setting _instance = Setting._internal();

  // DEFAULT SETTING
  static int requestItemPerPage = 10;
  static String blogUrl = "http://indriyo.in/blog/all";

  factory Setting() {
    return _instance;
  }

  Setting._internal() {
     // Init properties here
  }

}