import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesson_flutter/api/index.dart';
import 'package:lesson_flutter/main.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/services/auth_service.dart';
import 'package:lesson_flutter/utils/global_values.dart';
import 'package:lesson_flutter/utils/shared_prefs.dart';
import 'package:lesson_flutter/utils/toast.dart';

class RequestHelper {
  static int trials = 1;
  static String _token = ApiHandler.environment == "development_local"
      ? ""
      : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC8xMy4yMzMuMjA4LjI0NlwvbGVzc29uaHViXC9hdXRoXC9sb2dpbiIsImlhdCI6MTU5OTkxNzg3NywiZXhwIjozNDkzMzM0OTk3LCJuYmYiOjE1OTk5MTc4NzcsImp0aSI6IkJuR05qQnBwS2xmUExEOHgiLCJzdWIiOjExNywicHJ2IjoiODdlMGFmMWVmOWZkMTU4MTJmZGVjOTcxNTNhMTRlMGIwNDc1NDZhYSJ9.icxzQyOuRMc1xgFIkNmTuWrS1rcLg9i0qKwWWA8X2ZE";
  static Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiHandler.BASE_URL,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      followRedirects: true,
    ),
  );
  static void bootstrap() {
    RequestHelper._dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      // Do something before request is sent
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) async {
      // Do something with response data
      trials = 1;
      return response; // continue
    }, onError: (DioError e) async {
      // Do something with response error
      try {
        if (!(e == null || e.response == null)) {
          if (e.response.statusCode == 401) {
            String category = await SharedPrefs.getString("category", "");
            String token = await SharedPrefs.getString("token", "");
            if (token != "") {
              var res = await RequestHelper.postApiZero(
                  "/auth/refresh-token", {"token": token});
              token = res["data"]["access_token"];
              if (token != null) {
                RequestOptions options = e.response.request;
                options.headers["Authorization"] = "Bearer " + token;
                SharedPrefs.setString("token", token);
                return _dio.request(options.path, options: options);
              } else {
                AuthService.logoutUser(
                  GlobalsValues.globalScaffold.currentContext,
                );
                // Navigator.of(GlobalsValues.globalScaffold.currentContext).pusN
                AppRoutes.nextScreen(
                    GlobalsValues.globalScaffold.currentContext,
                    AppRoutes.LOGIN);
              }
            } else {
              AuthService.logoutUser(
                GlobalsValues.globalScaffold.currentContext,
              );
              // Navigator.of(GlobalsValues.globalScaffold.currentContext).pusN
              AppRoutes.nextScreen(
                  GlobalsValues.globalScaffold.currentContext, AppRoutes.LOGIN);
            }
          } else if (e.response.statusCode == 400 &&
              e.response.data["message"] == "Cant reload jwt") {
            if (trials == 1) {
              AuthService.logoutUser(
                GlobalsValues.globalScaffold.currentContext,
              );
              // Navigator.of(GlobalsValues.globalScaffold.currentContext).pusN
              var language = await SharedPrefs.getString("language", "");
              var category = await SharedPrefs.getString("category", "");
              Navigator.of(GlobalsValues.globalScaffold.currentContext)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return getAfterLoginWidget({
                  "logged"+category: false,
                  "language": language,
                  "category": category
                });
              }));
            }
          } else {
            // doAlert(message: "Something went wrong");
            return e;
          }
        }
      } on DioError catch (e) {
        if (e.response.statusCode == 401) {
          if (e.response.data["message"] == "Cant reload jwt") {
            if (trials == 1) {
              AuthService.logoutUser(
                GlobalsValues.globalScaffold.currentContext,
              );
              // Navigator.of(GlobalsValues.globalScaffold.currentContext).pusN
              var language = await SharedPrefs.getString("language", "");
              var category = await SharedPrefs.getString("category", "");
              Navigator.of(GlobalsValues.globalScaffold.currentContext)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return getAfterLoginWidget({
                  "logged": false,
                  "language": language,
                  "category": category
                });
              }));
            }
            trials++;
          }
        } else {
          doAlert(
              message: e.response.data["message"] ?? "Something went wrong");
        }
      } on Exception catch (e) {
        doAlert(message: "Something went wrong", type: "danger");
      }
    }));
  }

  static String getErrorMessage(dynamic errorObj) {
    return errorObj is String
        ? errorObj
        : errorObj["message"] != null && errorObj["message"] != ""
            ? errorObj["message"]
            : "Something went wrong";
  }

  static Future getApi(String url,
      {Map<String, dynamic> queryParameters}) async {
    try {
      RequestHelper.bootstrap();
      String category = await SharedPrefs.getString("category", "");
      String token = await SharedPrefs.getString("token", "");
      if (token != "") {
        Response response = await _dio.get(
          url+"&category="+category,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Accept": "application/json",
            },
          ),
        );
        if (response.statusCode < 300 && response.statusCode > 199) {
          print("found none");
          return response.data;
        } else {
          print("error");
          print(response.data);
          doAlert(message: response.data["message"] ?? "Something went wrong");
        }
      } else {
        AuthService.logoutUser(GlobalsValues.globalScaffold.currentContext);
      }
    } on DioError catch (e) {
      print(e.response.data);
      doAlert(
        message: e?.response?.data != null
            ? getErrorMessage(e.response.data)
            : "Something went wrong",
      );
    } catch (e) {
      print(e);
      doAlert(message: "Something went wrong");
    }
  }

  static Future getApiZero(String url) async {
    print(url);
    try {
      Response response = await _dio.get(
        url,
      );
      if (response.statusCode < 300 && response.statusCode > 199) {
        return response.data;
      } else {
        doAlert(message: response.data.message ?? "Something went wrong");
      }
      return null;
    } on DioError catch (e) {
      print(e.response.data);
      doAlert(message: e.response.data["message"] ?? "Something went wrong");
      return null;
    } catch (e) {
      print(e);
      doAlert(message: "Something went wrong");
      return null;
    }
  }

  static Future postApi(String url, Map data) async {
    try {
      String category = await SharedPrefs.getString("category", "");
      String token = await SharedPrefs.getString("token", "");
      print(data);
      Response response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode < 300 && response.statusCode > 199) {
        return response.data;
      } else {
        print("res");
        doAlert(message: response.data["message"] ?? "Something went wrong");
        return response.data;
      }
    } on DioError catch (e) {
      print(e.response.data);
      try {
        doAlert(message: e.response.data["message"]);

        return {"success": false, "message": e.response.data["message"]};
      } catch (e) {
        doAlert(message: "Something went wrong");
        return {"success": false, "message": "Something went wrong"};
      }
    } catch (e) {
      print(e);

      doAlert(message: "Something went wrong");
      return {"success": false, "message": "Something went wrong"};
    }
  }

  static Future postApiZero(String url, Map data) async {
    try {
      Response response = await _dio.post(
        url,
        options: Options(headers: {
          "Accept": Headers.jsonContentType,
        }),
        data: data,
      );
      if (response.statusCode < 300 && response.statusCode > 199) {
        return response.data;
      } else {
        doAlert(message: response.data.message ?? "Something went wrong");
      }
      return null;
    } on DioError catch (e) {
      if (e.response.data["errors"] != null) {
        Map errors = e.response.data["errors"];
        String currentError = errors.values.toList()[0][0];
        doAlert(message: currentError);
      } else {
        doAlert(message: e.response.data["message"] ?? "Something went wrong");
        return null;
      }
      return null;
    } catch (e) {
      print(e);
      doAlert(message: "Something went wrong");
      return null;
    }
  }
}
