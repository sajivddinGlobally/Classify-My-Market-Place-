import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app_olx/model/active.plan.dart';
import 'package:shopping_app_olx/model/planModel.model.dart';

import 'CreatPlanResponseModel.dart';

part 'new.service.g.dart';

@RestApi(baseUrl: "https://classify.mymarketplace.co.in")
abstract class APIService {
  factory APIService(Dio dio, {String baseUrl}) = _APIService;

  @POST("/api/Add/product")
  @MultiPart() // ✅ VERY IMPORTANT
  Future<HttpResponse<dynamic>> addProduct(@Part() Map<String, dynamic> parts);

  @POST("/api/Add/product")
  @MultiPart() // ✅ VERY IMPORTANT
  Future<HttpResponse<dynamic>> productFormData(@Body() FormData data);

  @POST("/api/product/update")
  @MultiPart()
  Future<HttpResponse<dynamic>> updateProduct(
    @Query("id") int id,
    @Part() Map<String, dynamic> parts,
  );

  @POST("/api/product/update")
  @MultiPart()
  Future<HttpResponse<dynamic>> updateProductFormData(
    @Query("id") int id,
    @Body() FormData data,
  );

  @POST("/api/product/Delete")
  @MultiPart()
  Future<HttpResponse<dynamic>> deleteProduct(
    @Query("id") int id, // Add id as a query parameter
  );

  @GET("/api/plans")
  Future<PlanModel> getPlan();

  @POST("/api/payment/create")
  @MultiPart()
  Future<CreatePlanResponseModel> buyPlan({
    @Part(name: "user_id") required String user_id,
    @Part(name: "plan_id") required String plan_id,
    @Part(name: "amount") required int amount,
    @Part(name: "currency") required String currency,
    @Part(name: "description") required String description,
  });

  @POST("/api/buy-plan")
  @MultiPart()
  Future<HttpResponse<dynamic>> buyPlanSucees({
    @Part(name: "user_id") required String userId,
    @Part(name: "trnx_id") required String trnxId,
    @Part(name: "payment_type") required String paymentType,
    @Part(name: "status") required String status,
    @Part(name: "plan_id") required String planId,
  });

  @POST("/api/payment/verify")
  @MultiPart()
  Future<CreatePlanResponseModel> verify({
    @Part(name: "razorpay_payment_id") required String paymentId,
    @Part(name: "razorpay_order_id") required String orderId,
    @Part(name: "razorpay_signature") required String signature,
  });

  @GET("/api/user-active-wallet?user_id={id}")
  Future<ActivePlan?> getActivePlan(@Path('id') String id);
  @POST("/api/boost-post")
  @MultiPart()
  Future<HttpResponse<dynamic>> boostPost({
    @Part(name: "userid") required String userid,
    @Part(name: "plan_id") required String planId,
    @Part(name: "product_id") required String productId,
  });
}

/// how to use this api

// final file = await MultipartFile.fromFile(
//   'path/to/image.jpg',
//   filename: 'image.jpg',
//   contentType: MediaType('image', 'jpeg'), // Needs http_parser
// );

// final parts = {
//   'category': 'shirt',
//   'image': file,
//   'user_id': '12345',
//   'json_data': '{"price": 100}',
// };

// await apiService.addProduct(parts);

class BoostProductRequest {
  final String userid;
  final String planId;
  final String productId;

  BoostProductRequest({
    required this.userid,
    required this.planId,
    required this.productId,
  });

  Map<String, dynamic> toFormData() {
    return {'userid': userid, 'plan_id': planId, 'product_id': productId};
  }
}
