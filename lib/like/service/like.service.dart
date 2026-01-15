import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/like/model/LikedPridurcsLisst.dart';
import 'package:shopping_app_olx/like/model/likeBodyModel.dart';
import 'package:shopping_app_olx/like/model/likeResModel.dart';
import 'package:shopping_app_olx/like/model/showlikeResModel.dart';

part 'like.service.g.dart';

@RestApi(baseUrl: 'https://classify.mymarketplace.co.in')
abstract class LikeService {
  factory LikeService(Dio dio, {String baseUrl}) = _LikeService;

  @POST("/api/like-toggle")
  Future<LikeResModel> like(@Body() LikeBodyModel body);

  @GET("/api/like-count?product_id={id}")
  Future<ShowlikeResModel> showlike(@Path("id") String id);
  @GET('/api/User-like/productget?user_id={id}')
  Future<LikesProductListModel> fetchLikedProducts(@Path('id') String id);
}
