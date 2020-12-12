import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:sortedmap/sortedmap.dart';

class OfflinePayment extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  OfflinePayment({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _OfflinePaymentState createState() => _OfflinePaymentState();
}

class _OfflinePaymentState extends State<OfflinePayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _checkingOut = false;

  checkoutUser(
      {double amount, String currency, String courses, String category}) async {
    try {
      setState(() {
        _checkingOut = true;
      });
      String connection = await SharedPrefs.getString("category", "mysql_psc");
      var res = await RequestHelper.postApi("/user-payments", {
        "amount": amount.toString(),
        "currency": currency.toString(),
        "courses": courses,
        "category": category,
        "connection": connection
      });
      setState(() {
        _checkingOut = false;
      });

      return res;
    } catch (e) {
      print(e.response.data);
      setState(() {
        _checkingOut = false;
      });
      return {"success": false};
    }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Offline Payment",
                        style: TextStyle(
                          color: Color(0xFF1f6bd1),
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xFF1f6bd1),
                          ),
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        onPressed: () {
                          AppRoutes.nextScreen(
                            context,
                            AppRoutes.OFFLINE_PAYMENT,
                          );
                        },
                        child: Text(
                          "₹ ${this.widget.arguments["price"] ?? 0}",
                          style: TextStyle(
                            color: Color(0xFF1f6bd1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Make your payment to lessonhub executive. Kindly wait for approval from team lessonhub after checkout.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1f6bd1),
                          height: 1.5,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: FlatButton(
                        color: Color(0xFF1f6bd1),
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            18.0,
                          ),
                        ),
                        onPressed: () async {
                          var res = await checkoutUser(
                            amount: this.widget.arguments["price"],
                            currency: "INR",
                            courses:
                                this.widget.arguments["courses"].toString(),
                            category:
                                this.widget.arguments["category"].toString(),
                          );
                          if (res["success"]) {
                            AppRoutes.nextScreen(context, AppRoutes.MY_ORDERS);
                          } else {
                            doAlert(
                              message:
                                  "Error while making payment, try again later",
                              type: "danger",
                            );
                          }
                        },
                        child: _checkingOut
                            ? Container(
                                width: 20.0,
                                height: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Checkout",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
