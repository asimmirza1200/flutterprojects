import 'package:flutter/material.dart';
import 'package:lesson_flutter/pages/otp_verification.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/utils/global_values.dart';
import 'package:lesson_flutter/widgets/login_body.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Map arguments;
  LoginScreen({this.arguments});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Consumer<SignInProvider>(
        builder: (BuildContext context, SignInProvider data, _) {
          print(data.codeSent==true?"fghfghfg":"false");

          return !data.codeSent ? LoginBody() : OtpVerification();
        },
      ),
    );
  }

  @override
  void dispose() {
    print("jhdsjkdhfkhf");
    Provider.of<SignInProvider>(GlobalsValues.globalScaffold.currentContext,
            listen: false)
        .resetLoginPage();
    super.dispose();
  }
}
