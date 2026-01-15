import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/new/new.service.dart';

final planProvider = FutureProvider((ref) async {
  final state = APIService(await createDio());
  return state.getPlan();
});


final activePlanProvider = FutureProvider((ref) async {
  final box = Hive.box('data');
  final userid = box.get('id');
  final state = APIService(createDio());
  return state.getActivePlan(userid);
});

