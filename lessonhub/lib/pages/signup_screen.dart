import 'package:flutter/material.dart';
import 'package:lesson_flutter/pages/otp_verification.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/widgets/register_body.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Consumer<SignInProvider>(
        builder: (BuildContext context, SignInProvider data, _) {
          return !data.codeSent ? RegisterBody() : OtpVerification();
        },
      ),
    );
  }
}
