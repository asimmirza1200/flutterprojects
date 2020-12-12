// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:lesson_flutter/models/User.dart';
// import 'package:lesson_flutter/utils/shared_prefs.dart';

// class Profile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: FutureBuilder(
//             future: SharedPrefs.getString("user"),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               AppUser au = AppUser.fromJson(json.decode(snapshot.data));
//               return Column(
//                 children: [
//                   Container(
//                     height: 450.0,
//                     color: Colors.blue,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Form(
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 hintText: "Full Name",
//                               ),
//                               initialValue: au.name,
//                             ),
//                             SizedBox(
//                               height: 25.0,
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 hintText: "Phone",
//                               ),
//                               initialValue: au.username,
//                             ),
//                             SizedBox(
//                               height: 25.0,
//                             ),
//                             TextFormField(
//                               decoration: InputDecoration(
//                                 hintText: "Email Address",
//                               ),
//                               initialValue: au.email,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             }),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/User.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:lesson_flutter/widgets/text_field_container.dart';
import 'package:sortedmap/sortedmap.dart';

class Profile extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  Profile({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
                margin: EdgeInsets.only(top: kToolbarHeight - 40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: FutureBuilder(
                        future: SharedPrefs.getString("user"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          AppUser au =
                              AppUser.fromJson(json.decode(snapshot.data));
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Form(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: AssetImage(
                                            "assets/playstore.png",
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        TextFieldContainer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Full Name",
                                              border: InputBorder.none,
                                            ),
                                            initialValue: au.name,
                                          ),
                                        ),
                                        TextFieldContainer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Phone",
                                              border: InputBorder.none,
                                            ),
                                            initialValue: au.username,
                                          ),
                                        ),
                                        TextFieldContainer(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Email Address",
                                              border: InputBorder.none,
                                            ),
                                            initialValue: au.email,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
