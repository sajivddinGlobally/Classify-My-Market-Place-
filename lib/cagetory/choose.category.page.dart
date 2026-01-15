import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/cagetory/bike.page.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/cagetory/choose.more.cagegory.page.dart';
import 'package:shopping_app_olx/cagetory/commerical.page.dart';
import 'package:shopping_app_olx/cagetory/elctronics.page.dart';
import 'package:shopping_app_olx/cagetory/job.page.dart';
import 'package:shopping_app_olx/cagetory/mobile.page.dart';
import 'package:shopping_app_olx/cagetory/property.page.dart';

import '../listing/model/getlistingModel.dart';

class ChooseCategoryPage extends StatefulWidget {
  const ChooseCategoryPage({super.key});
  @override
  State<ChooseCategoryPage> createState() => _ChooseCategoryPageState();
}

class _ChooseCategoryPageState extends State<ChooseCategoryPage> {
  List<_CategoryItem> get categories => _getCategories();
  List<_CategoryItem> _getCategories() {
    return [
      _CategoryItem('Cars', Icons.directions_car_filled_outlined, () {
        /*   Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const CarFormPage(productToEdit: null),
          ),
        );*/
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CarFormPage(),
            settings: RouteSettings(arguments: true),
          ),
        );
      }),
      _CategoryItem('Properties', Icons.home_outlined, () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => PropertyPage()),
        );
      }),
      _CategoryItem('Mobiles', Icons.phone_android, () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => MobilePage()),
        );
      }),
      _CategoryItem('Jobs', Icons.work_outline, () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => JobPage()),
        );
      }),
      _CategoryItem('Bikes', Icons.motorcycle_sharp, () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => BikePage()),
        );
      }),
      _CategoryItem('Electronics & Appliances', Icons.tv, () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => ElctronicsPage()),
        );
      }),
      _CategoryItem(
        'Commercial Vehicles & Spares',
        Icons.local_shipping_outlined,
        () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => CommericalPage()),
          );
        },
      ),
      _CategoryItem('More Categories', Icons.apps, () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => ChooseMoreCagegoryPage()),
        );
      }),
    ];
  }

  int tab = 0;

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

                SizedBox(height: 30.h),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _CategoryCard(category: category);
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String name;
  final IconData icon;
  final Function callback;

  _CategoryItem(this.name, this.icon, this.callback);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => category.callback(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.w),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(category.icon, size: 48.sp, color: Colors.black54),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  category.name,
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF615B68),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
