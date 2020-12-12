
import 'dart:convert';

import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/modules/state/AppState.dart';
import 'package:getgolo/src/entity/City.dart';
import 'package:getgolo/src/entity/Review.dart';
import 'package:getgolo/src/entity/User.dart';
import 'package:getgolo/src/providers/request_services/Api+city.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/providers/request_services/response/ResponseListData.dart';
import 'package:getgolo/src/views/login/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceProvider {


  static Future<ResponseListData> getFeature(String cityId, {PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/cities/$cityId";
    return Api.requestGetPaging(url, query).then((data) {
      var placesJson = data.json != null ? json.decode(data.json) as Map : null;
      var jsonData = placesJson["data"]["features"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }
  
  static Future<ResponseData> getPlaceDetail(String placeId, {PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/places/$placeId";
    return Api.requestGet(url).then((data) {
      var jsonData = data.json != null ? json.decode(data.json) : null;
      return ResponseData(jsonData,data.error);
    });
  }
  static  Future<ResponseData> fetchAllBookmark() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
// print(prefs.getString("user"));
    return ApiCity.fetchBookmarklist(LoginResponse.fromJson(jsonDecode(prefs.getString("user"))).user.id).then((response) {
      return response;
    });
  }
  static  Future<ResponseData> addBookmark(String pId,catId) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
// print(prefs.getString("user"));
    return ApiCity.addBookmarklist(LoginResponse.fromJson(jsonDecode(prefs.getString("user"))).user.id,pId,catId).then((response) {
       return response;
     });
  }
  static  Future<ResponseData> removeBookmark(String pId,catId) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
// print(prefs.getString("user"));
    return ApiCity.removeBookmarklist(LoginResponse.fromJson(jsonDecode(prefs.getString("user"))).user.id,pId,catId).then((response) {
      return response;
    });
  }
  static Future<ResponseListData> getPlaceTypes({PageQuery query}) {
    var url = Platform().shared.baseUrl + "place-type";
    return Api.requestGetPaging(url, query).then((data) {
      var typesJson = data.json != null ? json.decode(data.json) : null;
      return ResponseListData(typesJson, data.error);
    });
  }

  static Future<List<Review>> getPlaceComments(int placeId, {PageQuery query}) {
    var url = Platform().shared.baseUrl + "comments?post=$placeId";
    return Api.requestGetPaging(url, query).then((response) {
      List<dynamic> items = json.decode(response.json);
      if (items != null && items.length > 0) {
          return List<Review>.generate(items.length, (i) => Review(items[i]));
      }
      return null;
    });
  }

}