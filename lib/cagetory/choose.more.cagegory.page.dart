import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/bike.page.dart';
import 'package:shopping_app_olx/cagetory/books.page.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/cagetory/commerical.page.dart';
import 'package:shopping_app_olx/cagetory/elctronics.page.dart';
import 'package:shopping_app_olx/cagetory/fashion.page.dart';
import 'package:shopping_app_olx/cagetory/furniture.page.dart';
import 'package:shopping_app_olx/cagetory/job.page.dart';
import 'package:shopping_app_olx/cagetory/jobsekeer.page.dart';
import 'package:shopping_app_olx/cagetory/mobile.page.dart';
import 'package:shopping_app_olx/cagetory/property.page.dart';

import 'ServicesPage.dart';

class ChooseMoreCagegoryPage extends StatefulWidget {
  const ChooseMoreCagegoryPage({super.key});
  @override
  State<ChooseMoreCagegoryPage> createState() => _ChooseMoreCagegoryPageState();
}
class _ChooseMoreCagegoryPageState extends State<ChooseMoreCagegoryPage> {
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
          Positioned(
            child:
            SingleChildScrollView(child:
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
                  child: Column(
                    children: [
                      Text(
                        "Choose a category",
                        style: GoogleFonts.dmSans(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 45.w, right: 45.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                         /* Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const CarFormPage(productToEdit: null),
                            ),
                          );*/
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //       builder: (context) => CarFormPage(),
                          //       settings: RouteSettings(arguments: true)
                          //   ),
                          // );

                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CarFormPage(),
                              settings: RouteSettings(arguments: true),
                            ),
                          );

                        },
                        child: CategoryBody(
                          image: "assets/carses.png",
                          txt: "Cars",
                        ),
                      ),


                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => PropertyPage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/property.png",
                          txt: "Properties",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MobilePage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/phone.png",
                          txt: "Mobiles",
                        ),
                      ),
                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => JobPage()),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/jobs.png",
                          txt: "Jobs",
                        ),
                      ),

                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BikePage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/motorbike.png",
                          txt: "Bikes",
                        ),
                      ),

                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ElctronicsPage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/applience.png",
                          txt: "Electronics & Appliances",
                        ),
                      ),

                      SizedBox(height: 20.h),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CommericalPage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/spears.png",
                          txt: "Commercial Vehicles & Spares",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => FurniturePage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/furniture1.png",
                          txt: "Furniture",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => FashionPage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/fashion.png",
                          txt: "Fashion",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BooksPage(),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/support.png",
                          txt: "Books, Sports & Hobbies",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => JobSeekerFormPage(),
                                 settings: RouteSettings(arguments: true),
                            ),
                          );
                        },
                        child: CategoryBody(
                          image: "assets/job1.png",
                          txt: "Job Seeker",
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ServicesPage(),
                            ),
                          );
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => ServicesPage(),
                          //     settings: RouteSettings(arguments: true),
                          //   ),
                          // );
                        },
                        child: CategoryBody(
                          image: "assets/support.png",
                          txt: "Services",
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          )

        ],
      ),
    );



  }

}


class CategoryBody extends StatelessWidget {
  final String image;
  final String txt;
  const CategoryBody({super.key, required this.image, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(image, width: 20.w, height: 20.h, fit: BoxFit.cover),
            SizedBox(width: 8.w),
            Text(
              txt,
              style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF615B68),
                letterSpacing: -1,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF615B68),
              size: 18.sp,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Divider(
          //color: Color(0xFF615B68),
          color: Colors.black12,
          thickness: 1.w,
        ),
      ],
    );
  }
}
