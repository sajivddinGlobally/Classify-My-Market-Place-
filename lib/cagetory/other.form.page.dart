import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' show MultipartFile;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/new/new.service.dart';

class OtherFormPage extends StatefulWidget {
  const OtherFormPage({super.key});

  @override
  State<OtherFormPage> createState() => _OtherFormPageState();
}

class _OtherFormPageState extends State<OtherFormPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final nameController = TextEditingController();

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
      // Use Permission.storage for Android 10 and below
      var status = await Permission.storage.status;
      print("Initial storage permission status (Android 10): $status");

      if (!status.isGranted) {
        status = await Permission.storage.request();
        print("Requested storage permission status: $status");
      }

      if (status.isGranted) {
        print("Opening gallery for multiple image selection");
        final pickedFiles = await picker.pickMultiImage(
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );
        if (pickedFiles.isNotEmpty) {
          setState(() {
            images.addAll(pickedFiles.take(5 - images.length)); // Limit to 5 images
          });
          print("Selected ${pickedFiles.length} images: ${pickedFiles.map((e) => e.path).toList()}");
          Fluttertoast.showToast(
            msg: "Selected ${pickedFiles.length} images",
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          print("No images selected from gallery");
          Fluttertoast.showToast(
            msg: "No images selected",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else if (status.isDenied) {
        print("Storage permission denied");
        Fluttertoast.showToast(
          msg: "Please grant storage permission to select images",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (status.isPermanentlyDenied) {
        print("Storage permission permanently denied");
        Fluttertoast.showToast(
          msg: "Please enable storage permission in your device settings",
          toastLength: Toast.LENGTH_LONG,
        );
        await openAppSettings();
      } else {
        print("Unexpected permission status: $status");
        Fluttertoast.showToast(
          msg: "Unable to access gallery due to permission issue",
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e, stackTrace) {
      print("Error picking images: $e");
      print("Stack trace: $stackTrace");
      Fluttertoast.showToast(
        msg: "Failed to pick images: $e",
        toastLength: Toast.LENGTH_LONG,
      );
    }
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


/*  Future<void> pickImageFormCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final PickedFile = await picker.pickImage(source: ImageSource.camera);
      if (PickedFile != null) {
        setState(() {
          image = File(PickedFile.path);
        });
      }
    } else {
      print("Camera Permission isdenied");
    }
  }

  Future<void> pickImageFromGallery() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final PickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (PickedFile != null) {
        setState(() {
          image = File(PickedFile.path);
        });
      }
    } else {
      print("Gallery Permission isdenied");
    }
  }

  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  pickImageFormCamera();
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
      body: Stack(
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
                  "Furniture Include some details",
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
                    // GestureDetector(
                    //   onTap: () {
                    //     showImage();
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 216.h,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(15.r),
                    //       color: Colors.white,
                    //       border: Border.all(color: Colors.grey, width: 1.w),
                    //     ),
                    //     child:
                    //         image == null
                    //             ? Column(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: [
                    //                 Icon(Icons.upload),
                    //                 Text("Upload Image"),
                    //               ],
                    //             )
                    //             : ClipRRect(
                    //               borderRadius: BorderRadius.circular(15.r),
                    //               child: Image.file(
                    //                 image!,
                    //                 width: MediaQuery.of(context).size.width,
                    //                 height: 216.h,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //   ),
                    // ),

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
                        // var box = Hive.box("data");
                        // double? latitude = box.get('latitude');
                        // double? longitude = box.get('longitude');
                        // try {
                        //   setState(() {
                        //     isProperty = true;
                        //   });

                        //   final apiservice = APIService(createDio());
                        //   List<MultipartFile> imageFiles = [];
                        //   for (var img in images) {
                        //     imageFiles.add(await MultipartFile.fromFile(
                        //       img.path,
                        //       filename: img.path.split("/").last,
                        //     ));
                        //   }
                        //   await apiservice.addProduct({
                        //     "category": "test",
                        //     "user_id": "${box.get("id")}",
                        //     "images[]": imageFiles, // Changed from "image" to "images"
                        //     "latitude": latitude,
                        //     "longitude": longitude,
                        //     // "image": await MultipartFile.fromFile(
                        //     //   image!.path,
                        //     //   filename: image!.path.split("/").last,
                        //     // ),
                        //     "data_json": jsonEncode({
                        //       "title": titleController.text,
                        //       "desc": descController.text,
                        //     }),
                        //   });
                        //   Fluttertoast.showToast(
                        //     msg: "Product Add Successfull",
                        //   );
                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     CupertinoPageRoute(
                        //       builder: (context) => HomePage(),
                        //     ),
                        //     (route) => false,
                        //   );
                        // } catch (e) {
                        //   log(e.toString());
                        //   setState(() {
                        //     isProperty = false;
                        //   });
                        //   Fluttertoast.showToast(msg: "Product Add Failed");
                        // }
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
    );
  }
}
