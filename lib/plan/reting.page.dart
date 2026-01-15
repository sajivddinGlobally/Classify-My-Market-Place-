import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RetingPage extends StatefulWidget {
  const RetingPage({super.key});

  @override
  State<RetingPage> createState() => _RetingPageState();
}

class _RetingPageState extends State<RetingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 128, 128, 128),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 438.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Image.asset("assets/ratingimage.png", height: 180.h),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      print("Rated: $rating");
                    },
                  ),

                  Text(
                    "Rate your experience",
                    style: GoogleFonts.dmSans(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 36, 33, 38),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Share your experience for other users to know what was experience with the seller",
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Color.fromARGB(255, 97, 91, 104),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
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
                      child: Text(
                        "Back to Order Listing",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
