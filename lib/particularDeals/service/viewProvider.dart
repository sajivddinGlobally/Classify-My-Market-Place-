import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../config/pretty.dio.dart';

class ViewClass {
  static final Dio _dio = createDio();
  // make _dio static
  static Future<Map<String, dynamic>?> fetchProduct({
    required String userId,
    required String productId,
  }) async {
    try {
      final response = await _dio.post(
        //  'https://classified.globallywebsolutions.com/api/product/view',
        "https://classify.mymarketplace.co.in/api/product/view",
        data: {'user_id': userId, 'product_id': productId},
      );
      if (response.statusCode == 200 && response.data['status'] == true) {
        return response.data['data'];
      } else {
        // Fluttertoast.showToast(msg: response.data['message'] ?? 'Unknown error');
        return null;
      }
    } catch (e, st) {
      log('API ERROR:', error: e, stackTrace: st);
      // Fluttertoast.showToast(msg: "Something went wrong");
      return null;
    }
  }
}
