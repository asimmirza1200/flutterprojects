import 'dart:convert';

import 'package:den_lineicons/den_lineicons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/src/views/login/loginPage.dart';
import 'package:getgolo/src/views/login/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class ProfileUI2 extends StatefulWidget {


   @override
   _ProfileUI2State createState() => _ProfileUI2State();
}
class _ProfileUI2State extends State<ProfileUI2> {
 LoginResponse loginResponse;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences prefs;

  @override
  void initState()  {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    // print(loginResponse);
    getData();

    return Scaffold(
        body: SafeArea(
          child: Column(

            children: [
              Container(

                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0,2.5),
                    child: CircleAvatar(

                      radius: 60.0,
                      child: Image.asset('assets/photos/profile.png'),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 80,
              ),
              Text(
                        loginResponse.user.name,
                        style: TextStyle(
                            fontSize: 18.0,
                            color:Colors.black45,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w300
                        ),
                      ),

              SizedBox(
                height: 10,
              ),
              Text(
                loginResponse.user.email,
                style: TextStyle(
                    fontSize: 18.0,
                    color:Colors.black45,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w300
                ),
              ),

              SizedBox(
                height: 100,
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 0, right: 0),
                  decoration:
                  BoxDecoration(color: Colors.black, shape: BoxShape.rectangle),
                  height: 40,
                  width: 100,
                  child: CupertinoButton(
                    padding:
                    EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 6),
                    onPressed: () async {

                      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                      final SharedPreferences prefs = await _prefs;
                      prefs.clear();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()), (
                      route) => false,
                      );


                    },
                    child:Text("Logout",style: TextStyle(fontSize: 18,color: Colors.white),),
                  ),
                ),

            ],
          ),
        )
    );

  }

  Future<void> getData() async {

    final SharedPreferences prefs = await _prefs;
    String data=prefs.getString("user");
    print(data);
    loginResponse=LoginResponse.fromJson(jsonDecode(data));

  }
}


