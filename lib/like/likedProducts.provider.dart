

import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/like/service/like.service.dart';


final likedProductsProvider = FutureProvider((ref) async {
  final box = await Hive.box('data');
  final id = box.get('id');
final state = LikeService(await createDio());
return await state.fetchLikedProducts(id);
});