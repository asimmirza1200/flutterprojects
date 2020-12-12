import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getgolo/src/providers/request_services/Api+city.dart';
import 'package:getgolo/src/views/login/Widget/bezierContainer.dart';
import 'package:getgolo/src/views/login/loginPage.dart';
import 'package:getgolo/src/views/main/DashboardTabs.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var error=true;
  var emailvalidate=false;
  var passwordvalidate=false;
  var namevalidate=false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernamecontroller = TextEditingController();

  String email;

  String password;

  var showerror=false;
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller:title!="Username"? isPassword?passwordController:emailController:usernamecontroller,
              decoration: InputDecoration(
                  errorText:error?showerror?!isPassword?title!="Username"? emailvalidate? "":"Email is required":namevalidate?"":"User Name is Required":passwordvalidate? "":"Password is required":"":"Somthing went wrong",
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
  bool validateTextField(String userInput) {
    if (userInput.isEmpty) {

      return true;
    }
    return false;
  }
  Future register(String name,String email, String password) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return ApiCity.register(name,email, password).then((response) {
      if(response.json!=null){
        print(response.json);
        if(jsonDecode(response.json)["status"]) {
          prefs.setBool("islogin", true);
          prefs.setString("user", response.json).then((bool success) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (BuildContext context) => DashboardTabs()), (
                route) => false,
            );
          });
        }else{
          setState(() {
            error=false;
            showerror=true;
          });
        }
      }else{
        setState(() {
          error=false;
          showerror=true;
        });
      }

    });
  }
  Widget _submitButton() {
    return GestureDetector(
      onTap: (){
        if(validateTextField(usernamecontroller.text)){
          setState(() {
            emailvalidate=true;
            showerror=true;
            passwordvalidate=true;
            namevalidate=false;

          });
        }else if(validateTextField(emailController.text)){
          setState(() {
            emailvalidate=false;
            showerror=true;
            passwordvalidate=true;
            namevalidate=true;

          });
        }else if (validateTextField(passwordController.text)){
          setState(() {
            passwordvalidate=false;
            emailvalidate=true;
            namevalidate=true;

            showerror=true;
          });
        }else{
          setState(() {
            passwordvalidate=true;
            emailvalidate=true;
            namevalidate=true;

            showerror=false;
          });
          register(usernamecontroller.text,emailController.text, passwordController.text);

        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff000000), Color(0xffED1C24)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xffED1C24),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'my',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff000000),
          ),
          children: [
            TextSpan(
              text: 'mandap',
              style: TextStyle(color:  Color(0xffED1C24), fontSize: 30),
            ),
            // TextSpan(
            //   text: 'rnz',
            //   style: TextStyle(color: Color(0xff23D3D3), fontSize: 30),
            // ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
