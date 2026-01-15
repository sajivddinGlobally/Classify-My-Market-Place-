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
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/map/map.page.dart';
class FashionFormPage extends StatefulWidget {
  const FashionFormPage({super.key});

  @override
  State<FashionFormPage> createState() => _FashionFormPageState();
}

class _FashionFormPageState extends State<FashionFormPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  File? image;
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





  bool _didRedirect = false;

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
  bool isProperty = false;
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");
    Map<String, dynamic> data = {
      "title": titleController.text,
      "desc": descController.text,
      "name": nameController.text,
    };
    return Scaffold(
      body: SingleChildScrollView(
        child: SingleChildScrollView(
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
                      "Fashion Include some details",
                      style: GoogleFonts.dmSans(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15.h),
                        FormBody(
                          controller: nameController,
                          labeltxt: "Name *",
                          helper:
                              "Mention the key features of your item (eg. brand, model 0/70 age, type)",
                        ),
                        SizedBox(height: 15.h),
                        FormBody(
                          controller: titleController,
                          labeltxt: "Ad title*",
                          helper:
                              "Mention the key features of your item (eg. brand, model 0/70 age, type)",
                        ),
                        SizedBox(height: 15.h),
                        FormBody(
                          controller: descController,
                          labeltxt: "Describe what you are selling *",
                          helper:
                              "Include condition, features and reason for selling\nRequired Fields",
                          maxlenghts: 4096,
                        ),
                        SizedBox(height: 20.h),
                        FormBody(
                          controller: priceController,
                          labeltxt: "Price*",
                          helper:
                          "",
                          maxlenghts: 4096,
                        ),

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
                            try {
                              setState(() {
                                isProperty = true;
                              });
                              final apiserce = APIService(await createDio());
                              List<MultipartFile> imageFiles = [];
                              for (var img in images) {
                                imageFiles.add(await MultipartFile.fromFile(
                                  img.path,
                                  filename: img.path.split("/").last,
                                ));
                              }
                              await apiserce.addProduct({
                                "category": "Fashions",
                                "user_id": "${box.get("id")}",
                                // "image": await MultipartFile.fromFile(
                                //   image!.path,
                                //   filename: image!.path.split('/').last,
                                // ),
                                "price": priceController.text,
                                "images[]": imageFiles, // Changed from "image" to "images"
                                "latitude": latitude,
                                "longitude": longitude,
                                "json_data": jsonEncode({
                                  "title": titleController.text,
                                  "desc": descController.text,
                                  "name": nameController.text,
                                }),
                              });
                              Fluttertoast.showToast(
                                msg: "Product Add Successfull",
                              );
                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              log(e.toString());
                              setState(() {
                                isProperty = false;
                              });
                              Fluttertoast.showToast(msg: "Product Add Failed");
                            }
                          },
                          child: Center(
                            child:
                                isProperty == false
                                    ? Text(
                                      "Continue",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Center(
                                      child: CircularProgressIndicator(
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
      ),
    );
  }
}
*//*





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
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/map/map.page.dart';

import '../plan/plan.page.dart';

class FashionFormPage extends StatefulWidget {
  const FashionFormPage({super.key});

  @override
  State<FashionFormPage> createState() => _FashionFormPageState();
}

class _FashionFormPageState extends State<FashionFormPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  File? image;
  final picker = ImagePicker();
  List<XFile> images = [];

  // Validation error messages
  String? nameError;
  String? titleError;
  String? descError;
  String? priceError;
  String? imageError;

  Future<void> pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          images.add(pickedFile);
          imageError = null; // Clear image error when an image is added
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
            imageError = null; // Clear image error when images are added
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

  bool _didRedirect = false;

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

  // Validation function
  bool validateForm() {
    bool isValid = true;
    setState(() {
      nameError = nameController.text.trim().isEmpty
          ? "Name is required"
          : null;
      titleError = titleController.text.trim().isEmpty
          ? "Ad title is required"
          : null;
      descError = descController.text.trim().isEmpty
          ? "Description is required"
          : null;
      priceError = priceController.text.trim().isEmpty
          ? "Price is required"
          : double.tryParse(priceController.text) == null
          ? "Enter a valid price"
          : null;
      imageError = images.isEmpty ? "At least one image is required" : null;
    });

    if (nameError != null ||
        titleError != null ||
        descError != null ||
        priceError != null ||
        imageError != null) {
      isValid = false;
    }

    return isValid;
  }

  bool isProperty = false;

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
                    "Fashion Include some details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: nameController,
                        labeltxt: "Name *",
                        helper:
                        "Mention the key features of your item (eg. brand, model, age, type)",
                        errorText: nameError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: titleController,
                        labeltxt: "Ad title*",
                        helper:
                        "Mention the key features of your item (eg. brand, model, age, type)",
                        errorText: titleError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: descController,
                        labeltxt: "Describe what you are selling *",
                        helper:
                        "Include condition, features and reason for selling\nRequired Fields",
                        maxlenghts: 4096,
                        errorText: descError,
                      ),
                      SizedBox(height: 20.h),
                      FormBody(
                        controller: priceController,
                        labeltxt: "Price*",
                        helper: "",
                        maxlenghts: 4096,
                        errorText: priceError,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.h),
                      if (imageError != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Text(
                            imageError!,
                            style: TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                        ),
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
                                  width: 1.w),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.upload,
                                    color: imageError != null
                                        ? Colors.red
                                        : Colors.grey),
                                Text(
                                  "Upload Images",
                                  style: TextStyle(
                                      color: imageError != null
                                          ? Colors.red
                                          : Colors.grey),
                                ),
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
                                        color: Colors.grey, width: 1.w),
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

                          try {
                            setState(() {
                              isProperty = true;
                            });
                            final apiserce = APIService(await createDio());
                            List<MultipartFile> imageFiles = [];
                            for (var img in images) {
                              imageFiles.add(await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ));
                            }
                            await apiserce.addProduct({
                              "category": "Fashions",
                              "user_id": "${box.get("id")}",
                              "price": priceController.text,
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "json_data": jsonEncode({
                                "title": titleController.text,
                                "desc": descController.text,
                                "name": nameController.text,
                              }),
                            });
                            Fluttertoast.showToast(
                              msg: "Product Added Successfully",
                            );
                          */
/*  Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HomePage(),
                              ),
                                  (route) => false,
                            );*//*

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => PlanPage(),
                              ),
                            );


                          } catch (e) {
                            log(e.toString());
                            setState(() {
                              isProperty = false;
                            });
                            Fluttertoast.showToast(
                                msg: "Product Add Failed: $e");
                          }
                        },
                        child: Center(
                          child: isProperty
                              ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : Text(
                            "Continue",
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
}

// Updated FormBody widget to support error text
class FormBody extends StatelessWidget {
  final TextEditingController controller;
  final String labeltxt;
  final String helper;
  final int? maxlenghts;
  final String? errorText;
  final TextInputType? keyboardType;

  const FormBody({
    required this.controller,
    required this.labeltxt,
    required this.helper,
    this.maxlenghts,
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
          maxLength: maxlenghts,
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
        SizedBox(height: 5.h),
        Text(
          helper,
          style: GoogleFonts.dmSans(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
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
import 'package:shopping_app_olx/plan/plan.page.dart';

import '../new/new.service.dart';

class FashionFormPage extends ConsumerStatefulWidget {
  final SellList? productToEdit;

  const FashionFormPage({super.key, this.productToEdit});

  @override
  ConsumerState<FashionFormPage> createState() => _FashionFormPageState();
}

class _FashionFormPageState extends ConsumerState<FashionFormPage> {
  final fashionTypeController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
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
      fashionTypeController.text = jsonData['fashion_type'] ?? '';
      titleController.text = jsonData['title'] ?? '';
      descController.text = jsonData['desc'] ?? '';
      priceController.text = jsonData['price'] ?? '';
    }
    if (product.image != null && product.image!.isNotEmpty) {
      setState(() {
        existingImageUrls = product.image!.split(',').map((url) => url.trim()).toList();
      });
    }
  }

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
    final List<XFile> pickedImages =
    await picker.pickMultiImage(imageQuality: 70);

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
    if (fashionTypeController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the fashion type");
      isValid = false;
    }
    if (titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the ad title");
      isValid = false;
    }
    if (descController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the description");
      isValid = false;
    }
    if (priceController.text.trim().isEmpty ||
        double.tryParse(priceController.text.trim()) == null ||
        double.parse(priceController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid price");
      isValid = false;
    }
    if (!isEditing && images.isEmpty && existingImageUrls.isEmpty) {
      Fluttertoast.showToast(msg: "Please select at least one image");
      isValid = false;
    }
    return isValid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRedirect) return;
    final shouldRedirect = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    if (shouldRedirect) {
      _didRedirect = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapPage()));
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
                    isEditing ? "Update Fashion Listing" : "Fashion Listing",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormBody(
                        labeltxt: "Fashion Type*",
                        controller: fashionTypeController,
                        helper: "e.g., Dress, Jacket, Sneakers",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Ad Title*",
                        controller: titleController,
                        helper: "Mention key features (e.g., brand, size, condition)",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Description*",
                        controller: descController,
                        helper: "Include condition, material, and reason for selling",
                        maxLength: 4096,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Price*",
                        controller: priceController,
                        type: TextInputType.number,
                        helper: "Price in your currency",
                      ),
                      SizedBox(height: 20.h),
                      Container(
                        height: 216.h,
                        child: (images.isEmpty && existingImageUrls.isEmpty)
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
                              children: const [
                                Icon(Icons.upload),
                                Text("Upload Images"),
                              ],
                            ),
                          ),
                        )
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: existingImageUrls.length + images.length + 1,
                          itemBuilder: (context, index) {
                            if (index < existingImageUrls.length) {
                              return Stack(
                                children: [
                                  Container(
                                    width: 100.w,
                                    margin: EdgeInsets.only(right: 8.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: Image.network(
                                        existingImageUrls[index],
                                        height: 216.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
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
                                          existingImageUrls.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
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
                            } else if (index < existingImageUrls.length + images.length) {
                              final imageIndex = index - existingImageUrls.length;
                              return Stack(
                                children: [
                                  Container(
                                    width: 100.w,
                                    margin: EdgeInsets.only(right: 8.w),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
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
                                        padding: const EdgeInsets.all(4),
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
                                onTap: images.length + existingImageUrls.length < 5
                                    ? showImage
                                    : () {
                                  Fluttertoast.showToast(
                                    msg: "Maximum 5 images allowed",
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                },
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
                    /*  ElevatedButton(
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

                              "subcategory": "Fashions",
                              "category": "Fashion",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "fashion_type": fashionTypeController.text,
                                "title": titleController.text,
                                "desc": descController.text,
                                "price": priceController.text,
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
                                msg: "Fashion Listing Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(data);
                              Fluttertoast.showToast(
                                msg: "Fashion Listing Added Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => HomePage(),
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
                                  "You can only add one product every 24 hours.";
                            } else if (e is DioError) {
                              errorMessage = e.response?.data['message'] ??
                                  "Failed to process fashion listing. Please try again.";
                            }
                            Fluttertoast.showToast(
                              msg: errorMessage,
                              toastLength: Toast.LENGTH_LONG,
                            );
                            if (errorMessage.contains("You must purchase a plan")) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => PlanPage(true),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            }
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            isEditing ? "Update" : "Continue",
                            style: GoogleFonts.dmSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),*/

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(MediaQuery.of(context).size.width, 49.h),
                          backgroundColor: const Color.fromARGB(255, 137, 26, 255),
                        ),
                        onPressed: () async {
                          if (!_validateForm()) return;

                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');

                          // Images ko MultipartFile mein convert karo
                          List<MultipartFile> imageFiles = [];
                          for (var img in images) {
                            imageFiles.add(await MultipartFile.fromFile(
                              img.path,
                              filename: img.path.split("/").last,
                            ));
                          }

                          // Product data ready karo (PlanPage ke liye bhi use hoga)
                          final Map<String, dynamic> productData = {
                            "subcategory": "Fashions",
                            "category": "Fashion",
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": priceController.text,
                            "json_data": jsonEncode({
                              "fashion_type": fashionTypeController.text,
                              "title": titleController.text,
                              "desc": descController.text,
                              "price": priceController.text,
                            }),
                          };

                          // Editing mode mein existing images add karo
                          if (isEditing && widget.productToEdit != null && existingImageUrls.isNotEmpty) {
                            productData['existing_images'] = existingImageUrls.join(',');
                          }

                          try {
                            setState(() => isLoading = true);

                            final apiService = APIService(await createDio());

                            if (isEditing && widget.productToEdit != null) {
                              await apiService.updateProduct(widget.productToEdit!.id!, productData);
                              Fluttertoast.showToast(
                                msg: "Fashion Listing Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(productData);
                             
                              Fluttertoast.showToast(
                                msg: "Fashion Listing Added Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }

                            // Success → Home pe jao aur stack clear kar do
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(builder: (_) => HomePage()),
                                  (route) => false,
                            );
                          } catch (e) {
                            log("Error: ${e.toString()}");
                            setState(() => isLoading = false);

                            String errorMessage = "An error occurred. Please try again.";
                            bool needsPlan = false;

                            if (e is DioError) {
                              errorMessage = e.response?.data['message']?.toString() ??
                                  "Failed to process fashion listing.";

                              if (e.response?.statusCode == 429) {
                                errorMessage = "You can only add one product every 24 hours.";
                              }

                              // Plan/subscription related error detect karo
                              if (errorMessage.toLowerCase().contains("plan") ||
                                  errorMessage.toLowerCase().contains("purchase") ||
                                  errorMessage.toLowerCase().contains("subscription")) {
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
                                  builder: (context) => PlanPage(productData, true),
                                ),
                              );
                            } else {
                              // Normal error pe user current screen pe rehne do (ya Home bhej sakte ho)
                            }
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            isEditing ? "Update" : "Continue",
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
    fashionTypeController.dispose();
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }
}

class FormBody extends StatelessWidget {
  final String labeltxt;
  final String? helper;
  final int? maxLength;
  final TextEditingController controller;
  final TextInputType? type;
  final String? errorText;

  const FormBody({
    super.key,
    required this.labeltxt,
    this.helper,
    this.maxLength,
    this.type,
    required this.controller,
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
          keyboardType: type,
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