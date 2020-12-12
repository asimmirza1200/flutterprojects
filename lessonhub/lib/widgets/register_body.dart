import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lesson_flutter/api/request_helper.dart';
import 'package:lesson_flutter/pages/login_screen.dart';
import 'package:lesson_flutter/providers/sign_in_provider.dart';
import 'package:lesson_flutter/services/auth_service.dart';
import 'package:lesson_flutter/utils/toast.dart';
import 'package:lesson_flutter/widgets/already_have_an_account_acheck.dart';
import 'package:lesson_flutter/widgets/or_divider.dart';
import 'package:lesson_flutter/widgets/register_background.dart';
import 'package:lesson_flutter/widgets/rounded_button.dart';
import 'package:lesson_flutter/widgets/rounded_input_field.dart';
import 'package:lesson_flutter/widgets/rounded_password_field.dart';
import 'package:lesson_flutter/widgets/social_icon.dart';
import 'package:lesson_flutter/widgets/text_field_container.dart';
import 'package:validation_extensions/validation_extensions.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class RegisterBody extends StatefulWidget {
  @override
  _RegisterBodyState createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String emailValidation(String v) => [v.isRequired(), v.isEmail()].validate();

  String phoneValidation(String v) => [v.isRequired()].validate();

  final TextEditingController controller = TextEditingController();

  String initialCountry = 'IN';

  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  String userEmail = "";
  String phoneNumber = "";

  @override
  void initState() {
    RequestHelper.bootstrap();
    SignInProvider sp = Provider.of<SignInProvider>(context, listen: false);
    this.setState(() {
      userEmail = sp.mobileData["email"] ?? "";
      phoneNumber = sp.mobileData["username"] ?? "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      reverse: true,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: bottom),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    height: size.height / 2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/signup_lay.png",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.7,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.03),
                        RoundedInputField(
                          onSaved: (value) {
                            this.setState(() {
                              userEmail = value;
                            });
                          },
                          initialValue: userEmail,
                          hintText: "Your Email",
                          onChanged: (value) {
                            setState(() {
                              userEmail = value;
                            });
                          },
                          validator: emailValidation,
                        ),
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

                            selectorTextStyle: TextStyle(color: Colors.white),
                            textFieldController: controller,
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                            inputDecoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        RoundedButton(
                          text: "CREATE",
                          loading: loading,
                          color: Color(0xFF0a6194),
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
                                true,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return RegisterBackground(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/signup.svg",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                onSaved: (value) {
                  this.setState(() {
                    userEmail = value;
                  });
                },
                initialValue: userEmail,
                hintText: "Your Email",
                onChanged: (value) {
                  setState(() {
                    userEmail = value;
                  });
                },
                validator: emailValidation,
              ),
              TextFieldContainer(
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    this.setState(() {
                      phoneNumber = number.phoneNumber;
                    });
                  },
                  onInputValidated: (bool value) {},
                  inputBorder: InputBorder.none,
                  ignoreBlank: false,
                  initialValue: number,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  textFieldController: controller,
                ),
              ),
              RoundedButton(
                text: "SIGNUP",
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
                      true,
                    );
                  }
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
