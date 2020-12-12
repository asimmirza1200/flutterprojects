  import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/services/auth_service.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:lesson_flutter/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpVerification extends StatefulWidget {
  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    RequestHelper.bootstrap();
    super.initState();
  }

  bool loading = false;
  Future<void> doValidateAndCreateUser(
      BuildContext context, String smsCode) async {
    this.setState(() {
      loading = true;
    });
    SignInProvider sp = Provider.of<SignInProvider>(context, listen: false);
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: sp.mobileData["verificationId"], smsCode: smsCode);
      await AuthService.auth.signInWithCredential(phoneAuthCredential);
      if (sp.mobileData["email"].isNotEmpty && sp.mobileData["isNew"]) {
        await AuthService.registerUserToServer(context,
            Provider.of<SignInProvider>(context, listen: false).mobileData, () async {
          this.setState(() {
            loading = false;
          });
          SharedPrefs.setBool("logged"+await SharedPrefs.getString("category", ""), true);
        });
      } else if (!sp.mobileData["isNew"]) {
        try {
          await AuthService.loginUserToServer(context,
              Provider.of<SignInProvider>(context, listen: false).mobileData,
              () async {
            this.setState(() {
              loading = false;
            });

            SharedPrefs.setBool("logged"+await SharedPrefs.getString("category", ""), true);
          });
        } catch (e) {
          print(e);
        }
      } else {
        doAlert(message: "Error logging in");
        this.setState(() {
          loading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      doAlert(message: e.message);
      this.setState(() {
        loading = false;
      });
    } on DioError catch (e) {
      this.setState(() {
        loading = false;
      });

      doAlert(message: e.response.data["message"] ?? "Something went wrong");
    } catch (e) {
      this.setState(() {
        loading = false;
      });
      doAlert(message: "Something went wrong");
    }
  }

  String getAllTexts(List<TextEditingController> controllers) {
    return controllers.map((controller) => controller.value.text).join("");
  }

  void goBack() {
    Provider.of<SignInProvider>(context, listen: false).codeSent = false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      // endDrawer: AppDrawer(),
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
          Positioned(
            top: 0,
            left: 0,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   margin: EdgeInsets.only(top: kToolbarHeight - 40.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       IconButton(
                //         icon: Icon(
                //           Icons.arrow_back,
                //           color: Colors.white,
                //         ),
                //         onPressed: () {
                //           goBack();
                //         },
                //       ),
                //       Spacer(),
                //       Container(
                //         child: IconButton(
                //           icon: Icon(
                //             Icons.menu,
                //             size: 30.0,
                //             color: AppConstants.blackColor,
                //           ),
                //           onPressed: () {
                //             _scaffoldKey.currentState.openEndDrawer();
                //           },
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        "We have sent you access code via SMS for mobile verification",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppConstants.kBlueColor,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),

                      loading ? CircularProgressIndicator() : SizedBox(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: AppConstants.kBlueColor,
                        //   ),
                        //   borderRadius: BorderRadius.circular(30.0),
                        // ),
                        alignment: Alignment.center,

                        child: OTPTextField(
                          length: 6,

                          fieldStyle: FieldStyle.box,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 50,
                          style: TextStyle(fontSize: 17),
                          onCompleted: (pin) {
                            doValidateAndCreateUser(context, pin);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),

                      Text(
                        "Didnt receive OTP?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppConstants.kBlueColor,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      FlatButton(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 15.0,
                        ),
                        onPressed: () {
                          Provider.of<SignInProvider>(context, listen: false)
                              .codeSent = false;
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppConstants.kBlueColor),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          "Resend",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppConstants.kBlueColor,
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
      ),
    );
  }
}
