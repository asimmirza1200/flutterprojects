import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';

class SubjectSelectionThree extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  SubjectSelectionThree({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _SubjectSelectionThreeState createState() => _SubjectSelectionThreeState();
}

class _SubjectSelectionThreeState extends State<SubjectSelectionThree> {
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30.0,
                      ),
                      Container(
                        width: 170.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 40.0,
                              top: 10.0,
                              child: Container(
                                alignment: Alignment(-0.5, 0),
                                color: Color(0xFFa44c64),
                                height: 80.0,
                                width: 190.0,
                                child: Text(
                                  "CLASS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "3",
                                      style: TextStyle(
                                        fontSize: 90.0,
                                        shadows: [
                                          Shadow(
                                            color: Color(0xFF9daeb1),
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFa44c64),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
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
                    ],
                  ),
                ),
                FutureBuilder(
                  future: Subject.getData(
                    this.widget.arguments["classId"],
                  ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<dynamic> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loader();
                    }
                    if (snapshot.hasError) {
                      return SizedBox();
                    }
                    List<Subject> subjects = snapshot.data["data"]
                        .map<Subject>((data) => Subject.fromJson(data))
                        .toList();

                    return Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 80.0),
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
                                  color: Color(
                                    0xFFd92b5a,
                                  ),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Container(
                              width: 400.0,
                              child: Column(
                                children: subjects.map<Widget>(
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
                                              width: 290.0,
                                              height: 90.0,
                                              child: Text(
                                                subject.title,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.fitWidth,
                                                  image: AssetImage(
                                                    "assets/class3bg1.png",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
