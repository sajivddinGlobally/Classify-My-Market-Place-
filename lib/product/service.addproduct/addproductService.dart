import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/product/model.addproduct/addProductBodyModel.dart';
import 'package:shopping_app_olx/product/model.addproduct/addproductResModel.dart';

part 'addproductService.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class AddproductService {
  factory AddproductService(Dio dio, {String baseUrl}) = _AddproductService;
  @POST('/api/Add/product')
  Future<AddproductResModel> addProduct(@Body() AddproductBodyModel body);
}
