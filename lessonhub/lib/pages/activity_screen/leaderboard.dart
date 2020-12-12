import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:sortedmap/sortedmap.dart';

class LeaderBoard extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  LeaderBoard({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Map _user = {};
  bool loading = true;
  @override
  void initState() {
    loadUserFromLocal();
    super.initState();
  }

  void loadUserFromLocal() async {
    String user = await SharedPrefs.getString("user");
    user = user ?? "{}";
    Map userMap = json.decode(user);

    setState(() {
      _user = userMap;
      loading = false;
    });
  }

  String getUserName(String name) {
    return name ?? _user["email"];
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
                margin: EdgeInsets.only(top: kToolbarHeight - 30.0),
                child: Row(
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
              Container(
                alignment: Alignment.topCenter,
                // padding: EdgeInsets.symmetric(
                //   horizontal: 25.0,
                //   vertical: 25.0,
                // ),
                child: FutureBuilder(
                    future: UnitTest.getLeaderboard(
                        this.widget.arguments["quizId"]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          loading) {
                        return Center(
                          child: Loader(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Container(
                          child: Text("No quiz was loaded"),
                        );
                      }
                      if (snapshot.hasData) {
                        List<UserRank> ranks =
                            snapshot.data["data"].map<UserRank>((data) {
                          return UserRank.fromJson(data);
                        }).toList();
                        return ListView.builder(
                          itemCount: ranks.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Stack(
                                overflow: Overflow.visible,
                                children: [
                                  Container(
                                    height: 100.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 15.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(
                                        color: Color(0xFF1f6bd1),
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        left: 50.0,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getUserName(
                                                      ranks[index].userName),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Color(0xFF1f6bd1),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      "${ranks[index].score}/${ranks[index].total}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF1f6bd1),
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Icon(
                                                      Icons.timer,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      "${ranks[index].endedAt - ranks[index].startedAt}s",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF1f6bd1),
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 60.0,
                                            width: 60.0,
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 15.0,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.yellow,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "₹10",
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: -30.0,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      height: 60.0,
                                      width: 60.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Color(0xFF1f6bd1),
                                          width: 3.0,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${index + 1}",
                                          style: TextStyle(
                                            color: Color(0xFF1f6bd1),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
