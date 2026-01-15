import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/like/likedProducts.provider.dart';
import 'package:shopping_app_olx/like/service/showlikeController.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:shopping_app_olx/particularDeals/particularDeals.page.dart';

class ShowlikePage extends ConsumerStatefulWidget {
  const ShowlikePage({super.key});

  @override
  ConsumerState<ShowlikePage> createState() => _ShowlikePageState();
}

class _ShowlikePageState extends ConsumerState<ShowlikePage> {
  bool _showRawData = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.invalidate(likedProductsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final likeCount = ref.watch(likedProductsProvider);

    return Scaffold(
      body: Stack(
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
          Image.asset("assets/bgimage.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 46.w,
                          height: 46.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Liked Products',
                        style: GoogleFonts.inter(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer()
                      // GestureDetector(
                      //   onTap:
                      //       () => setState(() => _showRawData = !_showRawData),
                      //   child: Container(
                      //     width: 46.w,
                      //     height: 46.h,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.white,
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.black12,
                      //           blurRadius: 4,
                      //           offset: Offset(0, 2),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Icon(
                      //       _showRawData ? Icons.visibility_off : Icons.code,
                      //       color: Colors.black87,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: likeCount.when(
                    data: (data) {
                      // if (_showRawData) {
                      //   return SingleChildScrollView(
                      //     padding: EdgeInsets.all(20.w),
                      //     child: Container(
                      //       padding: EdgeInsets.all(16.w),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(12.r),
                      //         boxShadow: const [
                      //           BoxShadow(
                      //             color: Colors.black12,
                      //             blurRadius: 8,
                      //             offset: Offset(0, 4),
                      //           ),
                      //         ],
                      //       ),
                      //       child: Text(
                      //         JsonEncoder.withIndent('  ').convert({
                      //           'status': data.status,
                      //           'liked_products':
                      //               data.likedProducts
                      //                   .map((e) => e.toJson())
                      //                   .toList(),
                      //         }),
                      //         style: GoogleFonts.sourceCodePro(
                      //           fontSize: 14.sp,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //     ),
                      //   );
                      // }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        itemCount: data.likedProducts.length,
                        itemBuilder: (context, index) {
                          final product = data.likedProducts[index];
                          final jsondata = product.jsonData.entries.toList();

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(1),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.01),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12.r),
                                  onTap: () {
                                    // Add navigation to product details if needed
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder:
                                            (context) => ParticularDealsPage(
                                              id: product.id.toString(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child: Image.network(
                                            product.image,
                                            width: 100.w,
                                            height: 100.h,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => Container(
                                                  width: 100.w,
                                                  height: 100.h,
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                jsondata[0].value,
                                                style: GoogleFonts.inter(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                product.category.toUpperCase(),
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                ),
                                              ),

                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.thumb_up,
                                                    size: 16.sp,
                                                    color: Colors.green,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    product.likes.toString(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14.sp,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  SizedBox(width: 16.w),
                                                  Icon(
                                                    Icons.thumb_down,
                                                    size: 16.sp,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    product.dislikes.toString(),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14.sp,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "₹${product.price.toUpperCase()}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.blue[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error:
                        (error, stackTrace) => Center(
                          child: Text(
                            error.toString(),
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
