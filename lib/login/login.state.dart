import 'package:shopping_app_olx/login/Model/loginResMdel.dart';

abstract class Loginstate {}

class LoginInitial extends Loginstate {}

class LoginLoading extends Loginstate {}

class LoginSuccess extends Loginstate {
  final LoginResModel Response;
  LoginSuccess(this.Response);
}

class LoginError extends Loginstate {
  final String message;
  LoginError(this.message);
}
