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

class KeralaClassSelection extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  KeralaClassSelection({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _KeralaClassSelectionState createState() => _KeralaClassSelectionState();
}

class _KeralaClassSelectionState extends State<KeralaClassSelection> {
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
      // String category = await SharedPrefs.getString("category", "mysql_psc");
      // var userSubRes = await SchoolClass.getUserSubscriptions("Paid", category);
      // var subbedClasses = userSubRes["data"].map((data) {
      //   return data["courses"].toString();
      // }).toList();
      // Provider.of<SubscriptionProvider>(context, listen: false)
      //     .loadSubscribed(subbedClasses, "kerala");
      return SchoolClass.getData(this.widget.arguments["catid"], category);
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
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
                      child: FutureBuilder(
                        future: bootClasses(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
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
                            List<SchoolClass> _schoolClasses =
                                snapshot.data["data"].map<SchoolClass>((data) {
                              return SchoolClass.fromJson(data);
                            }).toList();
                            // List<SchoolClass> schoolClasses = snapshot.data["data"]
                            return Container(
                              constraints: BoxConstraints(
                                maxWidth: 300.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50.0,
                                          width: 250.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              18.0,
                                            ),
                                            border: Border.all(
                                              color: AppConstants.kBlueColor,
                                              width: 2.0,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Choose your Class",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppConstants.kBlueColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 250.0,
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: _schoolClasses
                                                  .map((schoolClass) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    AppRoutes.nextScreen(
                                                      context,
                                                      AppRoutes
                                                          .KERALA_UNIT_SELECTION,
                                                      arguments: {
                                                        "classId":
                                                            schoolClass.id,
                                                      },
                                                    );
                                                    // } else {
                                                    //   AppRoutes.nextScreen(
                                                    //     context,
                                                    //     AppRoutes
                                                    //         .PAYMENT_SCREEN,
                                                    //     arguments: {
                                                    //       "courses":
                                                    //           schoolClass.id,
                                                    //       "classIndex": 0
                                                    //     },
                                                    //   );
                                                    // }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                      bottom: 15.0,
                                                    ),
                                                    height: 55.0,
                                                    decoration: BoxDecoration(
                                                      color: AppConstants
                                                          .kBlueColor,
                                                      border: Border.all(
                                                        color: AppConstants
                                                            .kBlueColor,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        18.0,
                                                      ),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      schoolClass.name,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
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
    );
  }
}
