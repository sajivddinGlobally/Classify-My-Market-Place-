import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/report/reportAdBodyModel.dart';
import 'package:shopping_app_olx/report/reportAdResModel.dart';

part 'reportAdService.g.dart';

@RestApi(baseUrl: "https://classify.mymarketplace.co.in")
abstract class ReportAdService {
  factory ReportAdService(Dio dio, {String baseUrl}) = _ReportAdService;

  @POST("/api/report/ad")
  Future<ReportAdResModel> reportIsue(@Body() ReportAdBodyModel body);
}
