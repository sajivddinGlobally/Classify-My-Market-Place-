import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/model/allCategoryModel.dart';
import 'package:shopping_app_olx/home/model/homepageModel.dart';
import 'package:shopping_app_olx/home/service/homepage.service.dart';

import 'package:geolocator/geolocator.dart';

final homepageController = FutureProvider<HomepageModel>((ref) async {
  var box = Hive.box("data");
  var user_id = box.get("id");
  final location = await printCurrentLocation();
  final homepageservice = HomePageService(await createDio());
  return homepageservice.home(
    '${location?.latitude}',
    '${location?.longitude}',
    user_id,
  );
});

final allCategoryController = FutureProvider<AllCategoryModel>((ref) async {
  final categoryService = HomePageService(await createDio());
  return categoryService.allCategory();
});

Future<LocationModel?> printCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return null;
  }

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied.');
    return null;
  }

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  print('Latitude: ${position.latitude}');
  print('Longitude: ${position.longitude}');
  return LocationModel(
    latitude: position.latitude.toString(),
    longitude: position.longitude.toString(),
  );
}

class LocationModel {
  final String latitude;
  final String longitude;

  LocationModel({required this.latitude, required this.longitude});
}
