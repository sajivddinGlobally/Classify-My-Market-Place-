import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/choose.category.page.dart';

import 'package:shopping_app_olx/home/service/homepageController.dart';


class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});
  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}


class _CategoryPageState extends ConsumerState<CategoryPage> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final categoryProvider = ref.watch(allCategoryController);
    return Scaffold(
      body: SingleChildScrollView(
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
            categoryProvider.when(
              data: (category) {
                return Positioned(
                  child: Column(
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
                      SizedBox(height: 40.h),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              "Choose your category",
                              style: GoogleFonts.dmSans(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 44.w, right: 44.w),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Select one of the categories to post your ad on, start with selecting category",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: category.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                tab = index;
                              });
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ChooseCategoryPage(),
                                ),
                              );
                            },
                            child: CategorBody(
                              bgColor:
                                  tab == index
                                      ? Color.fromARGB(255, 137, 26, 255)
                                      : Colors.white,
                              image: category.data[index].imageUrl,
                              //'assets/electronic.png',
                              txt: category.data[index].title,
                              // 'Electronic',
                              txtColor:
                                  tab == index
                                      ? Color.fromARGB(255, 255, 255, 255)
                                      : Colors.black,
                            ),
                          );
                        },
                      ),


                      SizedBox(height: 40.h),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => Center(child: Text(e.toString())),
              loading: () => Center(child: CircularProgressIndicator()),
            ),


          ],
        ),
      ),
    );
  }
}






class CategorBody extends StatelessWidget {
  final Color bgColor;
  final String image;
  final String txt;
  final Color txtColor;
  const CategorBody({
    super.key,
    required this.bgColor,
    required this.image,
    required this.txt,
    required this.txtColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: bgColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50.w,
              height: 50.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.network(image, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              txt,
              style: GoogleFonts.dmSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: txtColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
