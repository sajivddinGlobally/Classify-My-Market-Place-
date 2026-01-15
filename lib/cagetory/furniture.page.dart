import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/furniture.form.page.dart';
import 'package:shopping_app_olx/cagetory/other.form.page.dart';
import 'package:shopping_app_olx/cagetory/property.page.dart';

class FurniturePage extends StatefulWidget {
  const FurniturePage({super.key});

  @override
  State<FurniturePage> createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
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
                  "Furniture",
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
                    GestureDetector(
                      onTap: () {



                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FurnitureFormPage(),
                              settings: RouteSettings(arguments: true)
                          ),

                        );
                      },

                      child: PropertyBody(txt: "Sofa & Dining"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FurnitureFormPage(),
                              settings: RouteSettings(arguments: true)
                          ),

                        );
                      },
                      child: PropertyBody(txt: "Beds & Wardrobes"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FurnitureFormPage(),
                              settings: RouteSettings(arguments: true)
                          ),

                        );
                      },
                      child: PropertyBody(txt: "Home Decor & Garden"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FurnitureFormPage(),
                              settings: RouteSettings(arguments: true)
                          ),

                        );
                      },
                      child: PropertyBody(txt: "Kids Furniture"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                     /*   Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => OtherFormPage(),
                          ),
                        );*/
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => FurnitureFormPage(),
                              settings: RouteSettings(arguments: true)
                          ),

                        );
                      },
                      child: PropertyBody(txt: "Other Household Items"),
                    ),
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
