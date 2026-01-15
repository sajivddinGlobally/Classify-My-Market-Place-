import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


void showLocationSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: const Text(
          'Location Selection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Before adding a post, you need to choose where your ad will be displayed. Your ad will be visible within a 2 km radius of that location. Thank you!',
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 16.sp,
            color: const Color.fromARGB(255, 36, 33, 38),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Add navigation or further action here (e.g., to MapPage)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 137, 26, 255),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  late LatLng _currentPosition;
  LatLng? _selectedPosition;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();


  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: 'Current Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    print('Latitude: ${position.target.latitude}, Longitude: ${position.target.longitude}');
  }

  void _onTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selectedLocation'),
          position: position,
          infoWindow: const InfoWindow(title: 'Selected Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      _circles.clear();
      _circles.add(
        Circle(
          circleId: const CircleId('radius'),
          center: position,
          radius: 2000, // 2 km in meters
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      );
      print('Selected Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    });
  }

  void _goToCurrentLocation() {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(414, 896));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Map with Radius',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(20.5937, 78.9629), // Default to India center
          zoom: 1,
        ),
        onCameraMove: _onCameraMove,
        onTap: _onTap,
        markers: _markers,
        circles: _circles,
        myLocationEnabled: true,
        myLocationButtonEnabled: false, // Custom button instead
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentLocation,
        backgroundColor: Colors.green[700],
        child: Icon(Icons.my_location, size: 28.sp),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}