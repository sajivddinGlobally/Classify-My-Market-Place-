import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio createDio() {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  var box = Hive.box("data");
  var token = box.get("token");

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Retrieve token before sending request
        options.headers.addAll({
          'Content-Type': 'application/json',
          "Accept": "application/json",
          // 'Authorization': 'Bearer $token',
          if (token != null) 'Authorization': 'Bearer $token',
        });
        handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          log("Token expired, handling in UI layer");
          Fluttertoast.showToast(msg: "Session expired. Please log in again.");

          // Just clear token, no navigation here
          var box = Hive.box("data");
          await box.delete("token");

          // Notify app to log out
          logoutNotifier.value = true;

          return;
        }

        handler.next(e);
      },
    ),
  );

  return dio;
}

ValueNotifier<bool> logoutNotifier = ValueNotifier(false);

Dio createDio2() {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  return dio;
}


Dio createDio3() {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
    ),
  );

  var box = Hive.box("data");
  var token = box.get("token");

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Retrieve token before sending request
        options.headers.addAll({
          'Content-Type': 'application/json',
          "Accept": "application/json",
          // 'Authorization': 'Bearer $token',
          if (token != null) 'Authorization': 'Bearer $token',
        });
        handler.next(options); // Continue with the request
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          log("Token expired, handling in UI layer");
          Fluttertoast.showToast(msg: "Session expired. Please log in again.");

          // Just clear token, no navigation here
          var box = Hive.box("data");
          await box.delete("token");

          // Notify app to log out
          logoutNotifier.value = true;

          return;
        }

        handler.next(e);
      },
    ),
  );

  return dio;
}