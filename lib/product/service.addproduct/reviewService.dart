import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/product/model.addproduct/reviewBodyModel.dart';
import 'package:shopping_app_olx/product/model.addproduct/reviewResModel.dart';

part 'reviewService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class ReviewService {
  factory ReviewService(Dio dio, {String baseUrl}) = _ReviewService;

  @POST('/api/review')
  Future<ReviewResModel> reviewAdd(@Body() ReviewBodyModel body);
}
