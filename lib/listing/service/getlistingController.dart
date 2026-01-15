import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/globalkey/navigatorkey.dart';
import 'package:shopping_app_olx/listing/service/getlisting.service.dart';

final listingController = FutureProvider((ref) async {
  final data = await Hive.box("data");
  final id = data.get('id');
  if (id == null) {
    throw UserNotLoggedInException();
  }
  final getlistingservice = GetListingService(await createDio());
  return getlistingservice.fetchListing(id);
}
);

class UserNotLoggedInException implements Exception {}