import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/login/login.page.dart';
import 'package:shopping_app_olx/register/register.page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 1.0,
                      child: Image.asset(
                        'assets/splashimage.png', // Add your image here
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.white],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset("assets/bgimage.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(left: 44.w, right: 44.r),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Buy & Sell based on your location",
                            style: GoogleFonts.dmSans(
                              letterSpacing: -1.60,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 36, 33, 38),
                            ),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            "Discover the convenience of buying and selling items right in your neighborhood! ",
                            style: GoogleFonts.dmSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 97, 91, 104),
                              letterSpacing: -0.70,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => RegisterPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 49.h,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 137, 26, 255),
                                borderRadius: BorderRadius.circular(35.45.r),
                              ),
                              child: Center(
                                child: Text(
                                  "Register",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 49.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.45.r),
                                border: Border.all(
                                  width: 1.w,
                                  color: Color.fromARGB(255, 137, 26, 255),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 137, 26, 255),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
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
