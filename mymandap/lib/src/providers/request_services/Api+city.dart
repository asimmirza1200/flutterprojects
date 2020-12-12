import 'dart:convert';
import 'dart:ffi';

import 'package:getgolo/modules/services/platform/Platform.dart';
import 'package:getgolo/modules/services/http/Api.dart';
import 'package:getgolo/src/providers/request_services/query/PageQuery.dart';
import 'package:getgolo/src/providers/request_services/response/ResponseListData.dart';
import 'package:getgolo/src/views/login/login_response.dart';



class ApiCity {
  static Future<ResponseListData> fetchCities({PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/cities";
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }
  static Future<ResponseData> fetchBookmarklist(int id) {
    var url = Platform().shared.baseUrl + "app/bookmark/"+id.toString();
    print(url);
    return Api.requestGet(url).then((data) {
      print(data.json+"fgh");
      return ResponseData(data.json,null);
    });
  }
  static Future<ResponseData> removeBookmarklist(int id,String pId,String catId) {
    var url = Platform().shared.baseUrl + "app/bookmark/"+id.toString()+"/"+pId+"/"+catId+"/"+"remove";
    print(url);
    return Api.requestGet(url).then((data) {
      print(data.json+"fgh");
      return ResponseData(data.json,null);
    });
  }
  static Future<ResponseData> addBookmarklist(int id,String pId,String catId) {
    var url = Platform().shared.baseUrl + "app/bookmark/"+id.toString()+"/"+pId+"/"+catId+"/"+"add";
    print(url);
     return Api.requestGet(url).then((data) {
       print(data.json+"fgh");
       return ResponseData(data.json,null);
     });
  }
  static Future<ResponseListData> fetchCitiesPopular({PageQuery query}) {
    var url = Platform().shared.baseUrl + "app/cities/popular";
    print(url);
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;

      return ResponseListData(jsonData, data.error);
    });
  }

  static Future<ResponseData> fetchCity(String id) {
    var url = Platform().shared.baseUrl + "cities/$id";
    
    return Api.requestGet(url);
  }
  static Future<ResponseData> authenticate(String email,String password) {
    var url = Platform().shared.baseUrl + "app/users/login";
    Map<String, dynamic> params = {
      'email':email,
      'password': password,
    };
    return Api.request(RequestType.Post,url ,body: params);
  }
  static Future<ResponseData> register(String name,String email,String password) {
    var url = Platform().shared.baseUrl + "app/users/signup";
    Map<String, dynamic> params = {
      'name':name,
      'email':email,
      'password': password,
    };
    return Api.request(RequestType.Post,url ,body: params);
  }
  // Category
  static Future<ResponseListData> fetchCategories({PageQuery query}) {
    var url = Platform().shared.baseUrl + "place-categories";
    return Api.requestGetPaging(url, query).then((data) {
      return ResponseListData(json.decode(data.json), data.error);
    });
  }

  // Amenities
  static Future<ResponseListData> fetchAmenities({PageQuery query}) {
    var url = Platform().shared.baseUrl + "place-amenities";
    return Api.requestGetPaging(url, query).then((data) {
      var jsonObj = json.decode(data.json) as Map;
      var jsonData = jsonObj["data"] as List;      
      return ResponseListData(jsonData, data.error);
    });
  }
  
}
