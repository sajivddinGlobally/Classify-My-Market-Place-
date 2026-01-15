import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'HelpSupportService.dart';
import 'helpSupportBodyModel.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final nameController = TextEditingController();
  final messageController = TextEditingController();
  bool isSubmitting = false;
  File? selectedImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Pre-fill name if available in Hive
    final box = Hive.box("data");
    final savedName = box.get("full_name") ?? box.get("name");
    if (savedName != null) {
      nameController.text = savedName.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  // Submit help request
  Future<void> submitHelpRequest() async {
    final box = Hive.box("data");
    final userId = box.get("id");

    if (userId == null) {
      Fluttertoast.showToast(msg: "Please login to continue");
      return;
    }



    if (messageController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please describe your issue");
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final service = HelpSupportService(createDio());

      final body = HelpSupportBodyModel(
        userId: userId.toString(),
        // name: nameController.text.trim(),
        description: messageController.text.trim(),
        // image: selectedImage, // nullable File – backend should handle it
      );

      final response = await service.helpSupport(body);

      if (response.status == true) {
        Fluttertoast.showToast(
          msg: response.message ?? "Your request has been submitted successfully!",
          backgroundColor: Colors.green,
        );
        Navigator.pop(context); // Go back after success
      } else {
        Fluttertoast.showToast(
          msg: response.message ?? "Failed to submit request",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Help & Support Error: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            
            Positioned.fill(
              child: Image.asset(
                "assets/bgimage.png",
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.3),
              ),
            ),
            // Back Button
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
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            // Main Content
            Positioned(
              top: 140.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Center(
                      child: Text(
                        "Help & Support",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 26.sp,
                          color: const Color(0xFF242126),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Message Field
                    _buildTextField(
                      controller: messageController,
                      label: "Describe Your Issue",
                      hint: "Write your message here...",
                      maxLines: 6,
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    SizedBox(height: 40.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : submitHelpRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 137, 26, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.r),
                          ),
                        ),
                        child: isSubmitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Submit Request",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable TextField Widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: const BorderSide(color: Color.fromARGB(255, 137, 26, 255)),
            ),
          ),
        ),
      ],
    );
  }
}





