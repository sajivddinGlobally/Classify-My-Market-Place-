import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/cloth/service/categoryController.dart';
import 'package:shopping_app_olx/particularDeals/particularDeals.page.dart';
import '../like/model/likeBodyModel.dart';
import '../like/service/likeController.dart';

class ClothingPage extends ConsumerStatefulWidget {
  final String query;
  final String subTitle;
  const ClothingPage(this.query, this.subTitle, {super.key});
  @override
  ConsumerState<ClothingPage> createState() => _ClothingPageState();
}

class _ClothingPageState extends ConsumerState<ClothingPage> {
  final searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");
    var userId = box.get("id");
    final dataProvider = ref.watch(
      categoryController((category: widget.query, userId: userId)),
    );
    final searchQuery = ref.watch(searchProvider).toLowerCase();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 242, 247),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Row(
              children: [
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 46.w,
                    height: 46.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Center(child: Icon(Icons.arrow_back)),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 15.h, right: 15.w),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(40.r),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(40.r),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search items...",
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),

            SizedBox(height: 16.h),

            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ),

            SizedBox(height: 20.h),

            dataProvider.when(
              data: (data) {
                final filteredData =
                    searchQuery.isEmpty
                        ? data.data
                        : data.data.where((item) {
                          final title =
                              item.jsonData.entries.isNotEmpty
                                  ? item.jsonData.entries.first.value
                                      .toLowerCase()
                                  : "";
                          final category = item.category.toLowerCase();
                          return title.contains(searchQuery) ||
                              category.contains(searchQuery);
                        }).toList();
                log("Filtered items: ${filteredData.length}");
                if (filteredData.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text("No items found")),
                  );
                }

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: filteredData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredData[index];
                        final title =
                            item.jsonData.entries.isNotEmpty
                                ? item.jsonData.entries.first.value
                                : "Unknown Item";

                        final listing_type = item.listing_type;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder:
                                            (context) => ParticularDealsPage(
                                              id: item.id.toString(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.network(
                                      item.image,
                                      width: 196.w,
                                      height: 150.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 196.w,
                                                height: 150.h,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),


                                listing_type != "2km_redis"?
                                Positioned(
                                  top: 10.h,
                                  left:10.w,
                                  child: Container(
                                    padding: EdgeInsets.all(4.sp),
                                    decoration: BoxDecoration(
                                        color: Colors.purple,
                                        borderRadius: BorderRadius.circular(5.sp)),

                                    height: 30.h,
                                    child: Text("Featured",style: TextStyle(color: Colors.white,fontSize: 10),),
                                  ),
                                ):SizedBox(),


                                Positioned(
                                  right: 10.w,
                                  top: 10.h,
                                  child:

                                  GestureDetector(
                                    onTap: () async {
                                      bool isLikes = item.userlike ?? false;
                                      // particular.user_like??false;
                                      final body = LikeBodyModel(
                                        productId: item.id.toString(),
                                        type: "like",
                                        userId: "${box.get("id")}",
                                      );
                                      // Perform the like action
                                      await ref
                                          .read(likeNotiferProvider.notifier)
                                          .likeProduct(body);
                                      // Invalidate the lists
                                      ref.invalidate(categoryController);
                                      // ref.invalidate(allCategoryController);
                                      // Show toast after invalidation
                                      await Future.delayed(
                                        Duration.zero,
                                      ); // Ensure UI updates before toast
                                      Fluttertoast.showToast(
                                        msg:
                                            isLikes
                                                ? "Removed from Liked"
                                                : "Added to Liked",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    },
                                    child: Container(
                                      width: 46.w,
                                      height: 46.h,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(25, 137, 26, 255),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            item.userlike!
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                item.userlike!
                                                    ? Colors.red
                                                    : Colors.grey,
                                            size: 18.sp,
                                          ),

                                          // Icon(Icons.favorite_border)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            Container(
                              width: 120.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: const Color.fromARGB(25, 137, 26, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 15.sp,
                                      color: const Color.fromARGB(
                                        255,
                                        137,
                                        26,
                                        255,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      widget.subTitle,
                                      // item.category,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                          255,
                                          137,
                                          26,
                                          255,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Container(
                              width: 120.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.r),
                                color: Color.fromARGB(25, 137, 26, 255),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 6.w, right: 6.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 15.sp,
                                      color: Color.fromARGB(255, 137, 26, 255),
                                    ),

                                    //  Text(
                                    //    // "Udaipur, rajasthan",
                                    //    // dealsList[index]["location"]
                                    //    //     .toString(),
                                    // "Nearby (2KM)",
                                    //    style:
                                    //    GoogleFonts.dmSans(
                                    //      fontSize: 12.sp,
                                    //      fontWeight:
                                    //      FontWeight
                                    //          .w500,
                                    //      color:
                                    //      Color.fromARGB(
                                    //        255,
                                    //        137,
                                    //        26,
                                    //        255,
                                    //      ),
                                    //    ),
                                    //  ),
                                    if (listing_type == "2km_redis")
                                      Text(
                                        "2 KM Radius",
                                        // "Free" ?? 'Unknown Location',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                        ),
                                      ),

                                    if (listing_type == "city")
                                      Text(
                                        "City" ?? 'Unknown Location',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                        ),
                                      ),

                                    if (listing_type == "state")
                                      Text(
                                        "State" ?? 'Unknown Location',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                        ),
                                      ),

                                    if (listing_type == "country")
                                      Text(
                                        "Country" ?? 'Unknown Location',
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              title,
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 97, 91, 104),
                                letterSpacing: -0.80,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item.price != null
                                  ? "₹${item.price}"
                                  : "Price not available",
                              style: GoogleFonts.dmSans(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 137, 26, 255),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                log("Error: $error\nStackTrace: $stackTrace");
                return const Expanded(
                  child: Center(
                    child: Text(
                      "Failed to load items. Please try again.",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              },
              loading:
                  () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterBody extends StatefulWidget {
  final String name;
  const FilterBody({super.key, required this.name});

  @override
  State<FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<FilterBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35.45.r),
        border: Border.all(color: const Color.fromARGB(255, 97, 91, 104)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w),
        child: Row(
          children: [
            Text(
              widget.name,
              style: GoogleFonts.dmSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 97, 91, 104),
              ),
            ),
            SizedBox(width: 20.w),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromARGB(255, 97, 91, 104),
            ),
          ],
        ),
      ),
    );
  }
}
