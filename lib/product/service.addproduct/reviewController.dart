import 'package:riverpod/riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/product/model.addproduct/reviewBodyModel.dart';
import 'package:shopping_app_olx/product/model.addproduct/reviewResModel.dart';
import 'package:shopping_app_olx/product/service.addproduct/reviewService.dart';

final reviewController = FutureProvider.family<ReviewResModel, ReviewBodyModel>(
  (ref, body) async {
    final reviewservice = ReviewService(await createDio());
    return reviewservice.reviewAdd(body);
  },
);
