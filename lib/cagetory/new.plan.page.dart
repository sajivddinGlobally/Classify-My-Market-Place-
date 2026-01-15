import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NewPlanPage extends StatefulWidget {
  const NewPlanPage({super.key});

  @override
  State<NewPlanPage> createState() => _NewPlanPageState();
}

class _NewPlanPageState extends State<NewPlanPage> {
  
  @override
  Widget build(BuildContext context) {
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
                  textAlign: TextAlign.center,
                  "Plan",
                  style: GoogleFonts.dmSans(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Container(
                  width: 292.w,
                  height: 470.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Free/-",
                                style: GoogleFonts.poppins(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF231D4F),
                                ),
                              ),
                              TextSpan(
                                text: "15/Day",
                                style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF848199),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Professional",
                          style: GoogleFonts.poppins(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF231D4F),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Automation tools to take your work to the next level.",
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF848199),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(38, 82, 64, 194),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.done,
                                  color: Color(0xFFBB6BD9),
                                  size: 15.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Multi-step Zap",
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF848199),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(38, 82, 64, 194),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.done,
                                  color: Color(0xFFBB6BD9),
                                  size: 15.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Unlimited Premium ",
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF848199),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(38, 82, 64, 194),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.done,
                                  color: Color(0xFFBB6BD9),
                                  size: 15.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "50 Users team",
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF848199),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(38, 82, 64, 194),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.done,
                                  color: Color(0xFFBB6BD9),
                                  size: 15.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Shared Workspace",
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF848199),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50.h),
                        Container(
                          width: 232.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            color: Color(0xFF87849D),
                          ),
                          child: Center(
                            child: Text(
                              "Free",
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
