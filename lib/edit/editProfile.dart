import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/edit/updateController.dart';
import 'package:shopping_app_olx/register/register.page.dart'; // Ensure RegisterBody is defined here

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final nameController = TextEditingController();
  bool isUpdating = false;
  File? image;
  final picker = ImagePicker();

  Future<void> pickImageFromCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.camera,
        );
        if (pickedFile != null && mounted) {
          setState(() {
            image = File(pickedFile.path);
          });
        }
      } else {
        debugPrint("Camera permission denied");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Camera permission denied")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking image from camera: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
      }
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final status =
          await Permission.camera.request(); // Correct permission for gallery
      if (status.isGranted) {
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile != null && mounted) {
          setState(() {
            image = File(pickedFile.path);
          });
        }
      } else {
        debugPrint("Gallery permission denied");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gallery permission denied")),
          );
        }
      }
    } catch (e) {
      debugPrint("Error picking image from gallery: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to pick image: $e")));
      }
    }
  }

  Future<void> showImagePicker() async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
                child: const Text("Gallery"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
                child: const Text("Camera"),
              ),
              CupertinoActionSheetAction(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
                isDestructiveAction: true,
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box("data");
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            // Ensure "assets/bgimage.png" exists in pubspec.yaml
            Positioned.fill(
              child: Image.asset("assets/bgimage.png", fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 60.h),
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
            Positioned(
              top: 150.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        "Edit Your Profile",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 26.sp,
                          color: const Color(0xFF242126),
                          letterSpacing: -0.65,
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    // Ensure RegisterBody is defined in register.page.dart
                    RegisterBody(
                      title: "Name",
                      controller: nameController,
                      type: TextInputType.text,
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: showImagePicker,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: Colors.white,
                        ),
                        child:
                            image == null
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_upload_outlined,
                                      color: const Color.fromARGB(
                                        255,
                                        137,
                                        26,
                                        255,
                                      ),
                                      size: 30.sp,
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      "Upload your image",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromARGB(
                                          255,
                                          97,
                                          91,
                                          104,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "PNG, JPG are supported with 5MB limit",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                          255,
                                          119,
                                          112,
                                          128,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Image.file(image!, fit: BoxFit.cover),
                                ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap:
                          isUpdating
                              ? null
                              : () async {
                                if (nameController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter a name"),
                                    ),
                                  );
                                  return;
                                }
                                if (image == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select an image"),
                                    ),
                                  );
                                  return;
                                }
                                try {
                                  setState(() => isUpdating = true);
                                  await UpdateController.UpdateProfile(
                                    user_id: box.get("id").toString(),
                                    full_name: nameController.text,
                                    images: image!,
                                    context: context,
                                  );
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Profile updated successfully",
                                        ),
                                      ),
                                    );
                                    setState(() => isUpdating = false);
                                    // Navigator.pop(context); // Navigate back on success
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Update failed: $e"),
                                      ),
                                    );
                                    setState(() => isUpdating = false);
                                  }
                                }
                              },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 49.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.45.r),
                          border: Border.all(
                            color: const Color.fromARGB(255, 137, 26, 255),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child:
                              isUpdating
                                  ? const CircularProgressIndicator(
                                    color: Color.fromARGB(255, 137, 26, 255),
                                  )
                                  : Text(
                                    "Next",
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
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
