import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/electronics.form.oage.dart';
import 'package:shopping_app_olx/cagetory/property.page.dart';

class ElctronicsPage extends StatefulWidget {

  const ElctronicsPage({super.key});
  @override
  State<ElctronicsPage> createState() => _ElctronicsPageState();}

class _ElctronicsPageState extends State<ElctronicsPage> {
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
                  "Electronics & Appliances",
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
                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("TVs, Video-Audio"),
                            settings: RouteSettings(arguments: true),
                          ),
                        );
                      },
                      child: PropertyBody(txt: "TVs, Video-Audio"),
                    ),

                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("Kitchen & Other Appliances"),
                            settings: RouteSettings(arguments: true),
                          ),
                        );
                      },
                      child: PropertyBody(txt: "Kitchen & Other Appliances"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                     /*   Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("Computers & Laptops"),
                          ),
                        );*/
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ElectronicsFormPage("Computers & Laptops"),
                              settings: RouteSettings(arguments: true),
                            ));
                      },
                      child: PropertyBody(txt: "Computers & Laptops"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("Cameras & Lenses"),
                            settings: RouteSettings(arguments: true),
                          ),
                        );
                      },
                      child: PropertyBody(txt: "Cameras & Lenses"),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("Games & Entertainment"),
                            settings: RouteSettings(arguments: true),
                          ),
                        );
                      },
                      child: PropertyBody(txt: "Games & Entertainment"),
                    ),
                    SizedBox(height: 20.h),

                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("Hard Disks, Printers & Monitors"),
                            settings: RouteSettings(arguments: true),
                          ),
                        );
                      },
                      child: PropertyBody(
                        txt: "Hard Disks, Printers & Monitors",
                      ),
                    ),
                    SizedBox(height: 20.h),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => ElectronicsFormPage("ACS"),
                            settings: RouteSettings(arguments: true),
                          ),
                        );
                      },
                      child: PropertyBody(txt: "ACS"),
                    ),

                    SizedBox(height: 20.h),
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
