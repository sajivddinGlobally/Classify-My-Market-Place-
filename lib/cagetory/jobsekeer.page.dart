/*
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

class JobSeekerFormPage extends StatefulWidget {
  const JobSeekerFormPage({super.key});

  @override
  State<JobSeekerFormPage> createState() => _JobSeekerFormPageState();
}

class _JobSeekerFormPageState extends State<JobSeekerFormPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final preferredLocationController = TextEditingController();
  final skillsController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();

  bool _didRedirect = false;
  // List<File> images = [];
  final picker = ImagePicker();


  List<XFile> images = []; // Changed to List<XFile> for multiple images
  Future<void> pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          images.add(pickedFile);
        });
      }
    } else {
      print("Camera Permission is denied");
    }
  }





  Future<void> pickImageFromGallery() async {
    try {
      // Determine the appropriate permission based on Android version
      Permission permission;

      if (Platform.isAndroid && (await _getAndroidSdkVersion()) >= 30) {
        permission = Permission.photos; // Android 11 (API 30) and above
      } else {
        permission = Permission.storage; // Android 10 and below
      }

      // Check permission status
      var status = await permission.status;

      if (kDebugMode) {
        print("Initial permission status: $status");
      }

      if (!status.isGranted) {
        status = await permission.request();
        if (kDebugMode) {
          print("Requested permission status: $status");
        }
      }

      if (status.isGranted) {
        if (kDebugMode) {
          print("Opening gallery for multiple image selection");
        }
        final picker = ImagePicker();
        final pickedFiles = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );
        if (pickedFiles.isNotEmpty) {
          setState(() {
            images.addAll(pickedFiles.take(5 - images.length)); // Limit to 5 images
          });
          if (kDebugMode) {
            print("Selected ${pickedFiles.length} images: ${pickedFiles.map((e) => e.path).toList()}");
          }
          Fluttertoast.showToast(
            msg: "Selected ${pickedFiles.length} images",
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          if (kDebugMode) {
            print("No images selected from gallery");
          }
          Fluttertoast.showToast(
            msg: "No images selected",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else if (status.isDenied) {
        if (kDebugMode) {
          print("Permission denied");
        }
        Fluttertoast.showToast(
          msg: "Please grant permission to select images",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (status.isPermanentlyDenied) {
        if (kDebugMode) {
          print("Permission permanently denied");
        }
        Fluttertoast.showToast(
          msg: "Please enable permission in your device settings",
          toastLength: Toast.LENGTH_LONG,
        );
        await openAppSettings();
      } else {
        if (kDebugMode) {
          print("Unexpected permission status: $status");
        }
        Fluttertoast.showToast(
          msg: "Unable to access gallery due to permission issue",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error picking images: $e");
        print("Stack trace: $stackTrace");
      }
      Fluttertoast.showToast(
        msg: "Failed to pick images: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }
  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              pickImageFromCamera();
              Navigator.pop(context);
            },
            child: Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              pickImageFromGallery();
              Navigator.pop(context);
            },
            child: Text("Gallery"),
          ),
        ],
      ),
    );
  }

  bool loder = false;
  // bool _didRedirect = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didRedirect) return;

    final shouldRedirect =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    if (shouldRedirect) {
      _didRedirect = true;

      // Delay using Future.delayed to let UI settle before navigation
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            Image.asset("assets/bgimage.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Job Seeker\nEnter Your Details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: nameController,
                        labeltxt: "Full Name*",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: emailController,
                        labeltxt: "Email Address*",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: phoneController,
                        labeltxt: "Phone Number*",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: locationController,
                        labeltxt: "Current Location*",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: preferredLocationController,
                        labeltxt: "Preferred Job Location",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: skillsController,
                        labeltxt: "Skills*",
                        helper: "E.g., Python, Flutter, Communication",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: educationController,
                        labeltxt: "Highest Education*",
                        helper: "E.g., B.Sc. Computer Science - 2022",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: experienceController,
                        labeltxt: "Work Experience",
                        helper: "E.g., 2 years at Infosys as Developer",
                        maxlenghts: 1000,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: salaryController,
                        labeltxt: "Expected Salary",
                        helper: "In INR (e.g., 25000 per month)",
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Upload Resume Images (Optional)",
                        style: GoogleFonts.dmSans(fontSize: 14.sp),
                      ),
                      SizedBox(height: 10.h),

                      Container(
                        height: 216.h,
                        child: images.isEmpty
                            ? GestureDetector(
                          onTap: showImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 1.w),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload),
                                Text("Upload Images"),
                              ],
                            ),
                          ),
                        )
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length + 1,
                          itemBuilder: (context, index) {
                            if (index == images.length) {
                              return GestureDetector(
                                onTap: showImage,
                                child: Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.r),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey, width: 1.w),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add),
                                      Text("Add More"),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Stack(
                              children: [
                                Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.file(
                                      File(images[index].path),
                                      height: 216.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8.w,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        images.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 40.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: Color.fromARGB(255, 137, 26, 255),
                        ),
                        onPressed: () async {
                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');
                          setState(() {
                            loder = true;
                          });
                          final currentDate = DateTime.now();
                          final userid = box.get('id');
                          final date = box.get("postdate");
                          final planid = box.get("plan_id");
                          // final latitude = box.get('latitude');
                          // final longitude = box.get('longitude');
                          List<MultipartFile> imageFiles = [];
                          for (var img in images) {
                            imageFiles.add(await MultipartFile.fromFile(
                              img.path,
                              filename: img.path.split("/").last,
                            ));
                          }
                        */ /*

*/
/*  List<MultipartFile> multipartImages =
                              await Future.wait(
                                images.map((image) async {
                                  return await MultipartFile.fromFile(
                                    image.path,
                                    filename: image.path.split('/').last,
                                  );
                                }),
                              );*/ /*
 */
/*

                          log(
                            {
                              "category": "Jobs",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles, // Changed from "image" to "images"
                              "latitude": latitude,
                              "longitude": longitude,
                              // "images[]": multipartImages,
                              "price": salaryController.text,
                              // "latitude": latitude,
                              // "longitude": longitude,
                              "json_data": jsonEncode({
                                "full_name": nameController.text,
                                "email": emailController.text,
                                "phone": phoneController.text,
                                "current_location": locationController.text,
                                "preferred_location":
                                    preferredLocationController.text,
                                "skills": skillsController.text,
                                "education": educationController.text,
                                "experience": experienceController.text,
                              }),
                            }.toString(),
                          );
                          log(
                            "${currentDate.day}/${currentDate.month}/${currentDate.year}:::: $date",
                          );
                          if (date != null &&
                              date !=
                                  "${currentDate.day}/${currentDate.month}/${currentDate.year}") {
                            try {
                              final state = APIService(createDio());
                              final productAddResponse = await state.addProduct(
                                {
                                  "category": "Jobs",
                                  "user_id": "${box.get("id")}",
                                  "images[]": imageFiles, // Changed from "image" to "images"
                                  "latitude": latitude,
                                  "longitude": longitude,
                                  // "images[]": multipartImages,
                                  "price": salaryController.text,
                                  // "latitude": latitude,
                                  // "longitude": longitude,
                                  "json_data": jsonEncode({
                                    "full_name": nameController.text,
                                    "email": emailController.text,
                                    "phone": phoneController.text,
                                    "current_location": locationController.text,
                                    "preferred_location":
                                        preferredLocationController.text,
                                    "skills": skillsController.text,
                                    "education": educationController.text,
                                    "experience": experienceController.text,
                                  }),
                                },
                              );
                              final response = await state.boostPost(
                                userid: userid.toString(),
                                planId: planid.toString(),
                                productId:
                                    productAddResponse
                                        .response
                                        .data["product"]["id"]
                                        .toString(),
                              );
                              if (response.response.data["status"] == true) {
                                await box.put(
                                  "postdate",
                                  "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                                );
                                Fluttertoast.showToast(
                                  msg: "Boost succes fully",
                                );
                                setState(() {
                                  loder = false;
                                });
                              } else {
                                setState(() {
                                  loder = false;
                                });
                                Fluttertoast.showToast(
                                  msg:
                                      response.response.data["message"]
                                          .toString(),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                loder = false;
                              });
                              Fluttertoast.showToast(
                                msg: "No active plan found.",
                              );
                            }
                          } else if (date == null) {
                            try {
                              final state = APIService(createDio());
                              final productAddResponse = await state.addProduct(
                                {
                                  "category": "Jobs",
                                  "user_id": "${box.get("id")}",
                                  "images[]": imageFiles, // Changed from "image" to "images"
                                  "latitude": latitude,
                                  "longitude": longitude,

                                  "price": salaryController.text,

                                  "json_data": jsonEncode({
                                    "full_name": nameController.text,
                                    "email": emailController.text,
                                    "phone": phoneController.text,
                                    "current_location": locationController.text,
                                    "preferred_location":
                                        preferredLocationController.text,
                                    "skills": skillsController.text,
                                    "education": educationController.text,
                                    "experience": experienceController.text,
                                  }),
                                },
                              );

                              final response = await state.boostPost(
                                userid: userid.toString(),
                                planId: planid.toString(),
                                productId:
                                    productAddResponse
                                        .response
                                        .data["product"]["id"]
                                        .toString(),
                              );
                              if (response.response.data["status"] == true) {
                                setState(() {
                                  loder = false;
                                });
                                await box.put(
                                  "postdate",
                                  "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                                );
                                Fluttertoast.showToast(
                                  msg: "Boost succes fully",
                                );
                              } else {
                                setState(() {
                                  loder = false;
                                });
                                Fluttertoast.showToast(
                                  msg:
                                      response.response.data["message"]
                                          .toString(),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                loder = false;
                              });
                              Fluttertoast.showToast(
                                msg: "No active plan found.",
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: "Today post limit reache",
                            );
                          }
                        },
                        child:
                            loder
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Submit",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/ /*

*/
/*

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

class JobSeekerFormPage extends StatefulWidget {
  const JobSeekerFormPage({super.key});

  @override
  State<JobSeekerFormPage> createState() => _JobSeekerFormPageState();
}

class _JobSeekerFormPageState extends State<JobSeekerFormPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final preferredLocationController = TextEditingController();
  final skillsController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();

  final picker = ImagePicker();
  List<XFile> images = [];

  // Validation error messages
  String? nameError;
  String? emailError;
  String? phoneError;
  String? locationError;
  String? skillsError;
  String? educationError;
  String? salaryError;

  bool _didRedirect = false;
  bool loder = false;

  Future<void> pickImageFromCamera() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        images.add(photo);
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      Permission permission;
      if (Platform.isAndroid && (await _getAndroidSdkVersion()) >= 30) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }

      var status = await permission.status;
      if (kDebugMode) {
        print("Initial permission status: $status");
      }

      if (!status.isGranted) {
        status = await permission.request();
        if (kDebugMode) {
          print("Requested permission status: $status");
        }
      }

      if (status.isGranted) {
        final pickedFiles = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );
        if (pickedFiles.isNotEmpty) {
          setState(() {
            images.addAll(pickedFiles.take(5 - images.length));
          });
          Fluttertoast.showToast(
            msg: "Selected ${pickedFiles.length} images",
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: "No images selected",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else if (status.isDenied) {
        Fluttertoast.showToast(
          msg: "Please grant permission to select images",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (status.isPermanentlyDenied) {
        Fluttertoast.showToast(
          msg: "Please enable permission in your device settings",
          toastLength: Toast.LENGTH_LONG,
        );
        await openAppSettings();
      } else {
        Fluttertoast.showToast(
          msg: "Unable to access gallery due to permission issue",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error picking images: $e");
        print("Stack trace: $stackTrace");
      }
      Fluttertoast.showToast(
        msg: "Failed to pick images: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  pickImageFromCamera();
                  Navigator.pop(context);
                },
                child: Text("Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  pickImageFromGallery();
                  Navigator.pop(context);
                },
                child: Text("Gallery"),
              ),
            ],
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRedirect) return;
    final shouldRedirect =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    if (shouldRedirect) {
      _didRedirect = true;
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

  // Validation function
  bool validateForm() {
    bool isValid = true;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^\d{10}$'); // Assuming 10-digit phone number

    setState(() {
      nameError =
          nameController.text.trim().isEmpty ? "Full name is required" : null;

      emailError =
          emailController.text.trim().isEmpty
              ? "Email is required"
              : !emailRegex.hasMatch(emailController.text.trim())
              ? "Enter a valid email"
              : null;

      phoneError =
          phoneController.text.trim().isEmpty
              ? "Phone number is required"
              : !phoneRegex.hasMatch(phoneController.text.trim())
              ? "Enter a valid 10-digit phone number"
              : null;

      locationError =
          locationController.text.trim().isEmpty
              ? "Current location is required"
              : null;

      skillsError =
          skillsController.text.trim().isEmpty ? "Skills are required" : null;
      educationError =
          educationController.text.trim().isEmpty
              ? "Education is required"
              : null;

      salaryError =
          salaryController.text.trim().isEmpty
              ? null
              : double.tryParse(salaryController.text) == null
              ? "Enter a valid salary"
              : null;

    });

    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        locationError != null ||
        skillsError != null ||
        educationError != null ||
        salaryError != null) {
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            Image.asset("assets/bgimage.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Job Seeker\nEnter Your Details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: nameController,
                        labeltxt: "Full Name*",
                        errorText: nameError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: emailController,
                        labeltxt: "Email Address*",
                        errorText: emailError,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: phoneController,
                        labeltxt: "Phone Number*",
                        errorText: phoneError,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: locationController,
                        labeltxt: "Current Location*",
                        errorText: locationError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: preferredLocationController,
                        labeltxt: "Preferred Job Location",
                        helper: "E.g., Bangalore, Remote",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: skillsController,
                        labeltxt: "Skills*",
                        helper: "E.g., Python, Flutter, Communication",
                        errorText: skillsError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: educationController,
                        labeltxt: "Highest Education*",
                        helper: "E.g., B.Sc. Computer Science - 2022",
                        errorText: educationError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: experienceController,
                        labeltxt: "Work Experience",
                        helper: "E.g., 2 years at Infosys as Developer",
                        maxLength: 1000,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: salaryController,
                        labeltxt: "Expected Salary",
                        helper: "In INR (e.g., 25000 per month)",
                        errorText: salaryError,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Upload Resume Images (Optional)",
                        style: GoogleFonts.dmSans(fontSize: 14.sp),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 216.h,
                        child:
                            images.isEmpty
                                ? GestureDetector(
                                  onTap: showImage,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.upload),
                                        Text("Upload Images"),
                                      ],
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == images.length) {
                                      return GestureDetector(
                                        onTap: showImage,
                                        child: Container(
                                          width: 100.w,
                                          margin: EdgeInsets.only(right: 8.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15.r,
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.w,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add),
                                              Text("Add More"),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                    return Stack(
                                      children: [
                                        Container(
                                          width: 100.w,
                                          margin: EdgeInsets.only(right: 8.w),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              15.r,
                                            ),
                                            child: Image.file(
                                              File(images[index].path),
                                              height: 216.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8.w,
                                          top: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                images.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                      ),
                      SizedBox(height: 40.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: Color.fromARGB(255, 137, 26, 255),
                        ),
                        onPressed: () async {
                          if (!validateForm()) {
                            Fluttertoast.showToast(
                              msg: "Please fill all required fields correctly",
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }

                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');

                          if (latitude == null || longitude == null) {
                            Fluttertoast.showToast(
                              msg: "Location data is missing",
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }

                          setState(() {
                            loder = true;
                          });
                          final currentDate = DateTime.now();
                          final userid = box.get('id');
                          final date = box.get("postdate");
                          final planid = box.get("plan_id");

                          List<MultipartFile> imageFiles = [];
                          for (var img in images) {
                            imageFiles.add(
                              await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ),
                            );
                          }

                          try {
                            final state = APIService(createDio());
                            final productAddResponse = await state.addProduct({
                              "category": "Jobs",
                              "user_id": "$userid",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": salaryController.text,
                              "json_data": jsonEncode({
                                "full_name": nameController.text,
                                "email": emailController.text,
                                "phone": phoneController.text,
                                "current_location": locationController.text,
                                "preferred_location":
                                    preferredLocationController.text,
                                "skills": skillsController.text,
                                "education": educationController.text,
                                "experience": experienceController.text,
                              }),
                            });

                            final response = await state.boostPost(
                              userid: userid.toString(),
                              planId: planid.toString(),
                              productId:
                                  productAddResponse
                                      .response
                                      .data["product"]["id"]
                                      .toString(),
                            );

                            if (response.response.data["status"] == true) {
                              await box.put(
                                "postdate",
                                "${currentDate.day}/${currentDate.month}/${currentDate.year}",
                              );
                              Fluttertoast.showToast(
                                msg: "Profile submitted successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                              setState(() {
                                loder = false;
                              });
                            } else {
                              setState(() {
                                loder = false;
                              });
                              Fluttertoast.showToast(
                                msg:
                                    response.response.data["message"]
                                        .toString(),
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                          } catch (e) {
                            setState(() {
                              loder = false;
                            });
                            Fluttertoast.showToast(
                              msg: "Submission failed: $e",
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        },
                        child:
                            loder
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Submit",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Updated FormBody widget to support error text and keyboard type
class FormBody extends StatelessWidget {
  final TextEditingController controller;
  final String labeltxt;
  final String? helper;
  final int? maxLength;
  final String? errorText;
  final TextInputType? keyboardType;

  const FormBody({
    required this.controller,
    required this.labeltxt,
    this.helper,
    this.maxLength,
    this.errorText,
    this.keyboardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltxt,
          style: GoogleFonts.dmSans(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            errorText: errorText,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        if (helper != null) ...[
          SizedBox(height: 5.h),
          Text(
            helper!,
            style: GoogleFonts.dmSans(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}
*/ /*





import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

import '../home/home.page.dart';
import '../plan/plan.page.dart';

class JobSeekerFormPage extends StatefulWidget {
  const JobSeekerFormPage({super.key});

  @override
  State<JobSeekerFormPage> createState() => _JobSeekerFormPageState();
}

class _JobSeekerFormPageState extends State<JobSeekerFormPage> {
  final nameController = TextEditingController();
*/
/*  final emailController = TextEditingController();
  final phoneController = TextEditingController();*/ /*

  final locationController = TextEditingController();
  final preferredLocationController = TextEditingController();
  final skillsController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();

  final picker = ImagePicker();
  List<XFile> images = [];

  // Validation error messages
  String? nameError;
  String? emailError;
  String? phoneError;
  String? locationError;
  String? preferredLocationError;
  String? skillsError;
  String? educationError;
  String? experienceError;
  String? salaryError;
  String? imageError;

  bool _didRedirect = false;
  bool loder = false;

  Future<void> pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          images.add(pickedFile);
          imageError = null;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Camera permission denied");
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      Permission permission;
      if (Platform.isAndroid && (await _getAndroidSdkVersion()) >= 30) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }

      var status = await permission.status;
      if (kDebugMode) {
        print("Initial permission status: $status");
      }

      if (!status.isGranted) {
        status = await permission.request();
        if (kDebugMode) {
          print("Requested permission status: $status");
        }
      }

      if (status.isGranted) {
        final pickedFiles = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );
        if (pickedFiles.isNotEmpty) {
          setState(() {
            images.addAll(pickedFiles.take(5 - images.length));
            imageError = null;
          });
          Fluttertoast.showToast(
            msg: "Selected ${pickedFiles.length} images",
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: "No images selected",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else if (status.isDenied) {
        Fluttertoast.showToast(
          msg: "Please grant permission to select images",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (status.isPermanentlyDenied) {
        Fluttertoast.showToast(
          msg: "Please enable permission in your device settings",
          toastLength: Toast.LENGTH_LONG,
        );
        await openAppSettings();
      } else {
        Fluttertoast.showToast(
          msg: "Unable to access gallery due to permission issue",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error picking images: $e");
        print("Stack trace: $stackTrace");
      }
      Fluttertoast.showToast(
        msg: "Failed to pick images: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              pickImageFromCamera();
              Navigator.pop(context);
            },
            child: Text("Camera"),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              pickImageFromGallery();
              Navigator.pop(context);
            },
            child: Text("Gallery"),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRedirect) return;
    final shouldRedirect =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    if (shouldRedirect) {
      _didRedirect = true;
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

  // Updated validation function to make all fields mandatory
  bool validateForm() {
    bool isValid = true;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^\d{10}$');
    final salaryRegex = RegExp(r'^\d{1,10}(\.\d{1,2})?$');

    setState(() {
      nameError =
      nameController.text.trim().isEmpty ? "Full name is required" : null;

*/
/*      emailError = emailController.text.trim().isEmpty
          ? "Email is required"
          : !emailRegex.hasMatch(emailController.text.trim())
          ? "Enter a valid email"
          : null;

      phoneError = phoneController.text.trim().isEmpty
          ? "Phone number is required"
          : !phoneRegex.hasMatch(phoneController.text.trim())
          ? "Enter a valid 10-digit phone number"
          : null;*/ /*


      locationError = locationController.text.trim().isEmpty
          ? "Current location is required"
          : null;

      preferredLocationError = preferredLocationController.text.trim().isEmpty
          ? "Preferred job location is required"
          : null;

      skillsError = skillsController.text.trim().isEmpty
          ? "Skills are required"
          : skillsController.text.trim().length < 10
          ? "Skills must be at least 10 characters"
          : null;

      educationError = educationController.text.trim().isEmpty
          ? "Education is required"
          : educationController.text.trim().length < 10
          ? "Education details must be at least 10 characters"
          : null;

      experienceError = experienceController.text.trim().isEmpty
          ? "Work experience is required"
          : experienceController.text.trim().length < 10
          ? "Work experience must be at least 10 characters"
          : null;

      salaryError = salaryController.text.trim().isEmpty
          ? "Expected salary is required"
          : !salaryRegex.hasMatch(salaryController.text.trim())
          ? "Enter a valid salary (e.g., 25000 or 25000.00)"
          : double.parse(salaryController.text.trim()) <= 0
          ? "Salary must be greater than 0"
          : null;

      imageError = images.isEmpty ? "At least one image is required" : null;
    });

    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        locationError != null ||
        preferredLocationError != null ||
        skillsError != null ||
        educationError != null ||
        experienceError != null ||
        salaryError != null ||
        imageError != null) {
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            Image.asset("assets/bgimage.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Job Seeker\nEnter Your Details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: nameController,
                        labeltxt: "Full Name*",
                        errorText: nameError,
                      ),
                      SizedBox(height: 15.h),
                   */
/*   FormBody(
                        controller: emailController,
                        labeltxt: "Email Address*",
                        errorText: emailError,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: phoneController,
                        labeltxt: "Phone Number*",
                        errorText: phoneError,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                      ),*/ /*

                      SizedBox(height: 15.h),
                      FormBody(
                        controller: locationController,
                        labeltxt: "Current Location*",
                        errorText: locationError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: preferredLocationController,
                        labeltxt: "Preferred Job Location*",
                        helper: "E.g., Bangalore, Remote",
                        errorText: preferredLocationError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: skillsController,
                        labeltxt: "Skills*",
                        helper: "E.g., Python, Flutter, Communication",
                        errorText: skillsError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: educationController,
                        labeltxt: "Highest Education*",
                        helper: "E.g., B.Sc. Computer Science - 2022",
                        errorText: educationError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: experienceController,
                        labeltxt: "Work Experience*",
                        helper: "E.g., 2 years at Infosys as Developer",
                        errorText: experienceError,
                        maxLength: 1000,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: salaryController,
                        labeltxt: "Expected Salary*",
                        helper: "In INR (e.g., 25000 or 25000.00)",
                        errorText: salaryError,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Upload Resume Images*",
                        style: GoogleFonts.dmSans(fontSize: 14.sp),
                      ),
                      if (imageError != null) ...[
                        SizedBox(height: 5.h),
                        Text(
                          imageError!,
                          style: GoogleFonts.dmSans(
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                      SizedBox(height: 10.h),
                      Container(
                        height: 216.h,
                        child: images.isEmpty
                            ? GestureDetector(
                          onTap: showImage,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white,
                              border: Border.all(
                                color: imageError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.w,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload),
                                Text("Upload Images"),
                              ],
                            ),
                          ),
                        )
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length + 1,
                          itemBuilder: (context, index) {
                            if (index == images.length) {
                              return GestureDetector(
                                onTap: showImage,
                                child: Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(15.r),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add),
                                      Text("Add More"),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Stack(
                              children: [
                                Container(
                                  width: 100.w,
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(15.r),
                                    child: Image.file(
                                      File(images[index].path),
                                      height: 216.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8.w,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        images.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 40.h),


                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: Color.fromARGB(255, 137, 26, 255),
                        ),
                        onPressed: () async {
                          if (!validateForm()) {
                            Fluttertoast.showToast(
                              msg: "Please fill all required fields correctly",
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }

                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');

                          if (latitude == null || longitude == null) {
                            Fluttertoast.showToast(
                              msg: "Location data is missing",
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }

                          setState(() {
                            loder = true;
                          });
                          final currentDate = DateTime.now();
                          final userid = box.get('id');
                          final date = box.get("postdate");
                          final planid = box.get("plan_id");

                          List<MultipartFile> imageFiles = [];
                          for (var img in images) {
                            imageFiles.add(
                              await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ),
                            );
                          }

                          try {
                            final state = APIService(createDio());
                            final productAddResponse = await state.addProduct({
                              "category": "Jobs",
                              "user_id": "$userid",
                              "plan_id": planid,
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": salaryController.text,
                              "json_data": jsonEncode({
                                "full_name": nameController.text,
                                // "email": emailController.text,
                                // "phone": phoneController.text,
                                "current_location": locationController.text,
                                "preferred_location":
                                preferredLocationController.text,
                                "skills": skillsController.text,
                                "education": educationController.text,
                                "experience": experienceController.text,
                              }),
                            });
                            Fluttertoast.showToast(
                              msg: "Product Added Successfully",
                            );

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => PlanPage(),
                              ),
                            );
                          }
                          catch (e) {
                            log("Error: ${e.toString()}");


                            // Handle specific error messages
                            String errorMessage = "An error occurred. Please try again.";
                            if (e is DioError && e.response?.statusCode == 429) {
                              errorMessage = e.response?.data['message'] ?? "You can only add one product every 24 hours.";
                            } else if (e is DioError) {
                              errorMessage = e.response?.data['message'] ?? "Failed to add product. Please try again.";
                            }
                            Fluttertoast.showToast(msg: errorMessage);
                            // Navigate to PlanPage only for the plan purchase error
                            if (errorMessage.contains("You must purchase a plan before adding a product."))
                            {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => PlanPage(),
                                ),
                              );
                            }
                            else
                            {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                          }



                        },

                        child: loder
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Submit",
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),



                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Updated FormBody widget to support error text and keyboard type
class FormBody extends StatelessWidget {
  final TextEditingController controller;
  final String labeltxt;
  final String? helper;
  final int? maxLength;
  final String? errorText;
  final TextInputType? keyboardType;

  const FormBody({
    required this.controller,
    required this.labeltxt,
    this.helper,
    this.maxLength,
    super.key,
    this.errorText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltxt,
          style: GoogleFonts.dmSans(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            errorText: errorText,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
        if (helper != null) ...[
          SizedBox(height: 5.h),
          Text(
            helper!,
            style: GoogleFonts.dmSans(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ],
    );
  }
}*/

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/listing/model/getlistingModel.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/plan/plan.page.dart';

class JobSeekerFormPage extends ConsumerStatefulWidget {
  final SellList? productToEdit;

  const JobSeekerFormPage({super.key, this.productToEdit});

  @override
  ConsumerState<JobSeekerFormPage> createState() => _JobSeekerFormPageState();
}

class _JobSeekerFormPageState extends ConsumerState<JobSeekerFormPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final preferredLocationController = TextEditingController();
  final skillsController = TextEditingController();
  final educationController = TextEditingController();
  final experienceController = TextEditingController();
  final salaryController = TextEditingController();
  final picker = ImagePicker();
  List<XFile> images = [];
  List<String> existingImageUrls = [];
  bool isLoading = false;
  bool isEditing = false;
  bool _didRedirect = false;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      isEditing = true;
      _prefillForm(widget.productToEdit!);
    }
  }

  void _prefillForm(SellList product) {
    final jsonData = product.jsonData;
    if (jsonData != null) {
      nameController.text = jsonData['full_name'] ?? '';
      emailController.text = jsonData['email'] ?? '';
      phoneController.text = jsonData['phone'] ?? '';
      locationController.text = jsonData['current_location'] ?? '';
      preferredLocationController.text = jsonData['preferred_location'] ?? '';
      skillsController.text = jsonData['skills'] ?? '';
      educationController.text = jsonData['education'] ?? '';
      experienceController.text = jsonData['experience'] ?? '';
      salaryController.text = jsonData['salary'] ?? '';
    }
    if (product.image != null && product.image!.isNotEmpty) {
      setState(() {
        existingImageUrls =
            product.image!.split(',').map((url) => url.trim()).toList();
      });
    }
  }

  Future<void> pickImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        images.add(photo);
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final List<XFile> pickedImages = await picker.pickMultiImage(
      imageQuality: 70,
    );

    if (pickedImages.isNotEmpty) {
      setState(() {
        images.addAll(pickedImages);
      });
    }
  }

  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  void showImage() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  bool _validateForm() {
    bool isValid = true;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^\d{10}$');
    final salaryRegex = RegExp(r'^\d{1,10}(\.\d{1,2})?$');

    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Full name is required");
      isValid = false;
    }
    if (emailController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Email is required");
      isValid = false;
    } else if (!emailRegex.hasMatch(emailController.text.trim())) {
      Fluttertoast.showToast(msg: "Enter a valid email");
      isValid = false;
    }
    if (phoneController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Phone number is required");
      isValid = false;
    } else if (!phoneRegex.hasMatch(phoneController.text.trim())) {
      Fluttertoast.showToast(msg: "Enter a valid 10-digit phone number");
      isValid = false;
    }
    if (locationController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Current location is required");
      isValid = false;
    }
    if (preferredLocationController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Preferred job location is required");
      isValid = false;
    }
    if (skillsController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Skills are required");
      isValid = false;
    } else if (skillsController.text.trim().length < 10) {
      Fluttertoast.showToast(msg: "Skills must be at least 10 characters");
      isValid = false;
    }
    if (educationController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Education is required");
      isValid = false;
    } else if (educationController.text.trim().length < 10) {
      Fluttertoast.showToast(
        msg: "Education details must be at least 10 characters",
      );
      isValid = false;
    }
    if (experienceController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Work experience is required");
      isValid = false;
    } else if (experienceController.text.trim().length < 10) {
      Fluttertoast.showToast(
        msg: "Work experience must be at least 10 characters",
      );
      isValid = false;
    }
    if (salaryController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Expected salary is required");
      isValid = false;
    } else if (!salaryRegex.hasMatch(salaryController.text.trim())) {
      Fluttertoast.showToast(
        msg: "Enter a valid salary (e.g., 25000 or 25000.00)",
      );
      isValid = false;
    } else if (double.parse(salaryController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Salary must be greater than 0");
      isValid = false;
    }
    if (!isEditing && images.isEmpty && existingImageUrls.isEmpty) {
      Fluttertoast.showToast(msg: "At least one image is required");
      isValid = false;
    }
    return isValid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRedirect) return;
    final shouldRedirect =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    if (shouldRedirect) {
      _didRedirect = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            Image.asset("assets/bgimage.png"),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46.w,
                      height: 46.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: Text(
                    isEditing
                        ? "Update Job Seeker Profile"
                        : "Job Seeker Profile",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBody(
                        controller: nameController,
                        labeltxt: "Full Name*",
                        helper: "Enter your full name",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: emailController,
                        labeltxt: "Email Address*",
                        helper: "e.g., example@domain.com",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: phoneController,
                        labeltxt: "Phone Number*",
                        helper: "e.g., 9876543210",
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: locationController,
                        labeltxt: "Current Location*",
                        helper: "e.g., Mumbai, Maharashtra",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: preferredLocationController,
                        labeltxt: "Preferred Job Location*",
                        helper: "e.g., Bangalore, Remote",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: skillsController,
                        labeltxt: "Skills*",
                        helper: "e.g., Python, Flutter, Communication",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: educationController,
                        labeltxt: "Highest Education*",
                        helper: "e.g., B.Sc. Computer Science - 2022",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: experienceController,
                        labeltxt: "Work Experience*",
                        helper: "e.g., 2 years at Infosys as Developer",
                        maxLength: 1000,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: salaryController,
                        labeltxt: "Expected Salary*",
                        helper: "In INR (e.g., 25000 or 25000.00)",
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Upload Resume Images*",
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 216.h,
                        child:
                            (images.isEmpty && existingImageUrls.isEmpty)
                                ? GestureDetector(
                                  onTap: showImage,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.white,
                                      border: Border.all(
                                        color:
                                            isEditing &&
                                                    existingImageUrls.isNotEmpty
                                                ? Colors.grey
                                                : Colors.red,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.upload),
                                        Text("Upload Images"),
                                      ],
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      existingImageUrls.length +
                                      images.length +
                                      1,
                                  itemBuilder: (context, index) {
                                    if (index < existingImageUrls.length) {
                                      return Stack(
                                        children: [
                                          Container(
                                            width: 100.w,
                                            margin: EdgeInsets.only(right: 8.w),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              child: Image.network(
                                                existingImageUrls[index],
                                                height: 216.h,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons.error,
                                                      size: 50,
                                                      color: Colors.red,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 8.w,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  existingImageUrls.removeAt(
                                                    index,
                                                  );
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else if (index <
                                        existingImageUrls.length +
                                            images.length) {
                                      final imageIndex =
                                          index - existingImageUrls.length;
                                      return Stack(
                                        children: [
                                          Container(
                                            width: 100.w,
                                            margin: EdgeInsets.only(right: 8.w),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              child: Image.file(
                                                File(images[imageIndex].path),
                                                height: 216.h,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 8.w,
                                            top: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  images.removeAt(imageIndex);
                                                });
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap:
                                            images.length +
                                                        existingImageUrls
                                                            .length <
                                                    5
                                                ? showImage
                                                : () {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Maximum 5 images allowed",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                  );
                                                },
                                        child: Container(
                                          width: 100.w,
                                          margin: EdgeInsets.only(right: 8.w),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15.r,
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.w,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.add),
                                              Text("Add More"),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                      ),
                      SizedBox(height: 40.h),
                      /* ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: const Color.fromARGB(255, 137, 26, 255),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (!_validateForm()) {
                            return;
                          }
                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');
                          if (latitude == null || longitude == null) {
                            Fluttertoast.showToast(
                              msg: "Location data is missing",
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final apiService = APIService(await createDio());
                            List<MultipartFile> imageFiles = [];
                            for (var img in images) {
                              imageFiles.add(await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ));
                            }
                            final data = {

                              "subcategory": "JobsSeeker",
                              "category": "JobsSeeker",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": salaryController.text,
                              "json_data": jsonEncode({
                                "full_name": nameController.text,
                                "email": emailController.text,
                                "phone": phoneController.text,
                                "current_location": locationController.text,
                                "preferred_location": preferredLocationController.text,
                                "skills": skillsController.text,
                                "education": educationController.text,
                                "experience": experienceController.text,
                                "salary": salaryController.text,
                              }),
                            };
                            if (isEditing && widget.productToEdit != null) {
                              if (existingImageUrls.isNotEmpty) {
                                data['existing_images'] = existingImageUrls.join(',');
                              }
                              await apiService.updateProduct(
                                widget.productToEdit!.id!,
                                data,
                              );
                              Fluttertoast.showToast(
                                msg: "Job Seeker Profile Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(data);
                              Fluttertoast.showToast(
                                msg: "Job Seeker Profile Added Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } catch (e) {
                            log("Error: ${e.toString()}");
                            setState(() {
                              isLoading = false;
                            });
                            String errorMessage = "An error occurred. Please try again.";
                            if (e is DioError && e.response?.statusCode == 429) {
                              errorMessage = e.response?.data['message'] ??
                                  "You can only add one profile every 24 hours.";
                            } else if (e is DioError) {
                              errorMessage = e.response?.data['message'] ??
                                  "Failed to process profile. Please try again.";
                            }
                            Fluttertoast.showToast(
                              msg: errorMessage,
                              toastLength: Toast.LENGTH_LONG,
                            );
                            if (errorMessage.contains("You must purchase a plan")) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>  PlanPage(true),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          }
                        },
                        child: isLoading
                            ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          isEditing ? "Update" : "Submit",
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),*/
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            137,
                            26,
                            255,
                          ),
                        ),
                        onPressed: () async {
                          if (!_validateForm()) return;

                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');

                          if (latitude == null || longitude == null) {
                            Fluttertoast.showToast(
                              msg: "Location data is missing",
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }

                          // Images ko MultipartFile mein convert karo
                          List<MultipartFile> imageFiles = [];
                          for (var img in images) {
                            imageFiles.add(
                              await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ),
                            );
                          }

                          // Product data ready karo (PlanPage ke liye reuse)
                          final Map<String, dynamic> productData = {
                            "subcategory": "JobsSeeker",
                            "category": "JobsSeeker",
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": salaryController.text,
                            "json_data": jsonEncode({
                              "full_name": nameController.text,
                              "email": emailController.text,
                              "phone": phoneController.text,
                              "current_location": locationController.text,
                              "preferred_location":
                                  preferredLocationController.text,
                              "skills": skillsController.text,
                              "education": educationController.text,
                              "experience": experienceController.text,
                              "salary": salaryController.text,
                            }),
                          };

                          // Editing mode mein existing images add karo
                          if (isEditing &&
                              widget.productToEdit != null &&
                              existingImageUrls.isNotEmpty) {
                            productData['existing_images'] = existingImageUrls
                                .join(',');
                          }

                          try {
                            setState(() => isLoading = true);

                            final apiService = APIService(await createDio());

                            if (isEditing && widget.productToEdit != null) {
                              await apiService.updateProduct(
                                widget.productToEdit!.id!,
                                productData,
                              );
                              Fluttertoast.showToast(
                                msg: "Job Seeker Profile Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(productData);
                              Fluttertoast.showToast(
                                msg: "Job Seeker Profile Added Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }

                            // Success → Home pe jao aur stack clear kar do
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            log("Error: ${e.toString()}");
                            setState(() => isLoading = false);

                            String errorMessage =
                                "An error occurred. Please try again.";
                            bool needsPlan = false;

                            if (e is DioError) {
                              errorMessage =
                                  e.response?.data['message']?.toString() ??
                                  "Failed to process profile.";

                              if (e.response?.statusCode == 429) {
                                errorMessage =
                                    "You can only add one profile every 24 hours.";
                              }

                              // Plan/subscription related error detect karo
                              if (errorMessage.toLowerCase().contains("plan") ||
                                  errorMessage.toLowerCase().contains(
                                    "purchase",
                                  ) ||
                                  errorMessage.toLowerCase().contains(
                                    "subscription",
                                  )) {
                                needsPlan = true;
                              }
                            }

                            Fluttertoast.showToast(
                              msg: errorMessage,
                              toastLength: Toast.LENGTH_LONG,
                            );

                            if (needsPlan) {
                              // PlanPage pe pending productData pass kar do
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder:
                                      (context) => PlanPage(productData, true),
                                ),
                              );
                            } else {
                              // Normal error pe user current screen pe rehne do (optional: Home bhej sakte ho)
                            }
                          }
                        },
                        child: Center(
                          child:
                              isLoading
                                  ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    isEditing ? "Update" : "Submit",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    preferredLocationController.dispose();
    skillsController.dispose();
    educationController.dispose();
    experienceController.dispose();
    salaryController.dispose();
    super.dispose();
  }
}

class FormBody extends StatelessWidget {
  final String labeltxt;
  final String? helper;
  final int? maxLength;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? errorText;

  const FormBody({
    super.key,
    required this.labeltxt,
    this.helper,
    this.maxLength,
    required this.controller,
    this.keyboardType,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltxt,
          style: GoogleFonts.dmSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 36, 33, 38),
          ),
        ),
        SizedBox(height: 5.h),
        TextField(
          controller: controller,
          maxLength: maxLength,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: helper ?? labeltxt,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
