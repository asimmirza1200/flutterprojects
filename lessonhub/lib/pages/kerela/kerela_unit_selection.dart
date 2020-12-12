import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:sortedmap/sortedmap.dart';

class KeralaUnitSelection extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  KeralaUnitSelection({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _KeralaUnitSelectionState createState() => _KeralaUnitSelectionState();
}

class _KeralaUnitSelectionState extends State<KeralaUnitSelection> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    "assets/unit-ic.png",
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Color.fromRGBO(255, 244, 244, 0.9),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Stack(
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
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 70.0,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: FutureBuilder(
                          future: Future(() async {
                            try {
                              String category =
                                  await SharedPrefs.getString("category");
                              return Subject.getData(
                                this.widget.arguments["classId"],
                                category,
                              );
                            } catch (e) {
                              doAlert(
                                  message: "Something went wrong",
                                  type: "danger");
                              return null;
                            }
                          }),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Loader(),
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return SizedBox();
                            }
                            if (snapshot.hasData) {
                              List<Subject> subjects =
                                  snapshot.data["data"].map<Subject>((data) {
                                return Subject.fromJson(data);
                              }).toList();

                              return ListView.builder(
                                itemCount: subjects.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      AppRoutes.nextScreen(
                                        context,
                                        AppRoutes.KERALA_COURSE_ACTIVITY,
                                        arguments: {
                                          "courseData": subjects[index]
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 65.0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF0a6194),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 5.0,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          // Container(
                                          //   width: 50.0,
                                          //   height: 50.0,
                                          //   alignment: Alignment.center,
                                          //   decoration: BoxDecoration(
                                          //     shape: BoxShape.circle,
                                          //     color: Colors.white,
                                          //   ),
                                          //   child: Text(
                                          //     "11",
                                          //     style: TextStyle(
                                          //       fontSize: 16.0,
                                          //       fontWeight: FontWeight.bold,
                                          //       color: Colors.black,
                                          //     ),
                                          //   ),
                                          // ),

                                          Expanded(
                                            child: Text(
                                              subjects[index].title,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            return SizedBox();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
