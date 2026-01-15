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
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/choseMap/controller/locationNotifer.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

import '../plan/plan.page.dart';

// Updated FormBody widget to support TextInputType
class FormBody extends StatelessWidget {
  final String labeltxt;
  final TextEditingController controller;
  final String? helper;
  final int? maxLength;
  final TextInputType? type;

  const FormBody({
    super.key,
    required this.labeltxt,
    required this.controller,
    this.helper,
    this.maxLength,
    this.type,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      ],
    );
  }
}

class ElectronicsFormPage extends ConsumerStatefulWidget {
  String s;
   ElectronicsFormPage(this.s,{super.key});

  @override
  ConsumerState<ElectronicsFormPage> createState() => _ElectronicsFormPageState();
}

class _ElectronicsFormPageState extends ConsumerState<ElectronicsFormPage> {
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final picker = ImagePicker();
  List<XFile> images = [];
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
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the brand or model");
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
      "brand": nameController.text,
      "title": titleController.text,
      "description": descriptionController.text,
      "price": priceController.text,
    };


    // Determine helper text based on category (widget.s)
    String helperText;
    switch (widget.s) {
      case "ACS":
        helperText = "e.g., Split AC, Window AC, 1.5 Ton";
        break;
      case "Hard Disks, Printers & Monitors":
        helperText = "e.g., Seagate 1TB HDD, HP LaserJet, Dell 24-inch Monitor";
        break;
      case "Games & Entertainment":
        helperText = "e.g., PlayStation 5, Nintendo Switch, VR Headset";
        break;
      case "Cameras & Lenses":
        helperText = "e.g., Canon EOS, Nikon 50mm Lens";
        break;
      case "Computers & Laptops":
        helperText = "e.g., Dell XPS 13, MacBook Pro, Desktop PC";
        break;
      case "Kitchen & Other Appliances":
        helperText = "e.g., Microwave Oven, Blender, Air Purifier";
        break;
      case "TVs, Video-Audio":
        helperText = "e.g., Samsung 55-inch 4K TV, Bose Soundbar";
        break;
      default:
        helperText = "Enter the brand or model of the item";
    }

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
                    "Electronics Listing",
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
                     */
/* FormBody(
                        labeltxt: "Brand/Model*",
                        controller: nameController,
                        helper: "e.g., Samsung, iPhone 12",
                      ),*//*

                      FormBody(
                        labeltxt: "Brand/Model*",
                        controller: nameController,
                        helper: helperText,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Ad Title*",
                        controller: titleController,
                        helper:
                        "Mention the key features (e.g., brand, model, condition)",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Description*",
                        controller: descriptionController,
                        helper:
                        "Include condition, features, and reason for selling",
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
                      SizedBox(height: 40.h),
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
                              "category": "Electronics",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "brand": nameController.text,
                                "title": titleController.text,
                                "description": descriptionController.text,
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
    nameController.dispose();
    titleController.dispose();
    descriptionController.dispose();
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

class ElectronicsFormPage extends ConsumerStatefulWidget {
  final String? category;
  final SellList? productToEdit;

  const ElectronicsFormPage(this.category, {super.key, this.productToEdit});

  @override
  ConsumerState<ElectronicsFormPage> createState() => _ElectronicsFormPageState();
}

class _ElectronicsFormPageState extends ConsumerState<ElectronicsFormPage> {
  final nameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
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
      nameController.text = jsonData['brand'] ?? '';
      titleController.text = jsonData['title'] ?? '';
      descriptionController.text = jsonData['description'] ?? '';
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
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the brand or model");
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
    // Determine helper text based on category (widget.category)
    String helperText;
    switch (widget.category) {
      case "ACS":
        helperText = "e.g., Split AC, Window AC, 1.5 Ton";
        break;
      case "Hard Disks, Printers & Monitors":
        helperText = "e.g., Seagate 1TB HDD, HP LaserJet, Dell 24-inch Monitor";
        break;
      case "Games & Entertainment":
        helperText = "e.g., PlayStation 5, Nintendo Switch, VR Headset";
        break;
      case "Cameras & Lenses":
        helperText = "e.g., Canon EOS, Nikon 50mm Lens";
        break;
      case "Computers & Laptops":
        helperText = "e.g., Dell XPS 13, MacBook Pro, Desktop PC";
        break;
      case "Kitchen & Other Appliances":
        helperText = "e.g., Microwave Oven, Blender, Air Purifier";
        break;
      case "TVs, Video-Audio":
        helperText = "e.g., Samsung 55-inch 4K TV, Bose Soundbar";
        break;
      default:
        helperText = "Enter the brand or model of the item";
    }

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
                    isEditing ? "Update Electronics Listing" : "Electronics Listing",
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
                        labeltxt: "Brand/Model*",
                        controller: nameController,
                        helper: helperText,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Ad Title*",
                        controller: titleController,
                        helper: "Mention the key features (e.g., brand, model, condition)",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Description*",
                        controller: descriptionController,
                        helper: "Include condition, features, and reason for selling",
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
                              "subcategory": widget.category,
                              "category": "Electronics",
                              "user_id": "${box.get("id")}",
                              "images[]": imageFiles,
                              "latitude": latitude,
                              "longitude": longitude,
                              "price": priceController.text,
                              "json_data": jsonEncode({
                                "brand": nameController.text,
                                "title": titleController.text,
                                "description": descriptionController.text,
                                "price": priceController.text,
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
                                msg: "Electronics Listing Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await service.addProduct(data);
                              Fluttertoast.showToast(
                                msg: "Electronics Listing Added Successfully",
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
                                  "Failed to process electronics listing. Please try again.";
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

                          // Product data ready karo (PlanPage ke liye reuse ke liye)
                          final Map<String, dynamic> productData = {
                            "subcategory": widget.category,  // Dynamic subcategory (jaise Mobile, Laptop etc.)
                            "category": "Electronics",
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": priceController.text,
                            "json_data": jsonEncode({
                              "brand": nameController.text,
                              "title": titleController.text,
                              "description": descriptionController.text,
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
                                msg: "Electronics Listing Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(productData);
                             
                              Fluttertoast.showToast(
                                msg: "Electronics Listing Added Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
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
                                  "Failed to process electronics listing.";

                              if (e.response?.statusCode == 429) {
                                errorMessage = "You can only add one product every 24 hours.";
                              }

                              // Plan/subscription wale errors detect karo
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
                              // Normal error pe user ko current screen pe rehne do ya Home bhej do (optional)
                              // Navigator.pushAndRemoveUntil(...) // agar chaho to yahan daal sakte ho
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
    nameController.dispose();
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      ],
    );
  }
}