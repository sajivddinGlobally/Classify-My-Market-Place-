import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/login/Model/loginBodyModel.dart';
import 'package:shopping_app_olx/login/login.state.dart';
import 'package:shopping_app_olx/login/service/loginService.dart';

class Logincontroller extends StateNotifier<Loginstate> {
  Logincontroller() : super(LoginInitial());

  // login method
  Future<void> login(LoginBodyModel body) async {
    log("login process started");

    try {
      state = LoginLoading();
      final dio = await createDio();
      final loginservice = LoginService(dio);
      final response = await loginservice.login(body);

      state = LoginSuccess(response);
      log("Login success ${response.toString()}");
    } catch (e) {
      state = LoginError(e.toString());
      log("Login failed ${e.toString()}");
    }
  }
}

final loginProvider = StateNotifierProvider<Logincontroller, Loginstate>(
  (ref) => Logincontroller(),
);
