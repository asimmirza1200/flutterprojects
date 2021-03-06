import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/Category.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/providers/language_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:sortedmap/sortedmap.dart';

class ChooseLanguage extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  ChooseLanguage({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool logged = false;
  bool loading = true;

  @override
  void initState() {
    getLoggedState();
    super.initState();
  }

  void getLoggedState() async {
    var _logged = await SharedPrefs.getBool("logged"+await SharedPrefs.getString("category", ""), false);
    setState(() {
      loading = false;
      logged = _logged;
    });
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
                child: Container(
                  alignment: Alignment.topCenter,
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 25.0,
                  //   vertical: 25.0,
                  // ),
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : FutureBuilder(
                          future: Category.getData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasData) {
                              print(snapshot.data);
                              List<Category> categories =
                                  snapshot.data["data"].map<Category>((data) {
                                return Category.fromJson(data);
                              }).toList();
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ...categories.map((category) {
                                            return GestureDetector(
                                              onTap: () {
                                                SharedPrefs.setString(
                                                    "language",
                                                    category.alias == "english"
                                                        ? "en"
                                                        : "sm");
                                                Provider.of<LanguageProvider>(
                                                            context,
                                                            listen: false)
                                                        .selectedLanguage =
                                                    category.alias == "english"
                                                        ? "en"
                                                        : "sm";
                                                AppRoutes.nextScreen(
                                                  context,
                                                  logged
                                                      ? AppRoutes
                                                          .CLASS_SELECTION
                                                      : AppRoutes.LOGIN,
                                                  arguments: {
                                                    "catid": category.id
                                                  },
                                                );
                                              },
                                              child: Container(
                                                height: 60.0,
                                                width: 300.0,
                                                margin: EdgeInsets.only(
                                                  bottom: 10.0,
                                                ),
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
                                                  category.name
                                                      .replaceAll("_", " "),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            );
                                          })

                                          // GestureDetector(
                                          //   onTap: () {
                                          //     SharedPrefs.setString(
                                          //         "language", "se");
                                          //     Provider.of<LanguageProvider>(
                                          //             context,
                                          //             listen: false)
                                          //         .selectedLanguage = "se";

                                          //     AppRoutes.nextScreen(
                                          //       context,
                                          //       logged
                                          //           ? AppRoutes.CLASS_SELECTION
                                          //           : AppRoutes.LOGIN,
                                          //     );
                                          //   },
                                          //   child: Container(
                                          //     height: 60.0,
                                          //     width: 300.0,
                                          //     alignment: Alignment.center,
                                          //     child: Text(
                                          //       "English Medium",
                                          //       textAlign: TextAlign.center,
                                          //       style: TextStyle(
                                          //         fontSize: 24.0,
                                          //         fontWeight: FontWeight.w900,
                                          //         color: Colors.white,
                                          //       ),
                                          //     ),
                                          //     decoration: BoxDecoration(
                                          //       borderRadius:
                                          //           BorderRadius.circular(
                                          //         35.0,
                                          //       ),
                                          //       color: AppConstants.kBlueColor,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
