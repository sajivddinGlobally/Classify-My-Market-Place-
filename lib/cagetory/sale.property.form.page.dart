/*
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

import '../plan/plan.page.dart';

class SalePropertyFormPage extends ConsumerStatefulWidget {
  const SalePropertyFormPage({super.key});

  @override
  ConsumerState<SalePropertyFormPage> createState() =>
      _SalePropertyFormPageState();
}

class _SalePropertyFormPageState extends ConsumerState<SalePropertyFormPage> {
  final typeContrller = TextEditingController();
  final bhkController = TextEditingController();
  final bathroomController = TextEditingController();
  final furshingController = TextEditingController();
  final projectControler = TextEditingController();
  final listedControlelr = TextEditingController();
  final superbuildController = TextEditingController();
  final carpetControlelr = TextEditingController();
  final mentationController = TextEditingController();
  final florControlelr = TextEditingController();
  final florNumberControler = TextEditingController();
  final carparkingContrller = TextEditingController();
  final facingcontroler = TextEditingController();
  final proejctnameControler = TextEditingController();
  final titleControler = TextEditingController();
  final desContrler = TextEditingController();
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
  bool isProperty = false;
  bool _didRedirect = false;

  bool _validateForm() {
    // Validate all text fields
    if (typeContrller.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the property type");
      return false;
    }
    if (bhkController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the BHK configuration");
      return false;
    }
    if (bathroomController.text.trim().isEmpty ||
        int.tryParse(bathroomController.text.trim()) == null ||
        int.parse(bathroomController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of bathrooms");
      return false;
    }
    if (furshingController.text.trim().isEmpty) {
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
    if (superbuildController.text.trim().isEmpty ) {
      Fluttertoast.showToast(msg: "Please enter a valid super built-up area");
      return false;
    }
    if (carpetControlelr.text.trim().isEmpty ) {
      Fluttertoast.showToast(msg: "Please enter a valid carpet area");
      return false;
    }
    if (mentationController.text.trim().isEmpty ||
        double.tryParse(mentationController.text.trim()) == null ||
        double.parse(mentationController.text.trim()) < 0) {
      Fluttertoast.showToast(
          msg: "Please enter a valid maintenance amount (0 or positive)");
      return false;
    }
    if (florControlelr.text.trim().isEmpty ||
        int.tryParse(florControlelr.text.trim()) == null ||
        int.parse(florControlelr.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of total floors");
      return false;
    }
    if (florNumberControler.text.trim().isEmpty ||
        int.tryParse(florNumberControler.text.trim()) == null ||
        int.parse(florNumberControler.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid floor number");
      return false;
    }
    if (carparkingContrller.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid number of car parking spaces");
      return false;
    }
    if (facingcontroler.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the facing direction");
      return false;
    }
    if (proejctnameControler.text.trim().isEmpty) {
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
    // Validate at least one image
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
      Future.delayed(Duration(milliseconds: 100), () {
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
                    "Include some details",
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
                      FormBody(labeltxt: "Type*", controller: typeContrller),
                      SizedBox(height: 10.h),
                      FormBody(labeltxt: "BHK", controller: bhkController),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Bathrooms",
                        controller: bathroomController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Furnishing",
                        controller: furshingController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Status",
                        controller: projectControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Listed by",
                        controller: listedControlelr,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Super Builtup area sqft*",
                        controller: superbuildController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Carpet Area sqft*",
                        controller: carpetControlelr,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        type: TextInputType.number,
                        labeltxt: "Maintenance (Monthly)",
                        controller: mentationController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        controller: florControlelr,
                        labeltxt: "Total Floors",
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Floor No",
                        type: TextInputType.number,
                        controller: florNumberControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Car Parking",
                        controller: carparkingContrller,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(labeltxt: "Facing", controller: facingcontroler),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Name",
                        controller: proejctnameControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        controller: titleControler,
                        labeltxt: "Ad title*",
                        helper:
                            "Mention the key features of your item (eg. brand, model 0/70 age, type)",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        type: TextInputType.number,
                        controller: priceController,
                        labeltxt: "Ad Price*",
                        helper: "Price",
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        controller: desContrler,
                        labeltxt: "Describe what you are selling*",
                        helper:
                            "Include condition, features and reason for selling\nRequired Fields",
                        maxlenghts: 4096,
                      ),
                      SizedBox(height: 20.h),

                      Container(
                        height: 216.h,
                        child: images.isEmpty
                            ?
                        GestureDetector(
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
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: Color.fromARGB(255, 137, 26, 255),
                        ),

                        onPressed: () async {
                          // Validate form before proceeding
                          if (!_validateForm()) {
                            return;
                          }

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

                              "category": "Properties Sale",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles, // Changed from "image" to "images"
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "type": typeContrller.text,
                                "bhk": bhkController.text,
                                "bathroo": bathroomController.text,
                                "frun": furshingController.text,
                                "project": projectControler.text,
                                "listed": listedControlelr.text,
                                "super": superbuildController.text,
                                "car": carpetControlelr.text,
                                "main": mentationController.text,
                                "flor": florControlelr.text,
                                "flornumber": florNumberControler.text,
                                "carparking": carparkingContrller.text,
                                "facing": facingcontroler.text,
                                "projectname": proejctnameControler.text,
                                "title": titleControler.text,
                                "des": desContrler.text,
                              }),
                            });
                          */
/*  Fluttertoast.showToast(
                              msg: "Product Add Successfull",
                            );

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
                            Fluttertoast.showToast(msg: "Product Add Failed");
                          }*//*



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
                                  : SizedBox(
                                    width: 20.w,
                                    height: 20.h,
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
    );
  }
}
*/




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
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/listing/model/getlistingModel.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/plan/plan.page.dart';

class SalePropertyFormPage extends ConsumerStatefulWidget {
  final SellList? productToEdit;

  const SalePropertyFormPage({super.key, this.productToEdit});

  @override
  ConsumerState<SalePropertyFormPage> createState() => _SalePropertyFormPageState();
}

class _SalePropertyFormPageState extends ConsumerState<SalePropertyFormPage> {
  final typeContrller = TextEditingController();
  final bhkController = TextEditingController();
  final bathroomController = TextEditingController();
  final furshingController = TextEditingController();
  final projectControler = TextEditingController();
  final listedControlelr = TextEditingController();
  final superbuildController = TextEditingController();
  final carpetControlelr = TextEditingController();
  final mentationController = TextEditingController();
  final florControlelr = TextEditingController();
  final florNumberControler = TextEditingController();
  final carparkingContrller = TextEditingController();
  final facingcontroler = TextEditingController();
  final proejctnameControler = TextEditingController();
  final titleControler = TextEditingController();
  final desContrler = TextEditingController();
  final priceController = TextEditingController();
  List<XFile> images = [];
  List<String> existingImageUrls = [];
  final picker = ImagePicker();
  bool isProperty = false;
  bool isEditing = false;

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
      typeContrller.text = jsonData['type'] ?? '';
      bhkController.text = jsonData['bhk'] ?? '';
      bathroomController.text = jsonData['bathroo'] ?? '';
      furshingController.text = jsonData['frun'] ?? '';
      projectControler.text = jsonData['project'] ?? '';
      listedControlelr.text = jsonData['listed'] ?? '';
      superbuildController.text = jsonData['super'] ?? '';
      carpetControlelr.text = jsonData['car'] ?? '';
      mentationController.text = jsonData['main'] ?? '';
      florControlelr.text = jsonData['flor'] ?? '';
      florNumberControler.text = jsonData['flornumber'] ?? '';
      carparkingContrller.text = jsonData['carparking'] ?? '';
      facingcontroler.text = jsonData['facing'] ?? '';
      proejctnameControler.text = jsonData['projectname'] ?? '';
      titleControler.text = jsonData['title'] ?? '';
      desContrler.text = jsonData['des'] ?? '';
      priceController.text = product.price?? '';
    }
    if (product.image != null && product.image!.isNotEmpty) {
      setState(() {
        existingImageUrls = product.image!.split(',').map((url) => url.trim()).toList();
      });
    }
  }

/*  Future<void> pickImageFromCamera() async {
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
  }*/


  Future<void> pickImageFromCamera() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        images.add(photo);
      });
    }
  }
  /// Gallery multiple images
  Future<void> pickImageFromGallery() async {
    final List<XFile> pickedImages =
    await picker.pickMultiImage(imageQuality: 70);

    if (pickedImages.isNotEmpty) {
      setState(() {
        images.addAll(pickedImages);
      });
    }
  }
  /// Bottom sheet
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


  bool _didRedirect = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didRedirect) return;
    final shouldRedirect = ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    if (shouldRedirect) {
      _didRedirect = true;
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

  bool _validateForm() {
    if (typeContrller.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the property type");
      return false;
    }
    if (bhkController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the BHK configuration");
      return false;
    }
    if (bathroomController.text.trim().isEmpty ||
        int.tryParse(bathroomController.text.trim()) == null ||
        int.parse(bathroomController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of bathrooms");
      return false;
    }
    if (furshingController.text.trim().isEmpty) {
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
    if (superbuildController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid super built-up area");
      return false;
    }
    if (carpetControlelr.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid carpet area");
      return false;
    }
    if (mentationController.text.trim().isEmpty ||
        double.tryParse(mentationController.text.trim()) == null ||
        double.parse(mentationController.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid maintenance amount (0 or positive)");
      return false;
    }
    if (florControlelr.text.trim().isEmpty ||
        int.tryParse(florControlelr.text.trim()) == null ||
        int.parse(florControlelr.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Please enter a valid number of total floors");
      return false;
    }
    if (florNumberControler.text.trim().isEmpty ||
        int.tryParse(florNumberControler.text.trim()) == null ||
        int.parse(florNumberControler.text.trim()) < 0) {
      Fluttertoast.showToast(msg: "Please enter a valid floor number");
      return false;
    }
    if (carparkingContrller.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid number of car parking spaces");
      return false;
    }
    if (facingcontroler.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the facing direction");
      return false;
    }
    if (proejctnameControler.text.trim().isEmpty) {
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
    if (!isEditing && images.isEmpty && existingImageUrls.isEmpty) {
      Fluttertoast.showToast(msg: "Please select at least one image");
      return false;
    }
    return true;
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
                    isEditing ? "Update Property" : "Include some details",
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
                      FormBody(labeltxt: "Type*", controller: typeContrller),
                      SizedBox(height: 10.h),
                      FormBody(labeltxt: "BHK", controller: bhkController),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Bathrooms",
                        controller: bathroomController,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Furnishing",
                        controller: furshingController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Status",
                        controller: projectControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Listed by",
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
                        type: TextInputType.number,
                        labeltxt: "Maintenance (Monthly)",
                        controller: mentationController,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        controller: florControlelr,
                        labeltxt: "Total Floors",
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Floor No",
                        type: TextInputType.number,
                        controller: florNumberControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Car Parking",
                        controller: carparkingContrller,
                        type: TextInputType.number,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(labeltxt: "Facing", controller: facingcontroler),
                      SizedBox(height: 10.h),
                      FormBody(
                        labeltxt: "Project Name",
                        controller: proejctnameControler,
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        controller: titleControler,
                        labeltxt: "Ad title*",
                        helper: "Mention the key features of your item (e.g., brand, model, age, type)",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        type: TextInputType.number,
                        controller: priceController,
                        labeltxt: "Ad Price*",
                        helper: "Price",
                      ),
                      SizedBox(height: 10.h),
                      FormBody(
                        controller: desContrler,
                        labeltxt: "Describe what you are selling*",
                        helper: "Include condition, features and reason for selling\nRequired Fields",
                        maxlenghts: 4096,
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
                              children: [
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
                            } else {
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
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                     /* ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            MediaQuery.of(context).size.width,
                            49.h,
                          ),
                          backgroundColor: Color.fromARGB(255, 137, 26, 255),
                        ),
                        onPressed: () async {
                          if (!_validateForm()) {
                            return;
                          }
                          var box = Hive.box("data");
                          double? latitude = box.get('latitude');
                          double? longitude = box.get('longitude');
                          try {
                            setState(() {
                              isProperty = true;
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
                              "subcategory": "Properties Sale",
                              "category": "Properties",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "type": typeContrller.text,
                                "bhk": bhkController.text,
                                "bathroo": bathroomController.text,
                                "frun": furshingController.text,
                                "project": projectControler.text,
                                "listed": listedControlelr.text,
                                "super": superbuildController.text,
                                "car": carpetControlelr.text,
                                "main": mentationController.text,
                                "flor": florControlelr.text,
                                "flornumber": florNumberControler.text,
                                "carparking": carparkingContrller.text,
                                "facing": facingcontroler.text,
                                "projectname": proejctnameControler.text,
                                "title": titleControler.text,
                                "des": desContrler.text,
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
                                msg: "Property Updated Successfully",
                              );
                            } else {
                              await apiService.addProduct(data);
                              Fluttertoast.showToast(
                                msg: "Property Added Successfully",
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
                              isProperty = false;
                            });
                            String errorMessage = "An error occurred. Please try again.";
                            if (e is DioError && e.response?.statusCode == 429) {
                              errorMessage = e.response?.data['message'] ?? "You can only add one product every 24 hours.";
                            } else if (e is DioError) {
                              errorMessage = e.response?.data['message'] ?? "Failed to process property. Please try again.";
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
                          child: isProperty
                              ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
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
                            "subcategory": "Properties Sale",
                            "category": "Properties",
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": priceController.text,
                            "json_data": jsonEncode({
                              "type": typeContrller.text,
                              "bhk": bhkController.text,
                              "bathroo": bathroomController.text,
                              "frun": furshingController.text,
                              "project": projectControler.text,
                              "listed": listedControlelr.text,
                              "super": superbuildController.text,
                              "car": carpetControlelr.text,
                              "main": mentationController.text,
                              "flor": florControlelr.text,
                              "flornumber": florNumberControler.text,
                              "carparking": carparkingContrller.text,
                              "facing": facingcontroler.text,
                              "projectname": proejctnameControler.text,
                              "title": titleControler.text,
                              "des": desContrler.text,
                            }),
                          };

                          // Editing mode mein existing images add karo
                          if (isEditing && widget.productToEdit != null && existingImageUrls.isNotEmpty) {
                            productData['existing_images'] = existingImageUrls.join(',');
                          }

                          try {
                            setState(() => isProperty = true);

                            final apiService = APIService(await createDio());

                            if (isEditing && widget.productToEdit != null) {
                              await apiService.updateProduct(widget.productToEdit!.id!, productData);
                              Fluttertoast.showToast(msg: "Property Updated Successfully");
                            } else {
                              await apiService.addProduct(productData);
                             
                              Fluttertoast.showToast(msg: "Property Added Successfully");
                            }

                            // Success → Home pe jao aur navigation stack clear kar do
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(builder: (_) => HomePage()),
                                  (route) => false,
                            );
                          } catch (e) {
                            log("Error: ${e.toString()}");
                            setState(() => isProperty = false);

                            String errorMessage = "An error occurred. Please try again.";
                            bool needsPlan = false;

                            if (e is DioError) {
                              errorMessage = e.response?.data['message']?.toString() ??
                                  "Failed to process property.";

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
                              // Normal error pe current screen pe rehne do (ya Home bhej sakte ho agar chaho)
                            }
                          }
                        },
                        child: Center(
                          child: isProperty
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
}

class FormBody extends StatelessWidget {
  final String labeltxt;
  final String? helper;
  final int? maxlenghts;
  final TextEditingController controller;
  final TextInputType? type;

  const FormBody({
    super.key,
    required this.labeltxt,
    this.helper,
    this.maxlenghts,
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
          maxLength: maxlenghts,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintStyle: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF615B68),
            ),
            labelText: labeltxt,
            labelStyle: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF615B68),
              letterSpacing: -1,
            ),
            helperText: helper,
            helperStyle: GoogleFonts.dmSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(127, 0, 0, 0),
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}