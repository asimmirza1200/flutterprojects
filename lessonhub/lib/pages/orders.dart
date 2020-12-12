import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/Order.dart';
import 'package:lesson_flutter/models/SchoolClass.dart';
import 'package:lesson_flutter/models/Unit.dart';
import 'package:lesson_flutter/models/UserRank.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:flutter/cupertino.dart';

class Orders extends StatefulWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  final Map arguments;
  Orders({
    this.themeColor,
    this.leftPatternColor,
    this.leftTextColor,
    this.arguments,
  });

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Future getPayments() async {
    var schoolPayments = await SchoolClass.getUserSubscriptions(null);
    var pscPayments = await SchoolClass.getUserSubscriptions(null, "mysql_psc");
    print(pscPayments);

    print(schoolPayments);
    var data = [
      ...schoolPayments["data"],
      ...pscPayments["data"],
    ];
    print("DATA");
    print(data);

    return data;
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
                child: Container(
                  alignment: Alignment.topCenter,
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 25.0,
                  //   vertical: 25.0,
                  // ),
                  child: FutureBuilder(
                      future: getPayments(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Loader(),
                          );
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error);
                          return Container(
                            child: Text("No orders was loaded"),
                          );
                        }
                        if (snapshot.hasData) {
                          List<Order> orders = snapshot.data.map<Order>((data) {
                            return Order.fromJson(data);
                          }).toList();

                          // List<UserRank> ranks =
                          //     snapshot.data["data"].map<UserRank>((data) {
                          //   return UserRank.fromJson(data);
                          // }).toList();
                          return ListView.builder(
                            itemCount: orders.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return orders[index].schoolClass == null
                                  ? GestureDetector(
                                      onTap: () {
                                        AppRoutes.nextScreen(
                                          context,
                                          AppRoutes.KERALA_CLASS_SELECTION,
                                          arguments: {
                                            "catid": orders[index].category.id
                                          },
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: [
                                            Container(
                                              height: 100.0,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 15.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                border: Border.all(
                                                  color: Color(0xFF1f6bd1),
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${orders[index].category.name.split("_").join(" ")}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF1f6bd1),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${orders[index].status.toUpperCase()}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF1f6bd1),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        if(orders[index].status.toUpperCase()!="PENDING"){
                                          AppRoutes.nextScreen(
                                            context,
                                            AppRoutes.CLASS_SCREEN,
                                            arguments: {
                                              "classId":
                                              orders[index].schoolClass.id,
                                              "classNumber": orders[index]
                                                  .schoolClass
                                                  .classNumber,
                                            },
                                          );
                                        }else{
                                          showAlertDialog(context);
                                        }

                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        child: Stack(
                                          overflow: Overflow.visible,
                                          children: [
                                            Container(
                                              height: 100.0,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 15.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                border: Border.all(
                                                  color: Color(0xFF1f6bd1),
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "${orders[index].schoolClass.name.split("-").join(" ")}",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF1f6bd1),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "${orders[index].status.toUpperCase()}",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF1f6bd1),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          );
                        }

                        return SizedBox();
                      }),
                ),
              ),
            ],
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
          content: Text( "Please Complete Your Payment First"),
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
