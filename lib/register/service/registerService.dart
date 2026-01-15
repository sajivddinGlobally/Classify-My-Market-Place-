import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/register/model/registerBodyModel.dart';
import 'package:shopping_app_olx/register/model/registerResModel.dart';
part 'registerService.g.dart';



@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')

abstract class RegisterService {
  factory RegisterService(Dio dio, {String baseUrl}) = _RegisterService;
  @POST('/api/auth/register')
  Future<RegisterResModel> register(@Body() RegisterBodyModel body);
}
