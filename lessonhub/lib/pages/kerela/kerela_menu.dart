import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/Category.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/providers/subscription_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:sortedmap/sortedmap.dart';

class KerelaMenu extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  KerelaMenu({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _KerelaMenuState createState() => _KerelaMenuState();
}

class _KerelaMenuState extends State<KerelaMenu> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Future getLoggedInState() async {
    var logged = await SharedPrefs.getBool("logged"+await SharedPrefs.getString("category", ""), false);

    if (logged) {
      String category = await SharedPrefs.getString("category", "mysql_psc");
      var userSubRes = await SchoolClass.getUserSubscriptions("Paid", category);
      var subbedClasses = userSubRes["data"].map((data) {
        return data["category"]["id"].toString();
      }).toList();
      Provider.of<SubscriptionProvider>(context, listen: false)
          .loadSubscribed(subbedClasses, "kerala");

      var data = await Category.getData("mysql_psc");
      return data;
    }
    SharedPrefs.setString("category", "kerala");
    Navigator.of(context).pushReplacementNamed(AppRoutes.LOGIN);

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<SubscriptionProvider>(context, listen: false)
        .subscribed["kerala"]);
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
            List<Category> categories =
                snapshot.data["data"].map<Category>((data) {
              return Category.fromJson(data);
            }).toList();
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              Navigator.canPop(context)
                                  ? Navigator.of(context).pop()
                                  : print("");
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 80.0),
                          Container(
                            height: 50.0,
                            width: 250.0,
                            margin: EdgeInsets.only(bottom: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                18.0,
                              ),
                              border: Border.all(
                                color: AppConstants.kBlueColor,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Choose your Eligibility",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: AppConstants.kBlueColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ...categories.map((data) {
                            return GestureDetector(
                              onTap: () {
                                if (Provider.of<SubscriptionProvider>(context,
                                        listen: false)
                                    .subscribed["kerala"]
                                    .contains(data.id.toString())) {
                                  AppRoutes.nextScreen(
                                    context,
                                    AppRoutes.KERALA_CLASS_SELECTION,
                                    arguments: {"catid": data.id},
                                  );
                                } else {
                                  print(data.id);
                                  AppRoutes.nextScreen(
                                    context,
                                    AppRoutes.KERALA_PAYMENT_SCREEN,
                                    arguments: {
                                      "category": data.id,
                                      "classIndex": 0
                                    },
                                  );
                                }
                              },
                              child: Container(
                                height: 50.0,
                                width: 250.0,
                                margin: EdgeInsets.only(bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    16.0,
                                  ),
                                  color: AppConstants.kBlueColor,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  StringUtils.capitalize(
                                    data.name.replaceAll("_", " "),
                                    allWords: true,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () {
                              AppRoutes.nextScreen(
                                  context, AppRoutes.KERALA_PLAY_ACTIVITY);
                            },
                            child: Container(
                              height: 50.0,
                              width: 250.0,
                              margin: EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                                color: AppConstants.kBlueColor,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Play & Earn",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
