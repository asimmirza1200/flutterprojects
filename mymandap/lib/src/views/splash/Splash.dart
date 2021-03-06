import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getgolo/modules/setting/colors.dart';
import 'package:getgolo/modules/setting/fonts.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/PlaceAmenity.dart';
import 'package:getgolo/src/entity/PlaceCategory.dart';
import 'package:getgolo/src/entity/PlaceType.dart';
import 'package:getgolo/src/entity/Post.dart';
import 'package:getgolo/src/entity/User.dart';
import 'package:getgolo/src/providers/request_services/Api+city.dart';
import 'package:getgolo/src/providers/request_services/PlaceProvider.dart';
import 'package:getgolo/src/providers/request_services/Api+post.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/views/login/welcomePage.dart';
import 'package:getgolo/src/views/main/DashboardTabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Container(
              height: 275,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image(image: AssetImage('assets/app/launch/Logo.png'), fit: BoxFit.cover),
                  Column(
                    children: <Widget>[
                      Text(
                        "Golo",
                        style: TextStyle(
                            fontFamily: GoloFont,
                            fontSize: 50,
                            fontWeight: FontWeight.w500,
                            color: GoloColors.secondary1),
                      ),
                      Text(
                        "Travel city guide template",
                        style: TextStyle(
                            fontFamily: GoloFont,
                            fontSize: 22,
                            color: GoloColors.secondary1),
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    child: SpinKitChasingDots(
                      color: GoloColors.primary,
                      size: 45,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              child: Column(
                    children: <Widget>[
                      Text(
                        "V.1.0.0",
                        style: TextStyle(
                            fontFamily: GoloFont,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: GoloColors.secondary1),
                      ),
                    ],
                  ),
          ))
        ],
      ),
    );
  }

  // ### Navigation
  Future<void> openDashboard() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;

    if(prefs.getBool('islogin')==null?false:prefs.getBool('islogin')){
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => DashboardTabs()));
    }else{
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WelcomePage()));
    }

  }

  // ### Fetch Data
  void loadData() async {
    await Future.wait([fetchAllCities(), fetchPosts(), fetchPopularCities()]).then((value) {
      openDashboard();
    });
  }

  Future fetchPopularCities() async {
    return ApiCity.fetchCitiesPopular().then((response) {
      print(  response.json);

      AppState().popularCities = List<City>.generate(
        response.json.length, 
        (i) => City.fromJson(response.json[i]));
    });
  }

  Future fetchAllCities() async {
    return ApiCity.fetchCities().then((response) {
      AppState().cities = List<City>.generate(
        response.json.length, 
        (i) => City.fromJson(response.json[i]));
    });
  }
  // Future fetchAllBookmark() async {
  //   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //   final SharedPreferences prefs = await _prefs;
  //
  //   return ApiCity.fetchBookmarklist(User.fromJson(jsonDecode(prefs.getString("user"))).id).then((response) {
  //     AppState().cities = List<City>.generate(
  //         response.json.length,
  //             (i) => City.fromJson(response.json[i]));
  //   });
  // }
  Future fetchCategories() async {
    return ApiCity.fetchCategories().then((response) {
      AppState().categories = List<PlaceCategory>.generate(
        response.json.length, 
        (i) => PlaceCategory.fromJson(response.json[i]));
    });
  }

  Future fetchAmenities() async {
    return ApiCity.fetchAmenities().then((response) {
      AppState().amenities = List<PlaceAmenity>.generate(
        response.json.length, 
        (i) => PlaceAmenity.fromJson(response.json[i]));
    });
  }

  Future fetchPlaceTypes() async {
    return PlaceProvider.getPlaceTypes(query: PageQuery(50, 1)).then((response) {
      AppState().placeTypes = List<PlaceType>.generate(
        response.json.length, 
        (i) => PlaceType.fromJson(response.json[i]));
    });
  }

  // Post
  Future fetchPosts() async {
    return ApiPost.fetchPosts().then((response) {
      AppState().posts = List<Post>.generate(
        response.json.length, 
        (i) => Post(response.json[i]));
    });
  }

}
