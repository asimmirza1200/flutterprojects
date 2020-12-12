import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lesson_flutter/pages/signup_screen.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/services/auth_service.dart';
import 'package:lesson_flutter/widgets/background.dart';
import 'package:lesson_flutter/widgets/rounded_button.dart';
import 'package:lesson_flutter/widgets/rounded_input_field.dart';
import 'package:lesson_flutter/widgets/rounded_password_field.dart';
import 'package:lesson_flutter/widgets/text_field_container.dart';
import 'already_have_an_account_acheck.dart';
import 'package:validation_extensions/validation_extensions.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class LoginBody extends StatefulWidget {
  LoginBody({
    Key key,
  }) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  String phoneValidation(String v) => [v.isRequired()].validate();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();

  String initialCountry = 'IN';

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  String userEmail = "";

  String phoneNumber = "";
  bool loading = false;
  @override
  void initState() {
    SignInProvider sp = Provider.of<SignInProvider>(context, listen: false);
    this.setState(() {
      phoneNumber = sp.mobileData["username"] ?? "";
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    height: size.height / 2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/login_lay_4.png",
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    width: size.width * 0.7,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.03),
                        TextFieldContainer(
                          child: InternationalPhoneNumberInput(
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            onInputChanged: (PhoneNumber number) {
                              this.setState(() {
                                phoneNumber = number.phoneNumber;
                              });
                            },
                            onInputValidated: (bool value) {},
                            inputBorder: InputBorder.none,
                            ignoreBlank: false,
                            initialValue: number,
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                            inputDecoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0.0),
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            selectorTextStyle: TextStyle(color: Colors.white),
                            textFieldController: controller,
                          ),
                        ),
                        RoundedButton(
                          text: "Login",
                          color: Color(0xFF0c70a8),
                          loading: loading,
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              this.setState(() {
                                loading = true;
                              });
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              await AuthService.authenticateUser(
                                phoneNumber,
                                userEmail,
                                context,
                                () {
                                  this.setState(() {
                                    loading = false;
                                  });
                                },
                                false,
                              );
                            }
                          },
                        ),
                        RoundedButton(
                          text: "Create Account",
                          color: Color(0xFF0c70a8),
                          loading: false,
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
    // return Background(
    //   child: SingleChildScrollView(
    //     child: Form(
    //       key: _formKey,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Text(
    //             "LOGIN",
    //             style: TextStyle(fontWeight: FontWeight.bold),
    //           ),
    //           SizedBox(height: size.height * 0.03),
    //           SvgPicture.asset(
    //             "assets/login.svg",
    //             height: size.height * 0.35,
    //           ),
    //           SizedBox(height: size.height * 0.03),
    //           TextFieldContainer(
    //             child: InternationalPhoneNumberInput(
    //               onInputChanged: (PhoneNumber number) {
    //                 this.setState(() {
    //                   phoneNumber = number.phoneNumber;
    //                 });
    //               },
    //               onInputValidated: (bool value) {},
    //               inputBorder: InputBorder.none,
    //               ignoreBlank: false,
    //               autoValidate: false,
    //               initialValue: number,
    //               selectorTextStyle: TextStyle(color: Colors.black),
    //               textFieldController: controller,
    //             ),
    //           ),
    //           RoundedButton(
    //             text: "LOGIN",
    //             loading: loading,
    //             press: () async {
    //               if (_formKey.currentState.validate()) {
    //                 this.setState(() {
    //                   loading = true;
    //                 });
    //                 // If the form is valid, display a snackbar. In the real world,
    //                 // you'd often call a server or save the information in a database.
    //                 await AuthService.authenticateUser(
    //                   phoneNumber,
    //                   userEmail,
    //                   context,
    //                   () {
    //                     this.setState(() {
    //                       loading = false;
    //                     });
    //                   },
    //                   false,
    //                 );
    //               }
    //             },
    //           ),
    //           SizedBox(height: size.height * 0.03),
    //           AlreadyHaveAnAccountCheck(
    //             press: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                   builder: (context) {
    //                     return SignUpScreen();
    //                   },
    //                 ),
    //               );
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
