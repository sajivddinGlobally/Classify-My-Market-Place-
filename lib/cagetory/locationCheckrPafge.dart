import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/login/login.page.dart';

class LocationModel {
  final String latitude;
  final String longitude;

  LocationModel({required this.latitude, required this.longitude});
}

class LocationPermissionPage extends StatefulWidget {
  const LocationPermissionPage({super.key});

  @override
  State<LocationPermissionPage> createState() => _LocationPermissionPageState();
}

class _LocationPermissionPageState extends State<LocationPermissionPage> {
  @override
  void initState() {
    super.initState();
    _checkLocationAndNavigate();
  }

/*  Future<void> _checkLocationAndNavigate() async {
    final location = await _getCurrentLocation();
    if (location != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }*/
  Future<void> _checkLocationAndNavigate() async {
    final location = await _getCurrentLocation();
    if (location != null && mounted) {
      var box = Hive.box("data");
      var token = box.get("token");

      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }


  Future<LocationModel?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackBar('Location services are disabled. Please enable them.');
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Permission permanently denied. Please enable in settings.');
      await Geolocator.openAppSettings();
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LocationModel(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );
    } catch (e) {
      _showSnackBar('Failed to get location: $e');
      return null;
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(size: 100),
      ),
    );
  }
}
