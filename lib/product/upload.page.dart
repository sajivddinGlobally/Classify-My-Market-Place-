// import 'dart:developer';
// import 'dart:io';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shopping_app_olx/product/productSpecification.page.dart';
// import 'package:shopping_app_olx/product/uploadproductimagecontroller.dart';

// class UploadPage extends StatefulWidget {
//   final String productId;
//   const UploadPage({super.key, required this.productId});

//   @override
//   State<UploadPage> createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   List<File> images = [];

//   Future<void> pickeImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     );
//     if (result != null) {
//       setState(() {
//         images = result.paths.map((path) => File(path!)).toList();
//       });
//     }
//   }

//   bool isUpload = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
//               ),
//             ),
//           ),
//           Image.asset("assets/bgimage.png"),
//           Padding(
//             padding: EdgeInsets.only(left: 20.w, top: 60.h),
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 width: 46.w,
//                 height: 46.h,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//                 child: Icon(Icons.arrow_back),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 168.h,
//             left: 0,
//             right: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     "Upload  Product Image",
//                     style: GoogleFonts.dmSans(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 26.sp,
//                       color: Color(0xFF242126),
//                       letterSpacing: -0.65,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 44.w, right: 44.w),
//                   child: Text(
//                     textAlign: TextAlign.center,
//                     "Upload picture of your products, add multiple images to better reach",
//                     style: GoogleFonts.dmSans(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16.sp,
//                       color: Color(0xFF615B68),
//                       letterSpacing: -0.40,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 40.h),
//                 Padding(
//                   padding: EdgeInsets.only(left: 20.w, right: 20.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Upload Image",
//                         style: GoogleFonts.dmSans(
//                           fontSize: 15.sp,
//                           fontWeight: FontWeight.w500,
//                           color: Color.fromARGB(255, 97, 91, 104),
//                         ),
//                       ),
//                       SizedBox(height: 12.h),
//                       GestureDetector(
//                         onTap: () {
//                           pickeImage();
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 180.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20.r),
//                             color: Colors.white,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.file_upload_outlined,
//                                 color: Color.fromARGB(255, 137, 26, 255),
//                                 size: 30.sp,
//                               ),
//                               SizedBox(height: 6.h),
//                               Text(
//                                 "Upload your image",
//                                 style: GoogleFonts.dmSans(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color.fromARGB(255, 97, 91, 104),
//                                 ),
//                               ),
//                               Text(
//                                 "PNG, JPG are supported with 5mb limit",
//                                 style: GoogleFonts.dmSans(
//                                   fontSize: 15.sp,
//                                   fontWeight: FontWeight.w400,
//                                   color: Color.fromARGB(255, 119, 112, 128),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.h),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 20.w,
//                           right: 20.w,
//                           top: 15.h,
//                         ),
//                         child: Row(
//                           children: [
//                             images.isNotEmpty
//                                 ? Wrap(
//                                   spacing: 10.w,
//                                   runSpacing: 10.h,
//                                   children:
//                                       images.map((file) {
//                                         return Stack(
//                                           clipBehavior:
//                                               Clip.none, // Important to allow overflow
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.r),
//                                               child: Image.file(
//                                                 file,
//                                                 width: 100.w,
//                                                 height: 100.h,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                             Positioned(
//                                               right: -6.w,
//                                               top: -10.h,
//                                               child: GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     images.remove(file);
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   width: 30.w,
//                                                   height: 30.h,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.red,
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                   child: Icon(
//                                                     Icons.close,
//                                                     size: 16.sp,
//                                                     color: Colors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       }).toList(),
//                                 )
//                                 : Container(),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 100.h),
//                       Padding(
//                         padding: EdgeInsets.only(left: 20.w, right: 20.r),
//                         child: GestureDetector(
//                           onTap: () async {
//                             try {
//                               setState(() {
//                                 isUpload = true;
//                               });

//                               final upload =
//                                   await Uploadproductimagecontroller.uploadProductImages(
//                                     productId: widget.productId,
//                                     images: images,
//                                   );

//                               // print(
//                               //   "Upload Response: $upload",
//                               // ); // Confirm success

//                               Fluttertoast.showToast(
//                                 msg: "Image Upload successful",
//                               );
//                               if (!mounted) return;
//                               print(
//                                 "Navigating to ProductspecificationPage...",
//                               );
//                               Navigator.push(
//                                 context,
//                                 CupertinoPageRoute(
//                                   builder:
//                                       (context) => ProductspecificationPage(
//                                         productId: widget.productId.toString(),
//                                       ),
//                                 ),
//                               );
//                             } catch (e) {
//                               Fluttertoast.showToast(msg: "Upload failed: $e");
//                               setState(() {
//                                 isUpload = false;
//                               });
//                             }
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 49.h,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(35.45.r),
//                               border: Border.all(
//                                 color: Color.fromARGB(255, 137, 26, 255),
//                                 width: 1.w,
//                               ),
//                             ),
//                             child: Center(
//                               child:
//                                   isUpload == false
//                                       ? Text(
//                                         "Next",
//                                         style: GoogleFonts.dmSans(
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: Color.fromARGB(
//                                             255,
//                                             137,
//                                             26,
//                                             255,
//                                           ),
//                                         ),
//                                       )
//                                       : CircularProgressIndicator(
//                                         color: Color.fromARGB(
//                                           255,
//                                           137,
//                                           26,
//                                           255,
//                                         ),
//                                       ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
