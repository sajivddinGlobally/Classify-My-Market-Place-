/*




import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource, XFile;
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/cagetory/new.plan.page.dart';
import 'package:shopping_app_olx/choseMap/controller/locationNotifer.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

import '../plan/plan.page.dart';

class GuesthouseFormPage extends ConsumerStatefulWidget {
  const GuesthouseFormPage({super.key});

  @override
  ConsumerState<GuesthouseFormPage> createState() => _GuesthouseFormPageState();
}

class _GuesthouseFormPageState extends ConsumerState<GuesthouseFormPage> {
  final projectControler = TextEditingController();
  final listedControlelr = TextEditingController();
  final superbuildController = TextEditingController();
  final carpetControlelr = TextEditingController();
  final maintanceController = TextEditingController();
  final furnisingController = TextEditingController();
  final carparkingContrller = TextEditingController();
  final washrommController = TextEditingController();
  final titleControler = TextEditingController();
  final desContrler = TextEditingController();
  final projectName = TextEditingController();
  final priceController = TextEditingController();
  List<XFile> images = [];
  final picker = ImagePicker();
  bool isLoading = false;
  bool _didRedirect = false;

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
      Permission permission =
      Platform.isAndroid && (await _getAndroidSdkVersion()) >= 30
          ? Permission.photos
          : Permission.storage;
      var status = await permission.request();
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
      } else if (status.isPermanentlyDenied) {
        Fluttertoast.showToast(
          msg: "Please enable permission in your device settings",
          toastLength: Toast.LENGTH_LONG,
        );
        await openAppSettings();
      } else {
        Fluttertoast.showToast(
          msg: "Please grant permission to select images",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
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
    if (furnisingController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the furnishing status");
      return false;
    }

    if (projectControler.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the project status");
      return false;
    }
    if (listedControlelr.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter who listed the property");
      return false;
    }
    if (superbuildController.text.trim().isEmpty ||
        double.tryParse(superbuildController.text.trim()) == null ||
        double.parse(superbuildController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid super built-up area");
      return false;
    }
    if (carpetControlelr.text.trim().isEmpty ||
        double.tryParse(carpetControlelr.text.trim()) == null ||
        double.parse(carpetControlelr.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid carpet area");
      return false;
    }
    if (maintanceController.text.trim().isEmpty ||
        double.tryParse(maintanceController.text.trim()) == null ||
        double.parse(maintanceController.text.trim()) < 0) {
      Fluttertoast.showToast(
          msg: "Please enter a valid maintenance amount (0 or positive)");
      return false;
    }

    if (carparkingContrller.text.trim().isEmpty ||
        int.tryParse(carparkingContrller.text.trim()) == null ||
        int.parse(carparkingContrller.text.trim()) < 0) {
      Fluttertoast.showToast(
          msg: "Please enter a valid number of car parking spaces");
      return false;
    }
    if (washrommController.text.trim().isEmpty ||
        int.tryParse(washrommController.text.trim()) == null ||
        int.parse(washrommController.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of washrooms");
      return false;
    }
    if (projectName.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the project name");
      return false;
    }
    if (titleControler.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the ad title");
      return false;
    }
    if (desContrler.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the description");
      return false;
    }
    if (priceController.text.trim().isEmpty ||
        double.tryParse(priceController.text.trim()) == null ||
        double.parse(priceController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid price");
      return false;
    }
    if (images.isEmpty) {
      Fluttertoast.showToast(msg: "Please select at least one image");
      return false;
    }
    return true;
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");
    final location = ref.watch(locationNotifer);
    Map<String, dynamic> data = {
      "project_status": projectControler.text,
      "listed_by": listedControlelr.text,
      "super_builtup_area": superbuildController.text,
      "carpet_area": carpetControlelr.text,
      "maintenance": maintanceController.text,
      "furnishing": furnisingController.text,
      "car_parking": carparkingContrller.text,
      "washrooms": washrommController.text,
      "project_name": projectName.text,
      "title": titleControler.text,
      "description": desContrler.text,
      "price": priceController.text,
    };

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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                    "Include some details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Furnishing*",
                        controller: furnisingController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Status*",
                        controller: projectControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Listed by*",
                        controller: listedControlelr,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Super Builtup area sqft*",
                        controller: superbuildController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Carpet Area sqft*",
                        controller: carpetControlelr,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Maintenance (Monthly)*",
                        controller: maintanceController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Car Parking*",
                        controller: carparkingContrller,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Washrooms*",
                        controller: washrommController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Name*",
                        controller: projectName,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Ad title*",
                        controller: titleControler,
                        helper:
                        "Mention the key features of your item (e.g., brand, model, age, type)",
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Ad Price*",
                        controller: priceController,
                        type: TextInputType.number,
                        helper: "Price",
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Describe what you are selling*",
                        controller: desContrler,
                        helper:
                        "Include condition, features and reason for selling",
                        maxlenghts: 4096,
                      ),
                      SizedBox(height: 20.h),
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
                                  color: Colors.grey, width: 1.w),
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
                          itemCount: images.length + 1,
                          itemBuilder: (context, index) {
                            if (index == images.length) {
                              return GestureDetector(
                                onTap: images.length < 5
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
                                    borderRadius:
                                    BorderRadius.circular(15.r),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 1.w),
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
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ElevatedButton(
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
                            final service = APIService(await createDio());
                            List<MultipartFile> imageFiles = [];
                            for (var img in images) {
                              imageFiles.add(await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ));
                            }
                            await service.addProduct({
                              "category": "Property",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "project_status": projectControler.text,
                                "listed_by": listedControlelr.text,
                                "super_builtup_area":
                                superbuildController.text,
                                "carpet_area": carpetControlelr.text,
                                "maintenance": maintanceController.text,
                                "furnishing": furnisingController.text,
                                "car_parking": carparkingContrller.text,
                                "washrooms": washrommController.text,
                                "project_name": projectName.text,
                                "title": titleControler.text,
                                "description": desContrler.text,
                                "price": priceController.text,
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

  @override
  void dispose() {
    projectControler.dispose();
    listedControlelr.dispose();
    superbuildController.dispose();
    carpetControlelr.dispose();
    maintanceController.dispose();
    furnisingController.dispose();
    carparkingContrller.dispose();
    washrommController.dispose();
    projectName.dispose();
    titleControler.dispose();
    desContrler.dispose();
    priceController.dispose();
    super.dispose();
  }
}*/


import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

class GuesthouseFormPage extends ConsumerStatefulWidget {
  final SellList? productToEdit;

  const GuesthouseFormPage({super.key, this.productToEdit});

  @override
  ConsumerState<GuesthouseFormPage> createState() => _GuesthouseFormPageState();
}

class _GuesthouseFormPageState extends ConsumerState<GuesthouseFormPage> {
  final projectController = TextEditingController();
  final listedController = TextEditingController();
  final superbuildController = TextEditingController();
  final carpetController = TextEditingController();
  final maintenanceController = TextEditingController();
  final furnishingController = TextEditingController();
  final carParkingController = TextEditingController();
  final washroomController = TextEditingController();
  final projectNameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  bool isForSale = true;
  List<XFile> images = [];
  List<String> existingImageUrls = [];
  final picker = ImagePicker();
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
      projectController.text = jsonData['project_status'] ?? '';
      listedController.text = jsonData['listed_by'] ?? '';
      superbuildController.text = jsonData['super_builtup_area'] ?? '';
      carpetController.text = jsonData['carpet_area'] ?? '';
      maintenanceController.text = jsonData['maintenance'] ?? '';
      furnishingController.text = jsonData['furnishing'] ?? '';
      carParkingController.text = jsonData['car_parking'] ?? '';
      washroomController.text = jsonData['washrooms'] ?? '';
      projectNameController.text = jsonData['project_name'] ?? '';
      titleController.text = jsonData['title'] ?? '';
      descriptionController.text = jsonData['description'] ?? '';
      priceController.text = jsonData['price'] ?? '';
      isForSale = jsonData['sale_type'] == 'For Sale';
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
    if (furnishingController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the furnishing status");
      return false;
    }
    if (projectController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the project status");
      return false;
    }
    if (listedController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter who listed the property");
      return false;
    }
    if (superbuildController.text.trim().isEmpty ||
        double.tryParse(superbuildController.text.trim()) == null ||
        double.parse(superbuildController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid super built-up area");
      return false;
    }
    if (carpetController.text.trim().isEmpty ||
        double.tryParse(carpetController.text.trim()) == null ||
        double.parse(carpetController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid carpet area");
      return false;
    }
    if (maintenanceController.text.trim().isEmpty ||
        double.tryParse(maintenanceController.text.trim()) == null ||
        double.parse(maintenanceController.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid maintenance amount (0 or positive)");
      return false;
    }
    if (carParkingController.text.trim().isEmpty ||
        int.tryParse(carParkingController.text.trim()) == null ||
        int.parse(carParkingController.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of car parking spaces");
      return false;
    }
    if (washroomController.text.trim().isEmpty ||
        int.tryParse(washroomController.text.trim()) == null ||
        int.parse(washroomController.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of washrooms");
      return false;
    }
    if (projectNameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the project name");
      return false;
    }
    if (titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the ad title");
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the description");
      return false;
    }
    if (priceController.text.trim().isEmpty ||
        double.tryParse(priceController.text.trim()) == null ||
        double.parse(priceController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid price");
      return false;
    }
    if (!isEditing && images.isEmpty && existingImageUrls.isEmpty) {
      Fluttertoast.showToast(msg: "Please select at least one image");
      return false;
    }
    return true;
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
                    onTap: () {
                      Navigator.pop(context);
                    },
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
                    isEditing ? "Update Guesthouse" : "Include some details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Type *",
                        style: GoogleFonts.dmSans(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(153, 0, 0, 0),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isForSale = false;
                              });
                            },
                            child: Container(
                              width: 190.w,
                              height: 53.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: const Color.fromARGB(153, 0, 0, 0),
                                ),
                                color: isForSale
                                    ? Colors.transparent
                                    : const Color.fromARGB(50, 137, 26, 255),
                              ),
                              child: Center(
                                child: Text(
                                  "For Rent",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromARGB(153, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isForSale = true;
                              });
                            },
                            child: Container(
                              width: 190.w,
                              height: 53.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: const Color.fromARGB(153, 0, 0, 0),
                                ),
                                color: isForSale
                                    ? const Color.fromARGB(50, 137, 26, 255)
                                    : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  "For Sale",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromARGB(153, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Furnishing*",
                        controller: furnishingController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Status*",
                        controller: projectController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Listed by*",
                        controller: listedController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Super Builtup area sqft*",
                        controller: superbuildController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Carpet Area sqft*",
                        controller: carpetController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Maintenance (Monthly)*",
                        controller: maintenanceController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Car Parking*",
                        controller: carParkingController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Washrooms*",
                        controller: washroomController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Name*",
                        controller: projectNameController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Ad title*",
                        controller: titleController,
                        helper: "Mention the key features of your item (e.g., brand, model, age, type)",
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Ad Price*",
                        controller: priceController,
                        type: TextInputType.number,
                        helper: "Price",
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Describe what you are selling*",
                        controller: descriptionController,
                        helper: "Include condition, features and reason for selling",
                        maxLength: 4096,
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
                      SizedBox(height: 20.h),
                  /*    ElevatedButton(
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
                            final service = APIService(await createDio());
                            List<MultipartFile> imageFiles = [];
                            for (var img in images) {
                              imageFiles.add(await MultipartFile.fromFile(
                                img.path,
                                filename: img.path.split("/").last,
                              ));
                            }
                            final data = {
                              "subcategory": "Properties Guest",
                              "category": "Properties",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "project_status": projectController.text,
                                "listed_by": listedController.text,
                                "super_builtup_area": superbuildController.text,
                                "carpet_area": carpetController.text,
                                "maintenance": maintenanceController.text,
                                "furnishing": furnishingController.text,
                                "car_parking": carParkingController.text,
                                "washrooms": washroomController.text,
                                "project_name": projectNameController.text,
                                "title": titleController.text,
                                "description": descriptionController.text,
                                "sale_type": isForSale ? "For Sale" : "For Rent",
                              }),
                            };
                            if (isEditing && widget.productToEdit != null) {
                              if (existingImageUrls.isNotEmpty) {
                                data['existing_images'] = existingImageUrls.join(',');
                              }
                              await service.updateProduct(
                                widget.productToEdit!.id!,
                                data,
                              );
                              Fluttertoast.showToast(
                                msg: "Guesthouse Updated Successfully",
                              );
                            } else {
                              await service.addProduct(data);
                              Fluttertoast.showToast(
                                msg: "Guesthouse Added Successfully",
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
                                  "Failed to process guesthouse. Please try again.";
                            }
                            Fluttertoast.showToast(msg: errorMessage);
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

                          // Product data ready karo (PlanPage ke liye reuse ke liye)
                          final Map<String, dynamic> productData = {
                            "subcategory": "Properties Guest",
                            "category": "Properties",
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": priceController.text,
                            "json_data": jsonEncode({
                              "project_status": projectController.text,
                              "listed_by": listedController.text,
                              "super_builtup_area": superbuildController.text,
                              "carpet_area": carpetController.text,
                              "maintenance": maintenanceController.text,
                              "furnishing": furnishingController.text,
                              "car_parking": carParkingController.text,
                              "washrooms": washroomController.text,
                              "project_name": projectNameController.text,
                              "title": titleController.text,
                              "description": descriptionController.text,
                              "sale_type": isForSale ? "For Sale" : "For Rent",
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
                              Fluttertoast.showToast(msg: "Guesthouse Updated Successfully");
                            } else {
                              await apiService.addProduct(productData);
                              Fluttertoast.showToast(msg: "Guesthouse Added Successfully");
                            }

                            // Success → Home pe jao aur navigation stack clear kar do
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
                                  "Failed to process guesthouse.";

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

                            Fluttertoast.showToast(msg: errorMessage);

                            if (needsPlan) {
                              // PlanPage pe pending productData pass kar do
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => PlanPage(productData, true),
                                ),
                              );
                            } else {
                              // Normal error pe current screen pe rehne do (ya Home bhej sakte ho)
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
    projectController.dispose();
    listedController.dispose();
    superbuildController.dispose();
    carpetController.dispose();
    maintenanceController.dispose();
    furnishingController.dispose();
    carParkingController.dispose();
    washroomController.dispose();
    projectNameController.dispose();
    titleController.dispose();
    descriptionController.dispose();
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

  const FormBody({
    super.key,
    required this.labeltxt,
    this.helper,
    this.maxLength,
    this.type,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: type,
          maxLength: maxLength,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintStyle: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF615B68),
            ),
            labelText: labeltxt,
            labelStyle: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF615B68),
              letterSpacing: -1,
            ),
            helperText: helper,
            helperStyle: GoogleFonts.dmSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(127, 0, 0, 0),
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}