import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/product/model.addproduct/specificationBodyModel.dart';
import 'package:shopping_app_olx/product/model.addproduct/specificationResModel.dart';
import 'package:shopping_app_olx/product/service.addproduct/specificationService.dart';

final specificationProvider = FutureProvider.family<
  ProductSpecificationResModel,
  ProductSpecificationBodyModel
>((ref, body) async {
  final specificationservice = SpecificationService(await createDio());
  return specificationservice.addSpecificationProduct(body);
});
