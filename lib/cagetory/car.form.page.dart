import 'dart:convert';
import 'dart:developer';
import 'dart:io';
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
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shopping_app_olx/plan/plan.page.dart';
import '../map/map.page.dart';

class CarFormPage extends ConsumerStatefulWidget {
  final List<SellList>? sellList;
  final SellList? productToEdit;
  const CarFormPage({super.key, this.sellList, this.productToEdit});
  @override
  ConsumerState<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends ConsumerState<CarFormPage> {
  final carController = TextEditingController();
  final fuelController = TextEditingController();
  final yearController = TextEditingController();
  final kmDrivenController = TextEditingController();
  final ownerController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final pinCodeController = TextEditingController();
  bool isloading = false;
  List<XFile> images = []; // New images picked by the user
  List<String> existingImageUrls = []; // Existing image URLs from productToEdit
  final picker = ImagePicker();
  bool isEditing = false;
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
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MapPage()));
        }
      });
    }
  }

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
      carController.text = jsonData['car'] ?? '';
      yearController.text = jsonData['Year'] ?? '';
      fuelController.text = jsonData['fuel'] ?? '';
      kmDrivenController.text = jsonData['km driven'] ?? '';
      ownerController.text = jsonData['owner'] ?? '';
      titleController.text = jsonData['title'] ?? '';
      descController.text = jsonData['Des'] ?? '';
      priceController.text = jsonData['price'] ?? '';
      pinCodeController.text = jsonData['pinCode'] ?? '';
    }
    // Load existing image URLs
    if (product.image != null && product.image!.isNotEmpty) {
      setState(() {
        // Assuming image field contains comma-separated URLs
        existingImageUrls =
            product.image!.split(',').map((url) => url.trim()).toList();
      });
    }
  }

  Future<void> pickFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        images.add(photo);
      });
    }
  }

  /// Gallery multiple images
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
                  pickFromCamera();
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
    if (carController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the car details");
      return false;
    }
    if (yearController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the year");
      return false;
    }
    if (fuelController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the fuel type");
      return false;
    }
    if (kmDrivenController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the kilometers driven");
      return false;
    }
    if (ownerController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the number of owners");
      return false;
    }
    if (titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the ad title");
      return false;
    }
    if (descController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the description");
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the price");
      return false;
    }
    final pinCode = pinCodeController.text.trim();
    if (pinCode.length != 6 || int.tryParse(pinCode) == null) {
      Fluttertoast.showToast(msg: "Pin code must be exactly 6 digits");
      return false;
    }
    final year = int.tryParse(yearController.text.trim());
    if (year == null || year < 1990) {
      Fluttertoast.showToast(msg: "Year must be 1990 or later");
      return false;
    }
    if (descController.text.trim().length < 20) {
      Fluttertoast.showToast(
        msg: "Description must be at least 20 characters long",
      );
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
            Positioned(
              child: Column(
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
                    child: Column(
                      children: [
                        Text(
                          isEditing ? "Update Product" : "Include some details",
                          style: GoogleFonts.dmSans(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormBody(labeltxt: "Car*", controller: carController),
                        SizedBox(height: 10.h),
                        FormBody(
                          controller: yearController,
                          labeltxt: 'Year*',
                          helper: "Year has a minimum value of 1990.",
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 10.h),
                        FormBody(labeltxt: 'Fuel*', controller: fuelController),
                        SizedBox(height: 10.h),
                        FormBody(
                          labeltxt: 'KM driven *',
                          maxlenghts: 6,
                          controller: kmDrivenController,
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 10.h),
                        FormBody(
                          controller: ownerController,
                          labeltxt: "No.of Owners*",
                          type: TextInputType.number,
                          maxlenghts: 10,
                          isCounter: '',
                        ),
                        SizedBox(height: 10.h),
                        FormBody(
                          labeltxt: "Ad title *",
                          controller: titleController,
                        ),
                        SizedBox(height: 10.h),
                        FormBody(
                          controller: descController,
                          labeltxt: "Describe what you are selling *",
                          helper:
                              'Include condition, features and reason for selling\nRequired Fields',
                          maxlenghts: 4096,
                        ),
                        SizedBox(height: 10.h),
                        FormBody(
                          labeltxt: "Price*",
                          controller: priceController,
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 10.h),
                        FormBody(
                          maxlenghts: 6,
                          labeltxt: "Pin Code*",
                          controller: pinCodeController,
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 20.h),
                        Container(
                          height: 216.h,
                          child:
                              (images.isEmpty && existingImageUrls.isEmpty)
                                  ? GestureDetector(
                                    onTap: showImage,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
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
                                        // Display existing images from URLs
                                        return Stack(
                                          children: [
                                            Container(
                                              width: 100.w,
                                              margin: EdgeInsets.only(
                                                right: 8.w,
                                              ),
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
                                      } else if (index <
                                          existingImageUrls.length +
                                              images.length) {
                                        // Display new images
                                        final imageIndex =
                                            index - existingImageUrls.length;
                                        return Stack(
                                          children: [
                                            Container(
                                              width: 100.w,
                                              margin: EdgeInsets.only(
                                                right: 8.w,
                                              ),
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
                        //     backgroundColor: Color.fromARGB(255, 137, 26, 255),
                        //   ),
                        //   onPressed: () async {
                        //     if (!_validateForm()) return;

                        //     var box = Hive.box("data");
                        //     double? latitude = box.get('latitude');
                        //     double? longitude = box.get('longitude');

                        //     // Images ko MultipartFile mein convert karo
                        //     List<MultipartFile> imageFiles = [];
                        //     for (var img in images) {
                        //       imageFiles.add(
                        //         await MultipartFile.fromFile(
                        //           img.path,
                        //           filename: img.path.split("/").last,
                        //         ),
                        //       );
                        //     }

                        //     // Yeh data PlanPage pe bhejne ke liye ready karo
                        //     final Map<String, dynamic> productData = {
                        //       "subcategory": "Cars",
                        //       "category": "Cars",
                        //       "user_id": "${box.get("id")}",
                        //       "images[]": imageFiles,
                        //       "latitude": latitude,
                        //       "longitude": longitude,
                        //       "price": priceController.text,
                        //       "json_data": jsonEncode({
                        //         "car": carController.text,
                        //         "Year": yearController.text,
                        //         "fuel": fuelController.text,
                        //         "km driven": kmDrivenController.text,
                        //         "owner":
                        //             ownerController
                        //                 .text, // Fixed: pehle galat tha
                        //         "title": titleController.text,
                        //         "Des": descController.text,
                        //         "price": priceController.text,
                        //         "pinCode": pinCodeController.text,
                        //       }),
                        //     };

                        //     // Editing mode mein existing images add karo
                        //     if (isEditing &&
                        //         widget.productToEdit != null &&
                        //         existingImageUrls.isNotEmpty) {
                        //       productData['existing_images'] = existingImageUrls
                        //           .join(',');
                        //     }

                        //     try {
                        //       setState(() => isloading = true);

                        //       final apiService = APIService(await createDio());

                        //       if (isEditing && widget.productToEdit != null) {
                        //         final data = await apiService.updateProduct(
                        //           widget.productToEdit!.id!,
                        //           productData,
                        //         );

                        //         Fluttertoast.showToast(
                        //           msg: "Product Updated Successfully",
                        //         );
                        //       } else {
                        //         final resdaata = await apiService.addProduct(
                        //           productData,
                        //         );
                        //         log(resdaata.data.toString());

                        //         Fluttertoast.showToast(
                        //           msg: "Product Added Successfully",
                        //         );
                        //       }

                        //       // Success → Home pe bhejo (stack clear kar do)
                        //       Navigator.pushAndRemoveUntil(
                        //         context,
                        //         CupertinoPageRoute(builder: (_) => HomePage()),
                        //         (route) => false,
                        //       );
                        //     } catch (e) {
                        //       log("Error: ${e.toString()}");
                        //       setState(() => isloading = false);

                        //       String errorMessage =
                        //           "An error occurred. Please try again.";
                        //       bool needsPlan = false;

                        //       if (e is DioError) {
                        //         errorMessage =
                        //             e.response?.data['message']?.toString() ??
                        //             "Failed to process product.";

                        //         if (e.response?.statusCode == 429) {
                        //           errorMessage =
                        //               "You can only add one product every 24 hours.";
                        //         }

                        //         // Check if plan is required
                        //         if (errorMessage.toLowerCase().contains(
                        //               "plan",
                        //             ) ||
                        //             errorMessage.toLowerCase().contains(
                        //               "purchase",
                        //             ) ||
                        //             errorMessage.toLowerCase().contains(
                        //               "subscription",
                        //             )) {
                        //           needsPlan = true;
                        //         }
                        //       }

                        //       Fluttertoast.showToast(msg: errorMessage);

                        //       if (needsPlan) {
                        //         // PlanPage pe jao aur pending data pass kar do
                        //         Navigator.push(
                        //           context,
                        //           CupertinoPageRoute(
                        //             builder:
                        //                 (context) =>
                        //                     PlanPage(productData, true),
                        //           ),
                        //         );
                        //       } else {
                        //         // Normal error → Home ya rehne do
                        //         // Navigator.push(...) optional
                        //       }
                        //     }
                        //   },
                        //   child: Center(
                        //     child:
                        //         isloading
                        //             ? const CircularProgressIndicator(
                        //               color: Colors.white,
                        //             )
                        //             : Text(
                        //               isEditing ? "Update" : "Continue",
                        //               style: GoogleFonts.dmSans(
                        //                 fontSize: 15.sp,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: Colors.white,
                        //               ),
                        //             ),
                        //   ),
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              MediaQuery.of(context).size.width,
                              49.h,
                            ),
                            backgroundColor: Color.fromARGB(255, 137, 26, 255),
                          ),
                          onPressed: () async {
                            if (!_validateForm()) return;
                            final box = Hive.box("data");
                            double? latitude = box.get('latitude');
                            double? longitude = box.get('longitude');
                            try {
                              setState(() => isloading = true);

                              /// 🔹 Step 1: Create FormData
                              FormData formData = FormData.fromMap({
                                "subcategory": "Cars",
                                "category": "Cars",
                                "user_id": box.get("id").toString(),
                                "latitude": latitude?.toString() ?? "",
                                "longitude": longitude?.toString() ?? "",
                                "price": priceController.text,
                                "json_data": jsonEncode({
                                  "car": carController.text,
                                  "Year": yearController.text,
                                  "fuel": fuelController.text,
                                  "km driven": kmDrivenController.text,
                                  "owner": ownerController.text,
                                  "title": titleController.text,
                                  "Des": descController.text,
                                  "price": priceController.text,
                                  "pinCode": pinCodeController.text,
                                }),
                              });

                              /// 🔹 Step 2: Add Images (IMPORTANT)
                              for (var img in images) {
                                formData.files.add(
                                  MapEntry(
                                    "images[]", // backend expects this
                                    await MultipartFile.fromFile(
                                      img.path,
                                      filename: img.path.split('/').last,
                                    ),
                                  ),
                                );
                              }

                              /// 🔹 Step 3: API Call
                              final apiService = APIService(await createDio());

                              if (isEditing && widget.productToEdit != null) {
                                final data = await apiService
                                    .updateProductFormData(
                                      widget.productToEdit!.id!,
                                      formData,
                                    );

                                Fluttertoast.showToast(
                                  msg: "Product Updated Successfully",
                                );
                              } else {
                                final response = await apiService
                                    .productFormData(formData);
                                log(response.data.toString());

                                Fluttertoast.showToast(
                                  msg: "Product Added Successfully",
                                );
                              }

                              Fluttertoast.showToast(
                                msg: "Product Added Successfully",
                              );

                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(builder: (_) => HomePage()),
                                (route) => false,
                              );
                            } on DioException catch (e) {
                              setState(() => isloading = false);

                              log("ADD ERROR: ${e.response?.data}");

                              String message =
                                  e.response?.data['message']?.toString() ??
                                  "Add product failed";

                              Fluttertoast.showToast(msg: message);
                              setState(() => isloading = false);
                              log("ERROR: $e");
                              Fluttertoast.showToast(
                                msg: "Something went wrong",
                              );
                              String errorMessage =
                                  "An error occurred. Please try again.";
                              bool needsPlan = false;

                              errorMessage =
                                  e.response?.data['message']?.toString() ??
                                  "Failed to process product.";

                              if (e.response?.statusCode == 429) {
                                errorMessage =
                                    "You can only add one product every 24 hours.";
                              }

                              // Check if plan is required
                              if (errorMessage.toLowerCase().contains("plan") ||
                                  errorMessage.toLowerCase().contains(
                                    "purchase",
                                  ) ||
                                  errorMessage.toLowerCase().contains(
                                    "subscription",
                                  )) {
                                setState(() {
                                  needsPlan = true;
                                });
                              }
                              if (needsPlan == true) {
                                // PlanPage pe jao aur pending data pass kar do
                                final Map<String, dynamic> productData = {
                                  "subcategory": "Cars",
                                  "category": "Cars",
                                  "user_id": "${box.get("id")}",
                                  // "images[]": imageFiles,
                                  "latitude": latitude,
                                  "longitude": longitude,
                                  "price": priceController.text,
                                  "json_data": jsonEncode({
                                    "car": carController.text,
                                    "Year": yearController.text,
                                    "fuel": fuelController.text,
                                    "km driven": kmDrivenController.text,
                                    "owner":
                                        ownerController
                                            .text, // Fixed: pehle galat tha
                                    "title": titleController.text,
                                    "Des": descController.text,
                                    "price": priceController.text,
                                    "pinCode": pinCodeController.text,
                                  }),
                                };
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder:
                                        (context) =>
                                            PlanPage(productData, true),
                                  ),
                                );
                              } else {
                                // Normal error → Home ya rehne do
                                // Navigator.push(...) optional
                              }
                            } catch (e) {
                              // Fluttertoast.showToast(msg: errorMessage);
                            }
                          },
                          child: Center(
                            child:
                                isloading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
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
  final String? isCounter;
  const FormBody({
    super.key,
    required this.labeltxt,
    this.helper,
    this.maxlenghts,
    this.type,
    this.isCounter,
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
            counterText: isCounter,
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
