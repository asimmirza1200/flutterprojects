import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';

class SubjectSelectionEleven extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  SubjectSelectionEleven({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _SubjectSelectionElevenState createState() => _SubjectSelectionElevenState();
}

class _SubjectSelectionElevenState extends State<SubjectSelectionEleven> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
            bottom: 0.0,
            right: 0.0,
            child: Image.asset(
              "assets/green-bottom-pattern.png",
              width: 250.0,
            ),
          ),
          Positioned(
            top: -30.0,
            left: -70.0,
            child: Container(
              width: 230.0,
              height: 230.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: this.widget.leftPatternColor,
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
                        text: "11 \n",
                        style: TextStyle(
                          fontSize: 70.0,
                          fontWeight: FontWeight.w900,
                          color: this.widget.leftTextColor,
                        ),
                      ),
                      TextSpan(
                        text: "CLASS",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: this.widget.leftTextColor,
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
              mainAxisSize: MainAxisSize.min,
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
                Expanded(
                  child: SingleChildScrollView(
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
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 70.0,
                            ),
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
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Flexible(
                              child: Container(
                                width: 250.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: subjects.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        AppRoutes.nextScreen(
                                          context,
                                          AppRoutes.UNIT_SELECTION,
                                          arguments: {
                                            "classId": subjects[index].id,
                                          },
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        width: 200.0,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: this.widget.themeColor,
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                        child: Text(
                                          subjects[index].title,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
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
