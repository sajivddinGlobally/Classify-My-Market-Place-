import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/login/Model/loginBodyModel.dart';
import 'package:shopping_app_olx/login/Model/loginResMdel.dart';


part 'loginService.g.dart';


@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')

abstract class LoginService {

  factory LoginService(Dio dio, {String baseUrl}) = _LoginService;

  // @POST('/api/auth/login')
  // Future<LoginResModel> login(@Body() LoginBodyModel body);
  //

  @POST('/api/send-otp')
  Future<LoginResModel> login(@Body() LoginBodyModel body);



}
