import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/choseMap/controller/locationNotifer.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  String _address = 'Loading';
  MapType _currentMapType = MapType.normal;
  double manuelLat = 0.0;
  double manuelLong = 0.0;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};
  bool isLocation = false;

  @override
  void initState() {
    super.initState();
    _checkIfLocationAlreadySelected();
    _getPermissionAndLocation();
  }

  void _checkIfLocationAlreadySelected() async {
    var box = Hive.box("data");
    log(box.get("location_selected").toString());
    if (box.get("location_selected") != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Location Already Selected"),
                content: const Text(
                  "You have already selected your location. You can't change it again",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        ).then((_) {
          Navigator.pop(context); // exit page
        });
      }
    }
  }

  Future<void> _getPermissionAndLocation() async {
    await Permission.location.request();
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng latLng = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = latLng;
        _updateMarkerAndCircle(latLng);
      });
      _getAddressFromLatLng(latLng);
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          manuelLat = latLng.latitude;
          manuelLong = latLng.longitude;
          _address =
              "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      }
    } catch (e) {
      log("Error fetching address: $e");
      setState(() {
        _address = "Address not found";
      });
    }
  }

  void _updateMarkerAndCircle(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: position,
          infoWindow: const InfoWindow(title: 'You are here'),
          draggable: true,
          onDragEnd: (newPosition) {
            _currentLocation = newPosition;
            _updateMarkerAndCircle(newPosition);
            _getAddressFromLatLng(newPosition);
          },
        ),
      );
      _circles.clear();
      _circles.add(
        Circle(
          circleId: const CircleId('radius'),
          center: position,
          radius: 2000,
          fillColor: Colors.blue.withOpacity(0.3),
          strokeColor: Colors.blue.withOpacity(0.3),
          strokeWidth: 2,
        ),
      );
    });
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal
              ? MapType.satellite
              : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child:
                _currentLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentLocation!,
                            zoom: 13,
                          ),
                          mapType: _currentMapType,
                          markers: _markers,
                          circles: _circles,
                          myLocationEnabled: true,
                          onMapCreated:
                              (controller) => _mapController = controller,
                          onTap: (latLng) {
                            setState(() {
                              _currentLocation = latLng;
                              _updateMarkerAndCircle(latLng);
                            });
                            _getAddressFromLatLng(latLng);
                          },
                        ),
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: FloatingActionButton(
                            onPressed: _toggleMapType,
                            backgroundColor: Colors.blue[200],
                            child: const Icon(Icons.layers),
                          ),
                        ),
                      ],
                    ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: const Color.fromARGB(255, 245, 242, 247),
              child: Padding(
                padding: EdgeInsets.only(top: 40.h, right: 20.w, left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Pincode",
                      style: GoogleFonts.dmSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 36, 33, 38),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15.h, left: 15.w),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(30.45.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(30.45.r),
                          borderSide: BorderSide.none,
                        ),
                        hintText:
                            _address.isNotEmpty
                                ? _address
                                : "Fetching address...",
                        hintStyle: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 36, 33, 38),
                        ),
                        suffixIcon: Icon(
                          Icons.my_location,
                          color: const Color.fromARGB(255, 137, 26, 255),
                          size: 25.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "2 km Radius Active",
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // GestureDetector(
                    //   onTap: () async {
                    //     log("hhhuh");
                    //     setState(() {
                    //       isLocation = true;
                    //     });
                    //
                    //     if (_currentLocation != null) {
                    //       log("jjjj");
                    //       if (box.get("location_selected") == null) {
                    //         await box.put("location_selected", true);
                    //         await box.put("latitude", _currentLocation!.latitude);
                    //         await box.put("longitude", _currentLocation!.longitude);
                    //         ref.read(locationNotifer.notifier).updateLocation(
                    //               lat: _currentLocation!.latitude.toString(),
                    //               long: _currentLocation!.longitude.toString(),
                    //             );
                    //         Fluttertoast.showToast(msg: "Location saved!");
                    //         Navigator.pop(context);
                    //       } else {
                    //         Fluttertoast.showToast(
                    //             msg:
                    //                 "Location already selected. Cannot change.");
                    //       }
                    //     }
                    //
                    //     setState(() {
                    //       isLocation = false;
                    //     });
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 49.h,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(35.45.r),
                    //       border: Border.all(
                    //         color: const Color.fromARGB(255, 137, 26, 255),
                    //         width: 1.sp,
                    //       ),
                    //     ),
                    //     child: Center(
                    //       child: isLocation == false
                    //           ? Text(
                    //               "Confirm Location",
                    //               style: GoogleFonts.dmSans(
                    //                 fontSize: 15.sp,
                    //                 fontWeight: FontWeight.w500,
                    //                 color:
                    //                     const Color.fromARGB(255, 137, 26, 255),
                    //               ),
                    //             )
                    //           : const CircularProgressIndicator(
                    //               color: Color.fromARGB(255, 137, 26, 255),
                    //             ),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        if (_currentLocation != null) {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text("Confirm Location"),
                                  content: const Text(
                                    "Are you sure you want to select this location? You won't be able to change it later.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.pop(context), // Cancel
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(
                                          context,
                                        ); // Close the dialog
                                        setState(() {
                                          isLocation = true;
                                        });

                                        log("hhhuh");
                                        if (box.get("location_selected") ==
                                            null) {
                                          await box.put(
                                            "location_selected",
                                            true,
                                          );
                                          await box.put(
                                            "latitude",
                                            _currentLocation!.latitude,
                                          );
                                          await box.put(
                                            "longitude",
                                            _currentLocation!.longitude,
                                          );
                                          ref
                                              .read(locationNotifer.notifier)
                                              .updateLocation(
                                                lat:
                                                    _currentLocation!.latitude
                                                        .toString(),
                                                long:
                                                    _currentLocation!.longitude
                                                        .toString(),
                                              );
                                          Fluttertoast.showToast(
                                            msg: "Location saved!",
                                          );
                                          Navigator.pop(
                                            context,
                                          ); // Exit the page
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Location already selected. Cannot change.",
                                          );
                                        }

                                        setState(() {
                                          isLocation = false;
                                        });
                                      },
                                      child: const Text("Confirm"),
                                    ),
                                  ],
                                ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 49.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.45.r),
                          border: Border.all(
                            color: const Color.fromARGB(255, 137, 26, 255),
                            width: 1.sp,
                          ),
                        ),
                        child: Center(
                          child:
                              isLocation == false
                                  ? Text(
                                    "Confirm Location",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                        255,
                                        137,
                                        26,
                                        255,
                                      ),
                                    ),
                                  )
                                  : const CircularProgressIndicator(
                                    color: Color.fromARGB(255, 137, 26, 255),
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
