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
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import '../home/home.page.dart';
import '../plan/plan.page.dart';


  class ServicesBookFormPage extends StatefulWidget {
  final String serviceType;
  const ServicesBookFormPage({super.key, required this.serviceType});
  @override
  State<ServicesBookFormPage> createState() => _ServicesBookFormPageState();
  }

  class _ServicesBookFormPageState extends State<ServicesBookFormPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final picker = ImagePicker();
  List<XFile> images = [];
  String? nameError;
  String? titleError;
  String? descError;
  String? priceError;
  String? imageError;
  bool isServiceProperty = false;
  bool _didRedirect = false;
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

  // Validation function
  bool validateForm() {
    bool isValid = true;
    final priceRegex = RegExp(r'^\d{1,10}(\.\d{1,2})?$');

    setState(() {
      nameError = nameController.text.trim().isEmpty
          ? "Service provider name is required"
          : nameController.text.trim().length < 3
          ? "Name must be at least 3 characters"
          : null;

      titleError = titleController.text.trim().isEmpty
          ? "Service title is required"
          : titleController.text.trim().length < 5
          ? "Title must be at least 5 characters"
          : null;

      descError = descController.text.trim().isEmpty
          ? "Description is required"
          : descController.text.trim().length < 10
          ? "Description must be at least 10 characters"
          : null;

      priceError = priceController.text.trim().isEmpty
          ? "Price is required"
          : !priceRegex.hasMatch(priceController.text.trim())
          ? "Enter a valid price (e.g., 25000 or 25000.00)"
          : double.parse(priceController.text.trim()) <= 0
          ? "Price must be greater than 0"
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

  final Map<String, Map<String, String>> fieldLabels = {
    "Tours/Travel": {
      "name": "Agency Name*",
      "title": "Tour Package Title*",
      "desc": "Describe the tour package (destinations, duration, features)*",
      "price": "Package Price (INR)*",
    },
    "Electronics Repair Services": {
      "name": "Service Provider Name*",
      "title": "Service Title*",
      "desc": "Describe the electronics service (brand, device type, issues handled)*",
      "price": "Starting Price (INR)*",
    },
    "Health Beauty": {
      "name": "Clinic/Spa Name*",
      "title": "Service Title*",
      "desc": "Include treatments, specializations, etc.*",
      "price": "Service Fee (INR)*",
    },
    "Home Renovation Repair": {
      "name": "Company/Contractor Name*",
      "title": "Service Title*",
      "desc": "Include types of repair, experience, materials used*",
      "price": "Estimated Price*",
    },
    "Cleaning Pest Control": {
      "name": "Company Name*",
      "title": "Service Title*",
      "desc": "Mention cleaning types, chemicals used, certifications*",
      "price": "Service Cost*",
    },
    "Legal Documentation Services": {
      "name": "Lawyer/Agency Name*",
      "title": "Service Title*",
      "desc": "Include type of docs, turnaround time, availability*",
      "price": "Consultation Fee*",
    },
    "Packers Movers": {
      "name": "Company Name*",
      "title": "Moving Service Title*",
      "desc": "Include city, service types (house/office), insurance, tracking*",
      "price": "Starting Cost*",
    },
    "Education & Classes": {
      "name": "Institute/Trainer Name*",
      "title": "Course/Subject Title*",
      "desc":
      "Describe the course (topics covered, duration, mode - online/offline)*",
      "price": "Course Fee (INR)*",
    },

    "Banking and Finance": {
      "name": "Bank/Financial Institution Name*",
      "title": "Service Title*",
      "desc": "Describe the financial service (e.g., loan types, investment options, banking features)*",
      "price": "Service Fee (INR)*",
    },

    // New Entry for Other Services
    "Other Services": {
      "name": "Service Provider Name*",
      "title": "Service Title*",
      "desc": "Describe the service in detail (e.g., what you offer, features, availability)*",
      "price": "Service Cost (INR)*",
    },
  };

  @override
  Widget build(BuildContext context) {
    final labels = fieldLabels[widget.serviceType] ?? {
      "name": "Service Provider*",
      "title": "Service Title*",
      "desc": "Describe your service*",
      "price": "Price (INR)*"
    };

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
                    "Services Include\n some details",
                    style: GoogleFonts.dmSans(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: nameController,
                        labeltxt: labels["name"].toString(),
                        helper:
                        "Enter the name of the service provider or company",
                        errorText: nameError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: titleController,
                        labeltxt: labels["title"].toString(),
                        helper: "Enter a catchy title for your service",
                        errorText: titleError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: descController,
                        labeltxt: labels["desc"].toString(),
                        helper:
                        "Include service highlights, features, and important details",
                        maxlenghts: 4096,
                        errorText: descError,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: priceController,
                        labeltxt: labels["price"].toString(),
                        helper: "Enter total or starting fee (e.g., 25000)",
                        maxlenghts: 10,
                        keyboardType: TextInputType.number,
                        errorText: priceError,
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "Upload Service Images*",
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
                                  margin: EdgeInsets

                                      .only(right: 8.w),
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
                              isServiceProperty = true;
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
                              "category": widget.serviceType ?? "Services",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "title": titleController.text,
                                "desc": descController.text,
                                "name": nameController.text,
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
                        child: isServiceProperty
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Continue",
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

  class FormBody extends StatelessWidget {
  final TextEditingController controller;
  final String labeltxt;
  final String? helper;
  final int? maxlenghts;
  final String? errorText;
  final TextInputType? keyboardType;

  const FormBody({
    required this.controller,
    required this.labeltxt,
    this.helper,
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

class ServicesBookFormPage extends ConsumerStatefulWidget {
  final String serviceType;
  final SellList? productToEdit;

  const ServicesBookFormPage({
    super.key,
    required this.serviceType,
    this.productToEdit,
  });

  @override
  ConsumerState<ServicesBookFormPage> createState() => _ServicesBookFormPageState();
}

class _ServicesBookFormPageState extends ConsumerState<ServicesBookFormPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
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
      nameController.text = jsonData['name'] ?? '';
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
    final priceRegex = RegExp(r'^\d{1,10}(\.\d{1,2})?$');

    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Service provider name is required");
      isValid = false;
    } else if (nameController.text.trim().length < 3) {
      Fluttertoast.showToast(msg: "Name must be at least 3 characters");
      isValid = false;
    }
    if (titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Service title is required");
      isValid = false;
    } else if (titleController.text.trim().length < 5) {
      Fluttertoast.showToast(msg: "Title must be at least 5 characters");
      isValid = false;
    }
    if (descController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Description is required");
      isValid = false;
    } else if (descController.text.trim().length < 10) {
      Fluttertoast.showToast(msg: "Description must be at least 10 characters");
      isValid = false;
    }
    if (priceController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Price is required");
      isValid = false;
    } else if (!priceRegex.hasMatch(priceController.text.trim())) {
      Fluttertoast.showToast(msg: "Enter a valid price (e.g., 25000 or 25000.00)");
      isValid = false;
    } else if (double.parse(priceController.text.trim()) <= 0) {
      Fluttertoast.showToast(msg: "Price must be greater than 0");
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

  final Map<String, Map<String, String>> fieldLabels = {
    "Tours/Travel": {
      "name": "Agency Name*",
      "title": "Tour Package Title*",
      "desc": "Tour Package Description*",
      "price": "Package Price (INR)*",
      "name_helper": "e.g., Wanderlust Tours",
      "title_helper": "e.g., 5-Day Himalayan Adventure",
      "desc_helper": "Include destinations, duration, inclusions (e.g., meals, transport)",
      "price_helper": "Enter total or starting price (e.g., 25000)",
    },
    "Electronics Repair Services": {
      "name": "Service Provider Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Starting Price (INR)*",
      "name_helper": "e.g., TechFix Solutions",
      "title_helper": "e.g., Smartphone Screen Repair",
      "desc_helper": "Include brands, device types, and issues handled",
      "price_helper": "Enter starting price (e.g., 1000)",
    },
    "Health Beauty": {
      "name": "Clinic/Spa Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Service Fee (INR)*",
      "name_helper": "e.g., Glow Wellness Spa",
      "title_helper": "e.g., Full Body Massage",
      "desc_helper": "Include treatments, specializations, duration",
      "price_helper": "Enter fee per session (e.g., 2000)",
    },
    "Home Renovation Repair": {
      "name": "Company/Contractor Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Estimated Price*",
      "name_helper": "e.g., HomePro Repairs",
      "title_helper": "e.g., Kitchen Renovation",
      "desc_helper": "Include repair types, materials, experience",
      "price_helper": "Enter estimated price (e.g., 50000)",
    },
    "Cleaning Pest Control": {
      "name": "Company Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Service Cost*",
      "name_helper": "e.g., CleanSweep Services",
      "title_helper": "e.g., Deep Home Cleaning",
      "desc_helper": "Include cleaning types, chemicals, certifications",
      "price_helper": "Enter cost per session (e.g., 3000)",
    },
    "Legal Documentation Services": {
      "name": "Lawyer/Agency Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Consultation Fee*",
      "name_helper": "e.g., LegalEase Solutions",
      "title_helper": "e.g., Property Document Drafting",
      "desc_helper": "Include document types, turnaround time",
      "price_helper": "Enter consultation fee (e.g., 1500)",
    },
    "Packers Movers": {
      "name": "Company Name*",
      "title": "Moving Service Title*",
      "desc": "Service Description*",
      "price": "Starting Cost*",
      "name_helper": "e.g., Swift Movers",
      "title_helper": "e.g., Local Home Shifting",
      "desc_helper": "Include cities, service types, insurance details",
      "price_helper": "Enter starting cost (e.g., 10000)",
    },
    "Education & Classes": {
      "name": "Institute/Trainer Name*",
      "title": "Course/Subject Title*",
      "desc": "Course Description*",
      "price": "Course Fee (INR)*",
      "name_helper": "e.g., KnowledgeHub Academy",
      "title_helper": "e.g., Python Programming Course",
      "desc_helper": "Include topics, duration, mode (online/offline)",
      "price_helper": "Enter total fee (e.g., 15000)",
    },
    "Banking and Finance": {
      "name": "Bank/Financial Institution Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Service Fee (INR)*",
      "name_helper": "e.g., FinSecure Bank",
      "title_helper": "e.g., Home Loan Processing",
      "desc_helper": "Include loan types, investment options, features",
      "price_helper": "Enter fee or starting amount (e.g., 5000)",
    },
    "Other Services": {
      "name": "Service Provider Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Service Cost (INR)*",
      "name_helper": "e.g., Freelance Consultant",
      "title_helper": "e.g., Custom Software Development",
      "desc_helper": "Describe the service, features, availability",
      "price_helper": "Enter cost or starting price (e.g., 20000)",
    },
  };

  @override
  Widget build(BuildContext context) {
    final labels = fieldLabels[widget.serviceType] ?? {
      "name": "Service Provider Name*",
      "title": "Service Title*",
      "desc": "Service Description*",
      "price": "Service Cost (INR)*",
      "name_helper": "e.g., Service Provider Name",
      "title_helper": "e.g., General Service",
      "desc_helper": "Describe the service in detail",
      "price_helper": "Enter cost or starting price (e.g., 20000)",
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
                    isEditing ? "Update ${widget.serviceType} Service" : "${widget.serviceType} Service",
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
                        labeltxt: labels["name"].toString(),
                        helper: labels["name_helper"],
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: titleController,
                        labeltxt: labels["title"].toString(),
                        helper: labels["title_helper"],
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: descController,
                        labeltxt: labels["desc"].toString(),
                        helper: labels["desc_helper"],
                        maxLength: 4096,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        controller: priceController,
                        labeltxt: labels["price"].toString(),
                        helper: labels["price_helper"],
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Upload Service Images*",
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.h),
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
                              border: Border.all(
                                color: isEditing && existingImageUrls.isNotEmpty
                                    ? Colors.grey
                                    : Colors.red,
                                width: 1.w,
                              ),
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
                                          images.removeAt(index - existingImageUrls.length);
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
                   /*   ElevatedButton(
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
                              "category": "Service",
                              "subcategory": widget.serviceType,
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "name": nameController.text,
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
                                msg: "Service Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(data);
                              Fluttertoast.showToast(
                                msg: "Service Added Successfully",
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
                                  "You can only add one service every 24 hours.";
                            } else if (e is DioError) {
                              errorMessage = e.response?.data['message'] ??
                                  "Failed to process service. Please try again.";
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
                          minimumSize: Size(MediaQuery.of(context).size.width, 49.h),
                          backgroundColor: const Color.fromARGB(255, 137, 26, 255),
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
                            imageFiles.add(await MultipartFile.fromFile(
                              img.path,
                              filename: img.path.split("/").last,
                            ));
                          }

                          // Product data ready karo (PlanPage ke liye reuse ke liye)
                          final Map<String, dynamic> productData = {
                            "category": "Service",
                            "subcategory": widget.serviceType,  // Dynamic subcategory
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": priceController.text,
                            "json_data": jsonEncode({
                              "name": nameController.text,
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
                                msg: "Service Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(productData);
                             
                              Fluttertoast.showToast(
                                msg: "Service Added Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            }

                            // Success → Home pe jao aur navigation stack clear kar do
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(builder: (_) => const HomePage()),
                                  (route) => false,
                            );
                          } catch (e) {
                            log("Error: ${e.toString()}");
                            setState(() => isLoading = false);

                            String errorMessage = "An error occurred. Please try again.";
                            bool needsPlan = false;

                            if (e is DioError) {
                              errorMessage = e.response?.data['message']?.toString() ??
                                  "Failed to process service.";

                              if (e.response?.statusCode == 429) {
                                errorMessage = "You can only add one service every 24 hours.";
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
                              // Normal error pe current screen pe rehne do (optional: Home bhej sakte ho)
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
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    nameController.dispose();
    super.dispose();
  }
}

class FormBody extends StatelessWidget {
  final TextEditingController controller;
  final String labeltxt;
  final String? helper;
  final int? maxLength;
  final String? errorText;
  final TextInputType? keyboardType;

  const FormBody({
    super.key,
    required this.controller,
    required this.labeltxt,
    this.helper,
    this.maxLength,
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