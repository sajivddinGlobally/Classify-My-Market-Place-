import 'dart:developer';

import 'package:riverpod/riverpod.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/map/model/locationBodyModel.dart';
import 'package:shopping_app_olx/map/model/locationResModel.dart';
import 'package:shopping_app_olx/map/service/locationService.dart';

//providers/location_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

final locationController =
    FutureProvider.family<LocationResModel, LocationBodyModel>((
      ref,
      body,
    ) async {
      final locationservice = LocationService(await createDio());
      return locationservice.fetchLocation(body);
    });
//////////////////////////////////

final locationProvider = FutureProvider<String>((ref) async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    log(place.street.toString());
    return "${place.name}, ${place.locality}, ${place.administrativeArea} , ${place.country}";
  } else {
    return "Location not found";
  }
}
);
