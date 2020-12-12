import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:sortedmap/sortedmap.dart';

class ClassScreen extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  ClassScreen({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: Subject.getData(
                          this.widget.arguments["classId"],
                        ),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<dynamic> snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Wrap(
                              children: [
                                Loader(),
                              ],
                            );
                          }
                          if (snapshot.hasError) {
                            return SizedBox();
                          }
                          if (snapshot.hasError) {
                            return Container();
                          }
                          List<Subject> subjects = snapshot.data["data"]
                              .map<Subject>((data) => Subject.fromJson(data))
                              .toList();
                          return Center(
                            child: Container(
                              width: 400.0,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Center(
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 250.0,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 45.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                              color: AppConstants.kBlueColor,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Text(
                                            "Class ${this.widget.arguments["classNumber"]}",
                                            style: TextStyle(
                                              color: AppConstants.kBlueColor,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  ...subjects.map<Widget>(
                                    (subject) {
                                      return GestureDetector(
                                        onTap: () {
                                          AppRoutes.nextScreen(
                                            context,
                                            AppRoutes.UNIT_SELECTION,
                                            arguments: {
                                              "classId": subject.id,
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                alignment: Alignment.center,
                                                width: 250.0,
                                                height: 50.0,
                                                margin:
                                                    EdgeInsets.only(bottom: 10.0),
                                                child: Text(
                                                  subject.title,
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppConstants.kBlueColor,
                                                  borderRadius:
                                                      BorderRadius.circular(16.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ).toList()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
