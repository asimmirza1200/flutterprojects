import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';

class SubjectSelectionEight extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  SubjectSelectionEight({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _SubjectSelectionEightState createState() => _SubjectSelectionEightState();
}

class _SubjectSelectionEightState extends State<SubjectSelectionEight> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  double getMarginLeft(index) {
    switch (index) {
      case 0:
        return 70.0;
      case 1:
        return 140.0;
      case 2:
        return 130.0;
      case 3:
        return 120.0;
      case 4:
        return 70.0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Positioned(
            right: -100.0,
            top: 120.0,
            child: Container(
              width: 180.0,
              height: 180.0,
              decoration: BoxDecoration(
                color: Color(0xFFf7eee1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Image.asset(
              "assets/class6-top.png",
              width: 400.0,
            ),
          ),
          Positioned(
            right: -70.0,
            bottom: 50.0,
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Color(0xFCF6E6F0),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150.0,
            right: -230.0,
            child: Transform.rotate(
              angle: -0.2,
              child: Image.asset(
                "assets/bottom_selection.png",
                width: 400.0,
              ),
            ),
          ),
          Positioned(
            left: -70.0,
            top: 90.0,
            bottom: 0.0,
            child: Container(
              width: 240.0,
              height: 240.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.leftPatternColor,
                border: Border.all(
                  color: Color(0xFFf7f9f7),
                  width: 20.0,
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "8 \n",
                        style: TextStyle(
                          fontSize: 70.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "CLASS",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
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
                Container(
                  height: MediaQuery.of(context).size.height - 150.0,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 50.0,
                    ),
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
                          return Loader();
                        }
                        if (snapshot.hasError) {
                          return SizedBox();
                        }
                        List<Subject> subjects = snapshot.data["data"]
                            .map<Subject>((data) => Subject.fromJson(data))
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 35.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                              child: Text(
                                "Choose Subject",
                                style: TextStyle(
                                  color: widget.leftTextColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: subjects.map(
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
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                            bottom: 20.0,
                                            left: 130.0,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFffc8b8),
                                            borderRadius: BorderRadius.circular(
                                              30.0,
                                            ),
                                          ),
                                          child: Text(
                                            subject.title,
                                            style: TextStyle(
                                              color: Color(0xFF772904),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
