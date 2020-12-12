import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Subject.dart';
import 'package:lesson_flutter/providers/language_provider.dart';
import 'package:lesson_flutter/providers/subscription_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:provider/provider.dart';

class SubjectSelectionSub extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  SubjectSelectionSub({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _SubjectSelectionSubState createState() => _SubjectSelectionSubState();
}

class _SubjectSelectionSubState extends State<SubjectSelectionSub> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List routes = [
    AppRoutes.SUBJECT_SELECTION_ELEVEN,
    AppRoutes.SUBJECT_SELECTION_TWELVE
  ];
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

  Future bootClasses() async {
    try {
      var userSubRes = await SchoolClass.getUserSubscriptions("Paid");
      var subbedClasses = userSubRes["data"].map((data) {
        return data["courses"].toString();
      }).toList();
      Provider.of<SubscriptionProvider>(context, listen: false)
          .loadSubscribed(subbedClasses, "school");

      return true;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(),
      body: Stack(
        children: <Widget>[
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: kToolbarHeight - 30.0),
                width: MediaQuery.of(context).size.width,
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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: FutureBuilder(
                        future: bootClasses(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data == null) {
                            return SizedBox();
                          }
                          if (snapshot.hasData) {
                            return Column(
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
                                      color: AppConstants.kBlueColor,
                                    ),
                                  ),
                                  child: Text(
                                    "Choose Subject",
                                    style: TextStyle(
                                      color: AppConstants.kBlueColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                Container(
                                  width: 400.0,
                                  child: Column(
                                    children: this
                                        .widget
                                        .arguments["classes"]
                                        .map<Widget>(
                                      (SchoolClass subject) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (Provider.of<
                                                        SubscriptionProvider>(
                                                    context,
                                                    listen: false)
                                                .subscribed["school"]
                                                .contains(this
                                                    .widget
                                                    .arguments["classId"]
                                                    .toString())) {
                                              AppRoutes.nextScreen(
                                                context,
                                                AppRoutes.CLASS_SCREEN,
                                                arguments: {
                                                  "classId": this
                                                      .widget
                                                      .arguments["classId"],
                                                  "classNumber": this
                                                      .widget
                                                      .arguments["classNumber"],
                                                },
                                              );
                                            } else {
                                              AppRoutes.nextScreen(
                                                context,
                                                AppRoutes.PAYMENT_SCREEN,
                                                arguments: {
                                                  "courses": subject.id,
                                                  "classIndex": this
                                                          .widget
                                                          .arguments["class"] -
                                                      1
                                                },
                                              );
                                            }
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
                                                  margin: EdgeInsets.only(
                                                      bottom: 15.0),
                                                  child: Text(
                                                    subject.name
                                                        .split("-")
                                                        .last,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppConstants.kBlueColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
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
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
