import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/QuizQuestion.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:sortedmap/sortedmap.dart';

class KeralaPlayActivity extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  KeralaPlayActivity({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _KeralaPlayActivityState createState() => _KeralaPlayActivityState();
}

class _KeralaPlayActivityState extends State<KeralaPlayActivity> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future getGroupedQuizzes() async {
    String category = await SharedPrefs.getString("category", "mysql_psc");
    return UnitTest.getGroupedUnitTestQuestions("grouped-unit-test", category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
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
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Image.asset(
              "assets/blue-bottom-pattern.png",
              width: 200.0,
              fit: BoxFit.fitWidth,
            ),
          ),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: kToolbarHeight - 40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
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
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 25.0,
                  //   vertical: 25.0,
                  // ),
                  child: FutureBuilder(
                      future: getGroupedQuizzes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Loader(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Container(
                            child: Text("Nothing to display"),
                          );
                        }
                        if (snapshot.hasData) {
                          print("DATA");
                          print(snapshot.data["data"]);
                          List<QuizQuestion> displayUnitTest =
                              snapshot.data["data"].map<QuizQuestion>((json) {
                            return QuizQuestion.fromJson(json);
                          }).toList();
                          return ListView.builder(
                            itemCount: displayUnitTest.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  AppRoutes.nextScreen(
                                    context,
                                    AppRoutes.KERALA_PLAY_SCREEN,
                                    arguments: {
                                      "questions": displayUnitTest[index],
                                      "type": "unit_test",
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 20.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      28.0,
                                    ),
                                    child: Image.network(
                                      ApiHandler.getMediaUrl(
                                        displayUnitTest[index].name + ".jpg",
                                        "images",
                                        "kerala_psc",
                                      ),
                                      fit: BoxFit.fill,
                                      loadingBuilder: (BuildContext context,
                                          Widget child, ImageChunkEvent event) {
                                        if (event == null) {
                                          return child;
                                        }
                                        return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: AppConstants.kBlueColor),
                                            borderRadius: BorderRadius.circular(
                                              28.0,
                                            ),
                                          ),
                                          child: Wrap(
                                            children: [
                                              Image.asset(
                                                "assets/playstore.png",
                                                width: 120.0,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  height: 400.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                              );
                            },
                          );
                        }

                        return SizedBox();
                      }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
