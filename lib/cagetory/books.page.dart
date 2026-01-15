import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/books.form.page.dart';
import 'package:shopping_app_olx/cagetory/property.page.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
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
                      "Books, Sports & Hobbies",
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
                           /* Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => BooksFormPage(),
                              ),
                            );*/
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>  BooksFormPage(),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Books"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>  BooksFormPage(),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => BooksFormPage(),
                            //   ),
                            // );
                          },
                          child: PropertyBody(txt: "Gym & Fitness"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>  BooksFormPage(),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => BooksFormPage(),
                            //   ),
                            // );
                          },
                          child: PropertyBody(txt: "Musical Instruments"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>  BooksFormPage(),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => BooksFormPage(),
                            //   ),
                            // );
                          },
                          child: PropertyBody(txt: "Sports Equipment"),
                        ),
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   CupertinoPageRoute(
                            //     builder: (context) => BooksFormPage(),
                            //   ),
                            // );
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>  BooksFormPage(),
                                  settings: RouteSettings(arguments: true)
                              ),

                            );
                          },
                          child: PropertyBody(txt: "Other Hobbies"),
                        ),
                        SizedBox(height: 10.h),
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
