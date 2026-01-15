import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/report/reportAdBodyModel.dart';
import 'package:shopping_app_olx/report/reportAdResModel.dart';

import 'HelpAndSupportModel.dart';
import 'helpSupportBodyModel.dart';

part 'HelpSupportService.g.dart';

@RestApi(baseUrl: "https://classify.mymarketplace.co.in")
abstract class HelpSupportService {
  factory HelpSupportService(Dio dio, {String baseUrl}) = _HelpSupportService;

  @POST("/api/help-support/store")
  Future<HelpAndSupportModelResponse> helpSupport(@Body() HelpSupportBodyModel body);
}
