import 'package:flutter/material.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/pages/activity_screen/book_activity.dart';
import 'package:lesson_flutter/pages/activity_screen/play_activity.dart';
import 'package:lesson_flutter/pages/activity_screen/quiz_activity.dart';
import 'package:lesson_flutter/pages/activity_screen/video_activity.dart';
import 'package:lesson_flutter/pages/kerela/kerala_quiz_activity.dart';
import 'package:lesson_flutter/pages/kerela/kerela_slide_activity.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/services/auth_service.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';

class KeralaCourseActivity extends StatefulWidget {
  final Map arguments;

  KeralaCourseActivity({this.arguments});
  @override
  _KeralaCourseActivityState createState() => _KeralaCourseActivityState();
}

class _KeralaCourseActivityState extends State<KeralaCourseActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String activeScreen = "slide";
  bool loading = true;
  List units = [];
  @override
  void initState() {
    requeryUnits();
    super.initState();
  }

  void requeryUnits() async {
    if (this.widget.arguments["courseData"] != null) {
      String connection = await SharedPrefs.getString("category", "mysql_psc");
      var res = await Unit.getData(
        this.widget.arguments["courseData"].id,
        connection,
      );
      units = res["data"].map<Unit>((data) {
        return Unit.fromJson(data);
      }).toList();

      // units = units
      //     .where((element) =>
      //         element.unit.toString() ==
      //         this.widget.arguments["class"].unit.toString())
      //     .toList();
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Widget getActiveScreen(String activeScreen) {
    switch (activeScreen) {
      case "slide":
        return KerelaSlideActivity(
          slides: units,
        );
      case "video":
        return VideoActivity(
          videos: units,
        );

      case "quiz":
        return KeralaQuizActivity(
          quizzes: units,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (!loading) {
    //   title = unitNameToTitle(this.widget.arguments["courseData"] == null
    //       ? units[0].name
    //       : this.widget.arguments["courseData"][0].name);
    // }
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    activeScreen = "slide";
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Text(
                    "Slide",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      color: activeScreen == "slide"
                          ? AppConstants.kBlueColor
                          : Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppConstants.kBlueColor),
                    color: activeScreen == "slide"
                        ? Colors.white
                        : AppConstants.kBlueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    activeScreen = "video";
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Text(
                    "Video",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      color:
                          activeScreen == "video" ? Colors.black : Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: activeScreen == "video"
                        ? Colors.white
                        : AppConstants.kBlueColor,
                    border: Border.all(color: AppConstants.kBlueColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    activeScreen = "quiz";
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  child: Text(
                    "Quiz",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0,
                      color:
                          activeScreen == "quiz" ? Colors.black : Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: activeScreen == "quiz"
                        ? Colors.white
                        : AppConstants.kBlueColor,
                    border: Border.all(
                      color: AppConstants.kBlueColor,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/bg-full.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Image.asset(
              "assets/blue-top-pattern.png",
              width: 350.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: kToolbarHeight - 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Spacer(),
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 30.0,
                      color: AppConstants.blackColor,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
                ),
              ],
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin: EdgeInsets.only(top: 100.0),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Expanded(
                        child: getActiveScreen(
                          activeScreen,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
