import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/googleLogin/model/googleLoginBodyModel.dart';
import 'package:shopping_app_olx/googleLogin/model/googleLoginResModel.dart';
import 'package:shopping_app_olx/login/Model/loginResMdel.dart';

part 'googleService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class GoogleService {
  factory GoogleService(Dio dio, {String baseUrl}) = _GoogleService;

  @POST('/api/auth/google-login')
  Future<GoogleLoginResModel> googleLogin(@Body() GoogleLoginBodyResModel body);

  @POST('/api/auth/facebook-login')
  Future<GoogleLoginResModel> facebookLogin(
    @Body() FacebookLoginBodyModel body,
  );
}
