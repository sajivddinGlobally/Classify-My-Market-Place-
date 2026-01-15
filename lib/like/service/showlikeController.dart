import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/like/model/showlikeResModel.dart';
import 'package:shopping_app_olx/like/service/like.service.dart';

final showLikeCountProvider = FutureProvider.family
    .autoDispose<ShowlikeResModel, String>((ref, id) async {
      final serivce = LikeService(createDio());
      return serivce.showlike(id);
    });
