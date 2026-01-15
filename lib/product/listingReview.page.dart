import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/product/model.addproduct/reviewBodyModel.dart';
import 'package:shopping_app_olx/product/service.addproduct/reviewController.dart';

class ListingReviewPage extends ConsumerStatefulWidget {
  final String proId;
  const ListingReviewPage({super.key, required this.proId});

  @override
  ConsumerState<ListingReviewPage> createState() => _ListingReviewPageState();
}

class _ListingReviewPageState extends ConsumerState<ListingReviewPage> {
  bool isReview = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
              ),
            ),
          ),
          Image.asset("assets/bgimage.png"),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 360.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/reviewimage.png",
                        height: 145.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Your Listing is Under Review",
                        style: GoogleFonts.dmSans(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 36, 33, 38),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.only(left: 24.w, right: 24.w),
                        child: Text(
                          textAlign: TextAlign.center,
                          "We are reviewing your order and we’ll let you know once your order is listed on our app",
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 97, 91, 104),
                            letterSpacing: -0.50,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          top: 10.h,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            // try {
                            //   setState(() {
                            //     isReview = true;
                            //   });
                            //   final review = await ref.watch(
                            //     reviewController(
                            //       ReviewBodyModel(
                            //         productId: "2",
                            //         buyerId: "4",
                            //         sellerId: "3",
                            //         rating: 5,
                            //         comment: "Great experience",
                            //       ),
                            //     ),
                            //   );
                            //   Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //       builder:
                            //           (context) => HomePage(
                            //             latitude: null,
                            //             longitude: null,
                            //             address: '',
                            //           ),
                            //     ),
                            //   );
                            //   Fluttertoast.showToast(msg: "Review Add $review");
                            // } catch (e) {
                            //   setState(() {
                            //     isReview = false;
                            //   });
                            //   Fluttertoast.showToast(msg: "Review Failed");
                            //   log(e.toString());
                            // }

                            try {
                              setState(() {
                                isReview = true;
                              });
                              final review = await ref.read(
                                reviewController(
                                  ReviewBodyModel(
                                    productId: widget.proId,
                                    buyerId: "4",
                                    sellerId: "3",
                                    rating: 5,
                                    comment: "Great experience",
                                  ),
                                ).future,
                              );
                              Fluttertoast.showToast(msg: "Review Added:");
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Review Failed");
                              log(e.toString());
                            } finally {
                              setState(() {
                                isReview = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              MediaQuery.of(context).size.width,
                              49.h,
                            ),
                            backgroundColor: Color(0xFF8D3AFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child:
                              isReview == false
                                  ? Text(
                                    "Back to home",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                  : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
