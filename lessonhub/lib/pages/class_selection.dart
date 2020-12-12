import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Subject.dart' hide Languages;
import 'package:lesson_flutter/pages/login_screen.dart';
import 'package:lesson_flutter/providers/language_provider.dart';
import 'package:lesson_flutter/providers/subscription_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class ClassSelection extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  ClassSelection({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _ClassSelectionState createState() => _ClassSelectionState();
}

class _ClassSelectionState extends State<ClassSelection> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String category = "";
  bool loading = true;
  @override
  void initState() {
    getCategory();
    super.initState();
  }

  void getCategory() async {
    var _category = await SharedPrefs.getString("category", "");
    Provider.of<LanguageProvider>(context, listen: false).loadLanguage();
    setState(() {
      category = _category;
      loading = false;
    });
  }

  List addedClasses = [];

  Future bootClasses() async {
    try {
      var userSubRes = await SchoolClass.getUserSubscriptions("Paid");
      var subbedClasses = userSubRes["data"].map((data) {
        return data["courses"].toString();
      }).toList();
      Provider.of<SubscriptionProvider>(context, listen: false)
          .loadSubscribed(subbedClasses, "school");
      return SchoolClass.getData(
        this.widget.arguments["catid"],
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          loading
              ? Loader()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: kToolbarHeight - 30.0),
                        width: MediaQuery.of(context).size.width,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height - 74.0,
                            child: FutureBuilder(
                              future: bootClasses(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
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
                                  List<SchoolClass> _schoolClasses = [];
                                  List<SchoolClass> schoolClasses = snapshot
                                      .data["data"]
                                      .map<SchoolClass>((data) {
                                    return SchoolClass.fromJson(data);
                                  }).toList();

                                  schoolClasses.sort((a, b) {
                                    return a.classNumber - b.classNumber;
                                  });
                                  for (int i = 0;
                                      i < schoolClasses.length;
                                      i++) {
                                    if (_schoolClasses
                                            .where((element) =>
                                                element.classNumber ==
                                                schoolClasses[i].classNumber)
                                            // ignore: missing_return
                                            .length ==
                                        0) {
                                      _schoolClasses.add(schoolClasses[i]);
                                    }
                                  }

                                  // ignore: missing_return
                                  // List<SchoolClass> schoolClasses = snapshot.data["data"]
                                  return Container(
                                    constraints: BoxConstraints(
                                      maxWidth: 300.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 45.0,
                                                width: 220.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    16,
                                                  ),
                                                  color:
                                                      AppConstants.kBlueColor,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Choose your Class",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.7,
                                                  child: GridView.count(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    crossAxisCount: 2,
                                                    shrinkWrap: true,
                                                    crossAxisSpacing: 15.0,
                                                    mainAxisSpacing: 15.0,
                                                    childAspectRatio: 2.5,
                                                    children: _schoolClasses
                                                        .where((SchoolClass
                                                                element) =>
                                                            ![
                                                              "",
                                                            ].contains(element
                                                                .alias
                                                                .replaceAll(
                                                                    RegExp(
                                                                        '[^0-9]'),
                                                                    '')) &&
                                                            element.classNumber <=
                                                                12)
                                                        .map((schoolClass) {
                                                      int idx = schoolClasses
                                                          .indexOf(schoolClass);
                                                      int classIndex =
                                                          schoolClass
                                                              .classNumber;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if (classIndex > 10) {
                                                            // AppRoutes.nextScreen(
                                                            //     context,
                                                            //     AppRoutes
                                                            //         .SUBJECT_SELECTION_SUB,
                                                            //     arguments: {
                                                            //       "classes":
                                                            //           schoolClasses
                                                            //               .where(
                                                            //         (element) =>
                                                            //             element
                                                            //                 .classNumber ==
                                                            //             classIndex,
                                                            //       ),
                                                            //       "class":
                                                            //           classIndex,
                                                            //       "classId":
                                                            //           schoolClass
                                                            //               .id,
                                                            //       "classNumber":
                                                            //           schoolClass
                                                            //               .classNumber,
                                                            //     });
                                                            showAlertDialog(context);
                                                          } else if (Provider
                                                                  .of<SubscriptionProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .subscribed[
                                                                  "school"]
                                                              .contains(schoolClass
                                                                  .id
                                                                  .toString())) {
                                                            // AppRoutes.nextScreen(
                                                            //   context,
                                                            //   AppRoutes.classRoutes[
                                                            //       classIndex - 1],
                                                            //   arguments: {
                                                            //     "classId":
                                                            //         schoolClass.id
                                                            //   },
                                                            // );
                                                            AppRoutes
                                                                .nextScreen(
                                                              context,
                                                              AppRoutes
                                                                  .CLASS_SCREEN,
                                                              arguments: {
                                                                "classId":
                                                                    schoolClass
                                                                        .id,
                                                                "classNumber":
                                                                    schoolClass
                                                                        .classNumber,
                                                              },
                                                            );
                                                          } else {
                                                            AppRoutes
                                                                .nextScreen(
                                                              context,
                                                              AppRoutes
                                                                  .PAYMENT_SCREEN,
                                                              arguments: {
                                                                "courses":
                                                                    schoolClass
                                                                        .id,
                                                                "classIndex":
                                                                    classIndex -
                                                                        1
                                                              },
                                                            );
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: AppConstants
                                                                  .kBlueColor,
                                                              width: 2.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              35.0,
                                                            ),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "$classIndex",
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              color: AppConstants
                                                                  .kBlueColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
  void showAlertDialog(BuildContext context) {

    showDialog(
        context: context,
        child:  CupertinoAlertDialog(
          title: Text("Alert!"),
          content: Text( "Coming Soon"),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("OK")
            ),

          ],
        ));
  }
}
