/*
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/cloth/model/categoryResModel.dart';

part 'category.service.g.dart';

@RestApi(baseUrl: '//classfiy.onrender.com')
abstract class CategoryService {
  factory CategoryService(Dio dio, {String baseUrl}) = _CategoryService;

  @POST("/api/category-by-products")
  @FormUrlEncoded()
  Future<CategoryResModel> fetchCategory(@Field("category") String category);
}
*/

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/cloth/model/categoryResModel.dart';

part 'category.service.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class CategoryService {
  factory CategoryService(Dio dio, {String baseUrl}) = _CategoryService;

  @POST("/api/category-by-products")
  @FormUrlEncoded()
  Future<CategoryResModel> fetchCategory(
    @Field("category") String category,
    @Field("user_id") String userId,
  );
}
