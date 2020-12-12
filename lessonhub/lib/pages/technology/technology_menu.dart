import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/pages/login_screen.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortedmap/sortedmap.dart';

class TechnologyMenu extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  TechnologyMenu({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _TechnologyMenuState createState() => _TechnologyMenuState();
}

class _TechnologyMenuState extends State<TechnologyMenu> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future getLoggedInState() async {
    var logged = await SharedPrefs.getBool("logged"+await SharedPrefs.getString("category", ""), false);

    if (logged) {
      return true;
    }
    SharedPrefs.setString("category", "upsc");
    Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: FutureBuilder(
          future: getLoggedInState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Stack(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...["System Engineering", "Software Engineering"]
                                .map((data) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 60.0,
                                  width: 300.0,
                                  margin: EdgeInsets.only(bottom: 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      35.0,
                                    ),
                                    color: AppConstants.kBlueColor,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    data,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }).toList()
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              );
            }

            return SizedBox();
          }),
    );
  }
}
