

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
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../choseMap/controller/locationNotifer.dart';
import '../choseMap/mapView.dart';
import '../config/pretty.dio.dart';
import '../home/home.page.dart';
import '../listing/model/getlistingModel.dart';
import '../new/new.service.dart';
import '../plan/plan.page.dart';
import 'ServiceBookForm.dart';

class SparePartsFormPage extends ConsumerStatefulWidget {
  final SellList? productToEdit;
   SparePartsFormPage({super.key,this.productToEdit});
  @override
  ConsumerState<SparePartsFormPage> createState() => _SparePartsFormPageState();
}
class _SparePartsFormPageState extends ConsumerState<SparePartsFormPage> {
  final partNumberController = TextEditingController();
  final conditionController = TextEditingController();
  final typeController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final picker = ImagePicker();
  List<XFile> images = [];
  bool isLoading = false;
  bool _didRedirect = false;
  List<String> existingImageUrls = [];
  Future<void> pickImageFromCamera() async {
    final XFile? photo =
    await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        images.add(photo);
      });
    }
  }
  // bool isLoading = false;
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
    if (typeController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the part type");
      return false;
    }
    if (conditionController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the condition");
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
      "part_number": partNumberController.text,
      "condition": conditionController.text,
      "type": typeController.text,
      "title": titleController.text,
      "description": descriptionController.text,
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
                    "Spare Parts Listing",
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
                        labeltxt: "Part Type*",
                        controller: typeController,
                        helper: "e.g., Engine, Tire, Brake",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Part Number",
                        controller: partNumberController,
                        helper: "e.g., ABC123XYZ",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Condition*",
                        controller: conditionController,
                        helper: "e.g., New, Used, Refurbished",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Ad Title*",
                        controller: titleController,
                        helper:
                        "Mention key features (e.g., brand, part type, condition)",
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Description*",
                        controller: descriptionController,
                        helper:
                        "Include condition, compatibility, and reason for selling",
                        // maxLength: 4096,
                      ),
                      SizedBox(height: 15.h),
                      FormBody(
                        labeltxt: "Price*",
                        controller: priceController,
                        // type: TextInputType.number,
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

                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     minimumSize: Size(
                      //       MediaQuery.of(context).size.width,
                      //       49.h,
                      //     ),
                      //     backgroundColor: const Color.fromARGB(255, 137, 26, 255),
                      //   ),
                      //   onPressed: isLoading
                      //       ? null
                      //       : () async {
                      //     if (!_validateForm()) {
                      //       return;
                      //     }
                      //     var box = Hive.box("data");
                      //     double? latitude = box.get('latitude');
                      //     double? longitude = box.get('longitude');
                      //     try {
                      //       setState(() {
                      //         isLoading = true;
                      //       });
                      //       final service = APIService(await createDio());
                      //       List<MultipartFile> imageFiles = [];
                      //       for (var img in images) {
                      //         imageFiles.add(await MultipartFile.fromFile(
                      //           img.path,
                      //           filename: img.path.split("/").last,
                      //         ));
                      //       }
                      //       await service.addProduct({
                      //         "category": "Spare Parts",
                      //         "user_id": "${box.get("id")}",
                      //         "images[]": imageFiles,
                      //         "latitude": latitude,
                      //         "longitude": longitude,
                      //         "price": priceController.text,
                      //         "json_data": jsonEncode({
                      //           "part_number": partNumberController.text,
                      //           "condition": conditionController.text,
                      //           "type": typeController.text,
                      //           "title": titleController.text,
                      //           "description": descriptionController.text,
                      //           "price": priceController.text,
                      //         }),
                      //       });
                      //       Fluttertoast.showToast(
                      //         msg: "Spare Part Added Successfully",
                      //         toastLength: Toast.LENGTH_LONG,
                      //       );
                      //       Navigator.push(
                      //         context,
                      //         CupertinoPageRoute(
                      //           builder: (context) => PlanPage(true),
                      //         ),
                      //       );
                      //     } catch (e) {
                      //       log(e.toString());
                      //       Fluttertoast.showToast(
                      //         msg: "Spare Part Add Failed: $e",
                      //         toastLength: Toast.LENGTH_LONG,
                      //       );
                      //     } finally {
                      //       setState(() {
                      //         isLoading = false;
                      //       });
                      //     }
                      //   },
                      //   child: Center(
                      //     child: isLoading
                      //         ? SizedBox(
                      //       width: 20.w,
                      //       height: 20.h,
                      //       child: const CircularProgressIndicator(
                      //         color: Colors.white,
                      //       ),
                      //     )
                      //         : Text(
                      //       "Continue",
                      //       style: GoogleFonts.dmSans(
                      //         fontSize: 15.sp,
                      //         fontWeight: FontWeight.w500,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // ),

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
                            "subcategory": "SpareParts",
                            "category": "Commercials",
                            "user_id": "${box.get("id")}",
                            "images[]": imageFiles,
                            "latitude": latitude,
                            "longitude": longitude,
                            "price": priceController.text,
                            "json_data": jsonEncode({
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
                                msg: "Spare Parts Listing Updated Successfully",
                                toastLength: Toast.LENGTH_LONG,
                              );
                            } else {
                              await apiService.addProduct(productData);
                             
                              Fluttertoast.showToast(
                                msg: "Spare Parts Listing Added Successfully",
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
                                  "Failed to process spare parts listing.";

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
    partNumberController.dispose();
    conditionController.dispose();
    typeController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }
}