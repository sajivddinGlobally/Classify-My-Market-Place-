import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shopping_app_olx/chat/chating.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/particularDeals/service/particularProductController.dart';
import 'package:shopping_app_olx/particularDeals/service/viewProvider.dart';
import 'package:shopping_app_olx/report/reportAdBodyModel.dart';
import 'package:shopping_app_olx/report/reportAdService.dart';
import '../like/model/likeBodyModel.dart';
import '../like/service/likeController.dart';

class ParticularDealsPage extends ConsumerStatefulWidget {
  final String id;
  const ParticularDealsPage({super.key, required this.id});
  @override
  ConsumerState<ParticularDealsPage> createState() =>
      _ParticularDealsPageState();
}

class _ParticularDealsPageState extends ConsumerState<ParticularDealsPage> {
  static const String baseImageUrl1 =
      'https://classify.mymarketplace.co.in/public';
    static const String baseImageUrl = '';
    static const String fallbackImageUrl =
      'https://www.irisoele.com/img/noimage.png';


    @override
    void initState() {
    super.initState();
    fetchProductData();
    }

  Future<void> fetchProductData() async {
    final box = Hive.box("data");
    final userId = box.get("id") ?? "";
    await ViewClass.fetchProduct(userId: userId, productId: widget.id);
  }

  // Function to show zoomable image in a dialog
  void _showZoomableImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder:
                    (context, error, stackTrace) =>
                        Image.network(fallbackImageUrl, fit: BoxFit.contain),
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateCarouselHeight(int itemCount) {
    // Adjust height for carousel; single image height with padding
    const itemHeight = 200.0; // Fixed height for carousel images
    const margin = 10.0;
    return itemHeight + 2 * margin; // Add margin for top and bottom
  }

  void _showReportDialog(String userId, int productId) {
    final TextEditingController reportController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            "Report Issue",
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: reportController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Describe your issue here...",
              hintStyle: GoogleFonts.inter(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.inter(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF086E86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final reason = reportController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter your report reason"),
                    ),
                  );
                  return;
                }
                try {
                  final body = ReportAdBodyModel(
                    userId: userId,
                    productId: productId.toString(),
                    reason: reason,
                  );
                  final service = ReportAdService(createDio());
                  final response = await service.reportIsue(body);
                  if (response.success == true) {
                    Fluttertoast.showToast(msg: response.message);
                    log("Report Reason: $reason");
                    Navigator.pop(context);
                  } else {
                    Fluttertoast.showToast(msg: response.message);
                  }
                } catch (e, st) {
                  log("${e.toString()}/n ${st.toString()}");
                  Fluttertoast.showToast(msg: "Api Error : $e");
                }
              },
              child: Text(
                "OK",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");
    var userId = box.get("id");
    final particularProvider = ref.watch(
      particularController((id: widget.id, userId: userId)),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 247),
      body: particularProvider.when(
        data: (particular) {
          if (particular == null ||
              particular.data == null ||
              particular.data!.product == null) {
            return const Center(child: Text('No data available'));
          }
          Map<String, dynamic> jsonData = {};
          try {
            jsonData =
                particular.data!.product!.jsonData != null
                    ? jsonDecode(particular.data!.product!.jsonData!)
                    : {};
          } catch (e) {
            print('Error parsing json_data: $e');
          }
          final jsonDataEntries = jsonData.entries.toList();
          final imageList =
              particular.data!.product!.image?.isNotEmpty ?? false
                  ? particular.data!.product!.image!
                      .map(
                        (img) =>
                            img.isNotEmpty
                                ? '$baseImageUrl$img'
                                : fallbackImageUrl,
                      )
                      .toList()
                  : [fallbackImageUrl];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Stack(
                  children: [
                    SizedBox(
                      height: _calculateCarouselHeight(imageList.length).h,
                      child: CarouselSlider.builder(
                        itemCount: imageList.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap:
                                () => _showZoomableImage(
                                  context,
                                  imageList[index],
                                ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 5.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    137,
                                    26,
                                    255,
                                  ),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.sp),
                                child: Image.network(
                                  height: 200.h,
                                  width: double.infinity,
                                  imageList[index],
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.network(
                                            fallbackImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: _calculateCarouselHeight(imageList.length).h,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          enableInfiniteScroll: imageList.length > 1,
                          autoPlay: imageList.length > 1,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20.h,
                      left: 20.w,
                      right: 10.w,
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w),
                        width: MediaQuery.of(context).size.width - 30.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
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
                                child: const Center(
                                  child: Icon(Icons.arrow_back),
                                ),
                              ),
                            ),

                            // GestureDetector(
                            //   onTap: () async {
                            //     bool isLiked = particular.userLike ?? false;
                            //     final body = LikeBodyModel(
                            //       productId: particular.data!.product!.id.toString(),
                            //       type: "like",
                            //       userId: "${box.get("id")}",
                            //     );
                            //     await ref
                            //         .read(likeNotiferProvider.notifier)
                            //         .likeProduct(body);
                            //     ref.invalidate(particularController);
                            //     await Future.delayed(Duration.zero);
                            //     Fluttertoast.showToast(
                            //       msg: isLiked
                            //           ? "Removed from Liked"
                            //           : "Added to Liked",
                            //       toastLength: Toast.LENGTH_SHORT,
                            //       gravity: ToastGravity.BOTTOM,
                            //     );
                            //   },
                            //   child: Container(
                            //     width: 46.w,
                            //     height: 46.h,
                            //     decoration: const BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       color: Colors.white,
                            //     ),
                            //     child: Center(
                            //       child: Icon(
                            //         particular.userLike ?? false
                            //             ? Icons.favorite
                            //             : Icons.favorite_border,
                            //         color: particular.userLike ?? false
                            //             ? Colors.red
                            //             : Colors.grey,
                            //         size: 18.sp,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 20.h),
                  child: Row(
                    children: [
                      Container(
                        height: 26.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: const Color.fromARGB(25, 137, 26, 255),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 15.sp,
                                color: const Color.fromARGB(255, 137, 26, 255),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                particular.data!.product!.category ??
                                    'Unknown Category',
                                style: GoogleFonts.dmSans(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(
                                    255,
                                    137,
                                    26,
                                    255,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            "Likes",
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 97, 91, 104),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              bool isLiked = particular.userLike ?? false;
                              final body = LikeBodyModel(
                                productId:
                                    particular.data!.product!.id.toString(),
                                type: "like",
                                userId: "${box.get("id")}",
                              );
                              await ref
                                  .read(likeNotiferProvider.notifier)
                                  .likeProduct(body);
                              ref.invalidate(particularController);
                              await Future.delayed(Duration.zero);
                              Fluttertoast.showToast(
                                msg:
                                    isLiked
                                        ? "Removed from Liked"
                                        : "Added to Liked",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Container(
                              width: 36.w,
                              height: 36.h,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(25, 137, 26, 255),
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    particular.likes?.toString() ?? "0",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                        255,
                                        97,
                                        91,
                                        104,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20.w),
                    ],
                  ),
                ),
                // SizedBox(height: 16.h),

                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        jsonDataEntries.map((item) {
                          final key = item.key.toString();
                          final value = item.value?.toString() ?? 'N/A';
                          return ProductDesc(name: key, title: value);
                        }).toList(),
                  ),
                ),

                SizedBox(height: 40.h),
                Container(
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50, // light purple background for the whole row
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.purple.shade200, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Product Id",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade900, // deep purple for label
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade600, // solid purple background
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          particular.data!.product!.id.toString() ?? "-",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // white text on purple background
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //height: 255.h,
                    // padding: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Padding(
                          padding: EdgeInsets.only(left: 16.w, top: 16.h),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.network(
                                  particular.data!.user?.image != null &&
                                          particular
                                              .data!
                                              .user!
                                              .image!
                                              .isNotEmpty
                                      ? '$baseImageUrl1${particular.data!.user!.image}'
                                      : fallbackImageUrl,
                                  width: 110.w,
                                  height: 84.h,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Image.network(
                                            width: 110.w,
                                            height: 84.h,
                                            fallbackImageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                ),
                              ),
                              SizedBox(width: 10.w),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    particular.data!.user?.fullName ??
                                        'Unknown User',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                        255,
                                        97,
                                        91,
                                        104,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    particular.data!.user?.address ??
                                        'Unknown City',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromARGB(
                                        255,
                                        137,
                                        26,
                                        255,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /* Padding(
                          padding: EdgeInsets.only(left: 16.w, top: 16.h),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: Image.network(
                                  particular.data!.user?.image != null &&
                                      particular.data!.user!.image!.isNotEmpty
                                      ? '$baseImageUrl${particular.data!.user!.image}'
                                      : fallbackImageUrl,
                                  width: 110.w,
                                  height: 84.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.network(
                                    fallbackImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      particular.data!.user?.fullName ?? 'Unknown User',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(255, 97, 91, 104),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      particular.data!.user?.city ?? 'Unknown City',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(255, 137, 26, 255),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),*/

                        // import 'package:cached_network_image/cached_network_image.dart';
                        //   Padding(
                        //   padding: EdgeInsets.only(left: 16.w, top: 16.h),
                        //   child: Row(
                        //     children: [
                        //       ClipRRect(
                        //         borderRadius: BorderRadius.circular(15.r),
                        //         child: CachedNetworkImage(
                        //           imageUrl: _buildImageUrl(particular.data?.user?.image, baseImageUrl, fallbackImageUrl),
                        //           width: 110.w,
                        //           height: 84.h,
                        //           fit: BoxFit.cover,
                        //           placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        //           errorWidget: (context, url, error) {
                        //             print('Image load error: $error'); // Log error
                        //             return Image.asset(
                        //               'assets/images/fallback_image.png',
                        //               width: 110.w,
                        //               height: 84.h,
                        //               fit: BoxFit.cover,
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //       SizedBox(width: 10.w),
                        //       Expanded(
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               particular.data?.user?.fullName ?? 'Unknown User',
                        //               style: GoogleFonts.dmSans(
                        //                 fontSize: 20.sp,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: const Color.fromARGB(255, 97, 91, 104),
                        //               ),
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //             Text(
                        //               particular.data?.user?.city ?? 'Unknown City',
                        //               style: GoogleFonts.dmSans(
                        //                 fontSize: 14.sp,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: const Color.fromARGB(255, 137, 26, 255),
                        //               ),
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(
                        //     left: 20.w,
                        //     right: 20.w,
                        //     top: 15.h,
                        //   ),
                        //   child: Text(
                        //     particular.data!.user?.address ??
                        //         'No description available.',
                        //     style: GoogleFonts.dmSans(
                        //       fontSize: 14.sp,
                        //       fontWeight: FontWeight.w500,
                        //       color: const Color.fromARGB(255, 97, 91, 104),
                        //       letterSpacing: -0.60,
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: 20.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: InkWell(
                            onTap: () {
                              if (box.get("id").toString() ==
                                  particular.data!.user!.id.toString()) {
                                Fluttertoast.showToast(
                                  msg: "Sorry,Your can't send message",
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder:
                                        (context) => ChatingPage(
                                          conversationId: '',
                                          userid:
                                              particular.data!.user!.id
                                                  .toString(),
                                          name:
                                              particular.data!.user!.fullName
                                                  .toString(),
                                        ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 49.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.45.r),
                                border: Border.all(
                                  color: const Color.fromARGB(
                                    255,
                                    137,
                                    26,
                                    255,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Message me',
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
                        ),

                        InkWell(
                          onTap: () {
                            _showReportDialog(
                              box.get("id"),
                              particular.data!.product!.id ?? 0,
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 49.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35.45.r),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Center(
                              child: Text(
                                "Report",
                                style: GoogleFonts.dmSans(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  ElevatedButton(
                    onPressed:
                        () => ref.refresh(
                          particularController((id: widget.id, userId: userId)),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// class ProductDesc extends StatelessWidget {
//   final String name;
//   final String title;
//   const ProductDesc({super.key, required this.name, required this.title});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               name,
//               style: GoogleFonts.dmSans(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color: const Color.fromARGB(255, 97, 91, 104),
//               ),
//             ),
//             Spacer(),
//             Expanded(child:
//             Text(
//               title,
//               style: GoogleFonts.dmSans(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500,
//                 color: const Color.fromARGB(255, 97, 91, 104),
//               ),
//             ),),
//           ],
//         ),
//         SizedBox(height: 10.h),
//         const Divider(),
//       ],
//     );
//   }
// /*
//   String _buildImageUrl(String? imagePath, String baseImageUrl, String fallbackImageUrl) {
//     final sanitizedBaseUrl = baseImageUrl.endsWith('/') ? baseImageUrl : '$baseImageUrl/';
//     final imageUrl = imagePath != null && imagePath.isNotEmpty
//         ? '$sanitizedBaseUrl${imagePath.startsWith('/') ? imagePath.substring(1) : imagePath}'
//         : fallbackImageUrl;
//     print('Loading image: $imageUrl'); // Debug log
//     return imageUrl;
//   }*/
// }

class ProductDesc extends StatelessWidget {
  final String name;
  final String title;

  const ProductDesc({super.key, required this.name, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 97, 91, 104),
                ),
                overflow: TextOverflow.ellipsis, // Handle long text
              ),
            ),
            const SizedBox(width: 8), // Add spacing between texts
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 97, 91, 104),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Handle long text
                textAlign: TextAlign.end, // Align title to the right
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        const Divider(),
      ],
    );
  }

}
