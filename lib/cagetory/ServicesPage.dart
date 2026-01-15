import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/books.form.page.dart';
import 'package:shopping_app_olx/cagetory/property.page.dart';

import 'ServiceBookForm.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Stack(
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
                  SizedBox(height: 20.h),
                  Center(
                    child: Text(
                      "Services",
                      style: GoogleFonts.dmSans(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                          /*  Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ServicesBookFormPage(serviceType:"Education & Classes"),
                              ),
                            );*/
                            // Navigator.push(






                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>  ServicesBookFormPage(serviceType:"Education & Classes"),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },

                          child: PropertyBody(txt: "Education & Classes"),
                        ),

                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => ServicesBookFormPage(serviceType:"Tours/Travel"),
                            //   ),
                            // );
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ServicesBookFormPage(serviceType:"Tours/Travel"),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },


                        child: PropertyBody(txt: "Tours & Travel"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => ServicesBookFormPage(serviceType: "Electronics Repair Services",),
                            //   ),
                            // );
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>ServicesBookFormPage(serviceType: "Electronics Repair Services",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Electronics Repair & Services"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => ServicesBookFormPage(serviceType: "Health Beauty",),
                            //   ),
                            // );
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>ServicesBookFormPage(serviceType: "Health Beauty",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Health & Beauty"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                         /*   Navigator.push(
                              context,
                              CupertinoPageRoute( 
                                builder: (context) => ServicesBookFormPage(serviceType: "Home Renovation Repair",),
                              ),
                            );*/
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ServicesBookFormPage(serviceType: "Home Renovation Repair",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Home Renovation & Repair"),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                          /*  Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ServicesBookFormPage(serviceType: "Cleaning Pest Control",),
                              ),
                            );*/
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>ServicesBookFormPage(serviceType: "Cleaning Pest Control",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Cleaning & Pest Control"),
                          ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                          /*  Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ServicesBookFormPage(serviceType: "Legal Documentation Services",),
                              ),
                            );*/
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ServicesBookFormPage(serviceType: "Legal Documentation Services",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Legal & Documentation Services"),
                        ),
                        SizedBox(height: 10.h),

                        GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ServicesBookFormPage(serviceType: "Packers Movers",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );

                          },
                          child: PropertyBody(txt: "Packers & Movers"),
                        ),



                        SizedBox(height: 10.h),

                        GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ServicesBookFormPage(serviceType: "Banking and Finance",),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );

                          },
                          child: PropertyBody(txt: "Banking and Finance"),
                        ),

                        SizedBox(height: 10.h),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => ServicesBookFormPage(serviceType: "Other Services",),
                                  settings: RouteSettings(arguments: true)
                              ),
                            );
                          },
                          child: PropertyBody(txt: "Other Services"),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
