import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/listing/service/getlistingController.dart';
import 'package:shopping_app_olx/profile/Model/profileModel.dart';
import 'package:shopping_app_olx/profile/service/profileService.dart';

final profileController = FutureProvider.family
    .autoDispose<ProfileModel, String>((ref, id) async {
      final data = await Hive.box("data");
      final id = data.get('id');
      if (id == null) {
        throw UserNotLoggedInException();
      }
      final profileservice = ProfileService(await createDio());
      return profileservice.profile(id);
    });
