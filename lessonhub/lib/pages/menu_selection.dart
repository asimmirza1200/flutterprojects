import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuSelection extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  MenuSelection({this.themeColor, this.leftPatternColor, this.leftTextColor});

  @override
  _MenuSelectionState createState() => _MenuSelectionState();
}

class _MenuSelectionState extends State<MenuSelection> {
  bool logged = false;
  bool loading = true;
  @override
  void initState() {
    setFirstVisit();
    super.initState();
  }

  void setFirstVisit() async {
    bool openedBefore = await SharedPrefs.getBool("first_visit", false);
    bool _logged = await SharedPrefs.getBool("loggedmysql_school", false);
    if (!openedBefore) {
      SharedPrefs.setBool("opened_before", true);
    }
    setState(() {
      logged = _logged;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/category_bg.png"),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          40.0,
                        ),
                        topRight: Radius.circular(
                          40.0,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10.0),
                                    constraints:
                                        BoxConstraints(maxHeight: 150.0),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            40.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0x70000000,
                                          ),
                                          blurRadius: 13,
                                        )
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        SharedPrefs.setString(
                                            "category", "mysql_school");
                                        Provider.of<SignInProvider>(context,
                                                listen: false)
                                            .category = "mysql_school";
                                        AppRoutes.nextScreen(
                                          context,
                                          logged
                                              ? AppRoutes.CHOOSE_LANGUAGE
                                              : AppRoutes.LOGIN,
                                        );
                                      },
                                      child: FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/schoolb.png",
                                              height: 90.0,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              "SCHOOL",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxHeight: 150.0),
                                    padding: EdgeInsets.all(10.0),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            40.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0x70000000,
                                          ),
                                          blurRadius: 13,
                                        )
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        SharedPrefs.setString(
                                            "category", "mysql_psc");
                                        Provider.of<SignInProvider>(context,
                                                listen: false)
                                            .category = "mysql_psc";
                                        AppRoutes.nextScreen(
                                          context,
                                          AppRoutes.KERELA_MENU,
                                        );
                                        // showAlertDialog(context);
                                      },
                                      child: FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/keralab.png",
                                              height: 90.0,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              "KERALA\nPSC",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(24.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    constraints:
                                        BoxConstraints(maxHeight: 150.0),
                                    padding: EdgeInsets.all(10.0),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            40.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0x70000000,
                                          ),
                                          blurRadius: 13,
                                        )
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        SharedPrefs.setString(
                                            "category", "upsc");
                                        Provider.of<SignInProvider>(context,
                                                listen: false)
                                            .category = "upsc";
                                        AppRoutes.nextScreen(
                                          context,
                                          AppRoutes.UPSC_MENU,
                                        );
                                        // showAlertDialog(context);

                                      },
                                      child: FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/upscb.png",
                                              height: 90.0,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              "UPSC",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    constraints:
                                        BoxConstraints(maxHeight: 150.0),
                                    padding: EdgeInsets.all(10.0),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            40.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      color: const Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0x70000000,
                                          ),
                                          blurRadius: 13,
                                        )
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        SharedPrefs.setString(
                                            "category", "technology");
                                        Provider.of<SignInProvider>(context,
                                                listen: false)
                                            .category = "technology";
                                        AppRoutes.nextScreen(
                                          context,
                                          AppRoutes.TECHNOLOGY_MENU,
                                        );
                                        // showAlertDialog(context);

                                      },
                                      child: FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              "assets/engineeringb.png",
                                              height: 90.0,
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              "TECHNOLOGY",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ), // Adobe XD layer: 'Ellipse 6' (shape)
              ],
            ),
    );
    // return Scaffold(
    //   body: Stack(
    //     children: <Widget>[
    //       Positioned(
    //         right: -40.0,
    //         top: 100.0,
    //         child: Container(
    //           width: 150.0,
    //           height: 150.0,
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             color: Color(0xFFfbe9fa),
    //           ),
    //         ),
    //       ),
    //       SafeArea(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Container(
    //               alignment: Alignment.centerRight,
    //               child: IconButton(
    //                 icon: Icon(
    //                   Icons.menu,
    //                   size: 30.0,
    //                   color: AppConstants.blackColor,
    //                 ),
    //                 onPressed: () {},
    //               ),
    //             ),
    //             Expanded(
    //               child: Container(
    //                 width: MediaQuery.of(context).size.width * 0.7,
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: <Widget>[
    //                         Menu(),
    //                         Menu(),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: 50.0,
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: <Widget>[
    //                         Menu(),
    //                         Menu(),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
