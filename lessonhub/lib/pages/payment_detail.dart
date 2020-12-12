import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/models/MediaGroup.dart';
import 'package:lesson_flutter/models/MediaItems/Quiz.dart';
import 'package:lesson_flutter/models/MediaItems/UnitTest.dart';
import 'package:lesson_flutter/models/MediaItems/Video.dart';
import 'package:lesson_flutter/paytm/PaymentScreen.dart';
import 'package:lesson_flutter/providers/quiz_question_provider.dart';
import 'package:lesson_flutter/providers/subscription_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/utils/index.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:lesson_flutter/widgets/loader.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:async/async.dart';

class PaymentDetail extends StatefulWidget {
  final Map arguments;
  PaymentDetail({this.arguments});

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void setError(dynamic error) {
    Provider.of<SubscriptionProvider>(context, listen: false).paymentError =
        true;
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  void initState() {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey:
            "pk_test_51Hfe6lHhf0qZuOiA52eNL5FT9pOivRWwL5peUAE9YD6y3rElPr146iWcBGAeMiSAWylQ4NtyJ4hrKePEZCT47MFE00KtaRxdiV",
        androidPayMode: "test",
        merchantId: "lessonhub",
      ),
    );
    super.initState();
  }

  Future<dynamic> initPayment(
      double amount, String source, String currency, String courses) async {
    SubscriptionProvider sp =
        Provider.of<SubscriptionProvider>(context, listen: false);
    try {
      String category = await SharedPrefs.getString("category");
      sp.loadingPayment = true;
      sp.paymentError = false;
      var res = await RequestHelper.postApi("stripe-pay", {
        "source": source,
        "amount": amount,
        "currency": currency,
        "courses": courses.toString(),
        "connection": category
      });
      doAlert(
          message: res["message"],
          type: !res["success"] ? "danger" : "success");
      if (!res["success"]) {
        sp.paymentError = true;
      }
      sp.loadingPayment = false;
      return res;
    } catch (e) {
      sp.loadingPayment = false;
      sp.paymentError = true;
      doAlert(message: "Error while completing payment");
      return {"success": false};
    }
  }

  String getNoDiscountPrice(Map data) {
    if (data == null) {
      return "0";
    }
    if (data["renewals"] == null) {
      return (data["price"] ?? 0).toString();
    }
    return (data["renewals"]["price"] == 0 || data["renewals"]["price"] == null
            ? data["price"]
            : data["renewals"]["price"])
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: AppDrawer(),
      body: FutureBuilder(
          future: this._memoizer.runOnce(() async {
            String category = await SharedPrefs.getString("category");

            var data = await RequestHelper.getApi(
                "/subscription-plan/${this.widget.arguments["courses"]}",
                queryParameters: {
                  "connection": category,
                });
            return data;
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loader(),
              );
            }
            if (snapshot.hasError) {
              return SizedBox();
            }

            if (snapshot.hasData) {
              if (snapshot.data["data"] == null) {
                return Center(
                  child: Text("Payment not set for this class"),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
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
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 30.0),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        size: 35.0,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    Spacer(),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.menu,
                                          size: 35.0,
                                          color: AppConstants.blackColor,
                                        ),
                                        onPressed: () {
                                          _scaffoldKey.currentState
                                              .openEndDrawer();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              Text(
                                "Payment Method",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Color(0xFF1f6bd1),
                                ),
                              ),
                              SizedBox(
                                height: 7.0,
                              ),
                              Container(
                                height: 60.0,
                                width: 300.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF1f6bd1),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        children: [
                                          Text(
                                            "₹${getNoDiscountPrice(snapshot.data['data'])}",
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xFF1f6bd1),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10.0,
                                            child: Transform.rotate(
                                              angle: 0.2,
                                              child: Container(
                                                color: Color(0xFF1f6bd1),
                                                height: 2.0,
                                                width: 60.0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "Now Only",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0xFF1f6bd1),
                                        ),
                                      ),
                                      Text(
                                        "₹${snapshot.data["data"]["price"]}",
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Color(0xFF1f6bd1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              Text(
                                "Select Payment Method",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Color(0xFF1f6bd1),
                                ),
                              ),
                              SizedBox(
                                height: 50.0,
                              ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.5,
                              //   child: FlatButton(
                              //     color: Color(0xFF1f6bd1),
                              //     padding: EdgeInsets.symmetric(vertical: 15.0),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(
                              //         18.0,
                              //       ),
                              //     ),
                              //     onPressed: () {},
                              //     child: Text(
                              //       "UPI PAYMENT",
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //   ),
                              // ),
                              // Container(
                              //   child: FlatButton(
                              //     color: Color(0xFF1f6bd1),
                              //     padding: EdgeInsets.symmetric(
                              //         vertical: 15.0, horizontal: 20.0),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(
                              //         18.0,
                              //       ),
                              //     ),
                              //     onPressed: () {
                              //       StripePayment.paymentRequestWithNativePay(
                              //         androidPayOptions:
                              //             AndroidPayPaymentRequest(
                              //           totalPrice: snapshot.data["data"]
                              //                   ["price"]
                              //               .toString(),
                              //           currencyCode: "INR",
                              //         ),
                              //         applePayOptions: ApplePayPaymentOptions(
                              //           countryCode: 'DE',
                              //           currencyCode: 'EUR',
                              //           items: [
                              //             ApplePayItem(
                              //               label: 'Test',
                              //               amount: '13',
                              //             )
                              //           ],
                              //         ),
                              //       ).then((token) {
                              //         showMaterialModalBottomSheet(
                              //             isDismissible: true,
                              //             context: context,
                              //             builder: (context, scrollController) {
                              //               return Container(
                              //                 height: MediaQuery.of(context)
                              //                         .size
                              //                         .height *
                              //                     0.6,
                              //                 child: Center(
                              //                   child: Provider.of<SubscriptionProvider>(
                              //                                   context)
                              //                               .loadingPayment &&
                              //                           !Provider.of<
                              //                                       SubscriptionProvider>(
                              //                                   context)
                              //                               .paymentError
                              //                       ? Column(
                              //                           crossAxisAlignment:
                              //                               CrossAxisAlignment
                              //                                   .center,
                              //                           mainAxisAlignment:
                              //                               MainAxisAlignment
                              //                                   .center,
                              //                           children: [
                              //                             CircularProgressIndicator(),
                              //                             SizedBox(
                              //                               height: 5.0,
                              //                             ),
                              //                             Text(
                              //                                 "Finalizing Payment")
                              //                           ],
                              //                         )
                              //                       : Provider.of<SubscriptionProvider>(
                              //                                   context)
                              //                               .paymentError
                              //                           ? Column(
                              //                               crossAxisAlignment:
                              //                                   CrossAxisAlignment
                              //                                       .center,
                              //                               mainAxisAlignment:
                              //                                   MainAxisAlignment
                              //                                       .center,
                              //                               children: [
                              //                                 Icon(
                              //                                   Icons.cancel,
                              //                                   size: 50.0,
                              //                                   color:
                              //                                       Colors.red,
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 5.0,
                              //                                 ),
                              //                                 Text(
                              //                                     "Error while completing payment")
                              //                               ],
                              //                             )
                              //                           : Column(
                              //                               crossAxisAlignment:
                              //                                   CrossAxisAlignment
                              //                                       .center,
                              //                               mainAxisAlignment:
                              //                                   MainAxisAlignment
                              //                                       .center,
                              //                               children: [
                              //                                 Icon(
                              //                                   Icons
                              //                                       .check_circle,
                              //                                   size: 50.0,
                              //                                   color: Colors
                              //                                       .green,
                              //                                 ),
                              //                                 SizedBox(
                              //                                   height: 5.0,
                              //                                 ),
                              //                                 Text(
                              //                                     "Payment Complete")
                              //                               ],
                              //                             ),
                              //                 ),
                              //               );
                              //             });
                              //
                              //         initPayment(
                              //           double.parse(snapshot.data["data"]
                              //                   ["price"]
                              //               .toString()),
                              //           token.tokenId,
                              //           "INR",
                              //           this
                              //               .widget
                              //               .arguments["courses"]
                              //               .toString(),
                              //         ).then((value) {
                              //           if (value["success"]) {
                              //             StripePayment
                              //                     .completeNativePayRequest()
                              //                 .then((_) {
                              //               AppRoutes.nextScreen(
                              //                 context,
                              //                 AppRoutes.classRoutes[this
                              //                     .widget
                              //                     .arguments["classIndex"]],
                              //                 arguments: {
                              //                   "classId": this
                              //                       .widget
                              //                       .arguments["courses"]
                              //                 },
                              //               );
                              //             }).catchError(setError);
                              //           }
                              //         });
                              //       }).catchError(setError);
                              //     },
                              //     child: Text(
                              //       "GPay",
                              //       style: TextStyle(color: Colors.white),
                              //     ),
                              //   ),
                              // ),
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                                  amount: snapshot.data["data"]
                                                          ["price"]
                                                      .toString(),
                                                  course: this
                                                      .widget
                                                      .arguments["courses"]
                                                      .toString(),
                                                )));
                                  },
                                  child: Text(
                                    "ONLINE PAYMENT",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
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
                                  onPressed: () {
                                    AppRoutes.nextScreen(
                                      context,
                                      AppRoutes.OFFLINE_PAYMENT,
                                      arguments: {
                                        "price": double.parse(
                                          snapshot.data["data"]["price"]
                                              .toString(),
                                        ),
                                        "courses":
                                            this.widget.arguments["courses"]
                                      },
                                    );
                                  },
                                  child: Text(
                                    "OFFLINE PAYMENT",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }

            return SizedBox();
          }),
    );
  }
}
