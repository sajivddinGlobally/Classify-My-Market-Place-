import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/particularDeals/model/particularProductModel.dart';
import 'package:shopping_app_olx/particularDeals/service/particularProductService.dart';

final particularController =
    FutureProvider.family<ParticularProductModel, ({String id, String userId})>(
      (ref, params) async {
        final particularService = ParticularProductService(await createDio());
        return particularService.particularProduct(params.id, params.userId);
      },
    );
