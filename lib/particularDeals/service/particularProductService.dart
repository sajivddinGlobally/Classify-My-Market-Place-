import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/particularDeals/model/particularProductModel.dart';
part 'particularProductService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class ParticularProductService {
  factory ParticularProductService(Dio dio, {String baseUrl}) =
      _ParticularProductService;
  @GET('/api/ProductDetails?id={id}&user_id={userId}')
  Future<ParticularProductModel> particularProduct(
    @Path() String id,
    @Path() String userId,
  );
}
