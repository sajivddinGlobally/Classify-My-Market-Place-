import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:shopping_app_olx/login/Model/otpBodyModel.dart';
import 'package:shopping_app_olx/login/Model/otpResModel.dart';
part 'otpService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')

abstract class OtpService {

  factory OtpService(Dio dio, {String baseUrl}) = _OtpService;

  // @POST('/api/auth/verifyOtp')
  // Future<OtpResModel> verifyOtp(@Body() OtpBodyModel body);


  @POST('/api/verify-otp')
  Future<OtpResModel> verifyOtp(@Body() OtpBodyModel body);

}


//
// https://classify.mymarketplace.co.in/api/verify-otp


