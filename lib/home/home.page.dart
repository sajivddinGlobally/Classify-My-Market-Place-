import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/cagetory/choose.category.page.dart';
import 'package:shopping_app_olx/chat/chat.page.dart';
import 'package:shopping_app_olx/cloth/clothing.page.dart';
import 'package:shopping_app_olx/home/service/homepageController.dart';
import 'package:shopping_app_olx/home/viewAllPage.dart';
import 'package:shopping_app_olx/like/model/likeBodyModel.dart';
import 'package:shopping_app_olx/like/service/likeController.dart';
import 'package:shopping_app_olx/like/showlike.page.dart';
import 'package:shopping_app_olx/listing/listing.page.dart';
import 'package:shopping_app_olx/login/login.page.dart';
import 'package:shopping_app_olx/map/map.page.dart';
import 'package:shopping_app_olx/map/service/locationController.dart';
import 'package:shopping_app_olx/particularDeals/particularDeals.page.dart';
import 'package:shopping_app_olx/profile/profile.page.dart';

class HomePage extends ConsumerStatefulWidget {
  final int? page;
  const HomePage({super.key, this.page});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final List<String> imageList = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    'assets/image3.jpg',
  ];
  List<Map<String, String>> dealsList = [
    {
      "imageUrl": "assets/shoes1.png",
      "location": "Udaipur, rajasthan",
      "title": "Nike Air Jorden 55 Medium",
      "price": "\$450.00",
    },
    {
      "imageUrl": "assets/shoes2.png",
      "location": "Mumbai, Maharashtra",
      "title": "Adidas Ultraboost 21",
      "price": "\$180.00",
    },
    {
      "imageUrl": "assets/shoes3.png",
      "location": "Delhi, India",
      "title": "Puma RS-X3",
      "price": "\$130.00",
    },
    {
      "imageUrl": "assets/shoes4.png",
      "location": "Bangalore, Karnataka",
      "title": "Reebok Classic Leather",
      "price": "\$75.00",
    },
    {
      "imageUrl": "assets/shoes5.png",
      "location": "Chennai, Tamil Nadu",
      "title": "New Balance 574",
      "price": "\$85.00",
    },
  ];
  final List<Map<String, dynamic>> categoryList = [
    {
      "icon": Icon(Icons.car_rental, color: Colors.blue.shade400),
      "title": "Cars",
      "subTitle": "Car",
    },
    {
      "icon": Icon(Icons.house_outlined, color: Colors.blue.shade400),
      "title": "Properties",
      "subTitle": "Property",
    },
    {
      "icon": Icon(Icons.mobile_friendly, color: Colors.blue.shade400),
      "title": "Mobiles",
      "subTitle": "Mobile",
    },
    {
      "icon": Icon(Icons.badge_outlined, color: Colors.blue.shade400),
      "title": "Jobs",
      "subTitle": "Job",
    },
    {
      "icon": Icon(Icons.bike_scooter_outlined, color: Colors.blue.shade400),
      "title": "Bikes",
      "subTitle": "Bike",
    },
    {
      "icon": Icon(Icons.tv_outlined, color: Colors.blue.shade400),
      "title": "Electronics",
      "subTitle": "Electronic",
    },
    {
      "icon": Icon(Icons.transform_outlined, color: Colors.blue.shade400),
      "title": "Commercials",
      "subTitle": "Commercial",
    },
  ];
  int tabBottom = 0;
  DateTime? lastBackPressTime;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showSafetyOverlay = true; // Pehli baar true, baad mein false

  // @override
  // void initState() {
  //   super.initState();
  //   var box = Hive.box("data");
  //   _showSafetyOverlay = box.get("shownSafetyWarning", defaultValue: true);
  //   if (_showSafetyOverlay) {
  //     box.put("shownSafetyWarning", false); // Next time na dikhe
  //   }
  //   tabBottom = widget.page ?? 0;
  //   _searchController.addListener(() {
  //     setState(() {
  //       _searchQuery = _searchController.text;
  //     });
  //   });
  //   _loadBannerAd();
  // }

  @override
  void initState() {
    super.initState();

    var box = Hive.box("data");
    String? userId = box.get(
      "id",
    ); // Jo bhi aapka user ID key hai (login ke time save hota hai)

    if (userId != null) {
      // Har user ke liye alag key: "safety_seen_user_12345"
      String safetyKey = "safety_seen_user_$userId";
      _showSafetyOverlay = box.get(safetyKey, defaultValue: true);
    } else {
      // Agar user logged out hai (koi ID nahi), to warning dikhao
      _showSafetyOverlay = true;
    }

    tabBottom = widget.page ?? 0;
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    _loadBannerAd();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  final String _adUnitId =
      'ca-app-pub-2570891403857959/6661669048'; // live add mob Id.33

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner Ad loaded');
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");
    var token = box.get("token");
    final homepageData = ref.watch(homepageController);
    final locationAsyncValue = ref.watch(locationProvider);

    if (homepageData.error != null) {
      print("Error in homepageData: ${homepageData.error}");
      return Scaffold(body: Center(child: Text("${homepageData.error}")));
    }

    return WillPopScope(
      /* onWillPop: () async {
        if (tabBottom != 0) {
          setState(() {
            tabBottom = 0;
          });
          return false;
        }
        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          Fluttertoast.showToast(
            msg: "Press back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
          );
          return false;
        }
        return true;
      },*/
      onWillPop: () async {
        // Back button bhi tab tak block agar overlay dikhe
        if (_showSafetyOverlay) return false;

        if (tabBottom != 0) {
          setState(() => tabBottom = 0);
          return false;
        }
        // ... baaki back press logic
        final now = DateTime.now();
        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
          lastBackPressTime = now;
          Fluttertoast.showToast(msg: "Press back again to exit");
          return false;
        }
        return true;
      },

      child: Scaffold(
        body: Stack(
          children: [
            tabBottom == 0
                ? RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(homepageController);
                    ref.invalidate(allCategoryController);
                    await ref.read(homepageController.future);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFECD7FD),
                                    Color(0xFFF5F2F7),
                                  ],
                                ),
                              ),
                            ),

                            Image.asset("assets/bgimage.png"),

                            Positioned(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 40.h),
                                  Row(
                                    children: [
                                      SizedBox(width: 20.w),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => MapPage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                          child: Icon(
                                            Icons.location_on,
                                            color: Color(0xFF891AFF),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => MapPage(),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Your Location",
                                              style: GoogleFonts.dmSans(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                  255,
                                                  97,
                                                  91,
                                                  104,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 220.w,
                                              child: locationAsyncValue.when(
                                                data:
                                                    (location) => Text(
                                                      location,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.dmSans(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                          255,
                                                          137,
                                                          26,
                                                          255,
                                                        ),
                                                      ),
                                                    ),
                                                loading:
                                                    () => Center(
                                                      child: SizedBox(
                                                        width: 50.w,
                                                        height: 50.h,
                                                        child:
                                                            const CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                error:
                                                    (err, stack) => Text(
                                                      "Location unavailable",
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder:
                                                  (context) => ShowlikePage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 50.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Icon(Icons.favorite_border),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        width: 50.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(Icons.notifications_none),
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),

                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                        height: 50.h,
                                        child: TextField(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ViewAllPage(false),
                                              ),
                                            );
                                          },
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 8.h,
                                              right: 20.r,
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            prefixIcon: Icon(Icons.search),
                                            suffixIcon:
                                                _searchQuery.isNotEmpty
                                                    ? IconButton(
                                                      icon: Icon(Icons.clear),
                                                      onPressed: () {
                                                        _searchController
                                                            .clear();
                                                        setState(() {
                                                          _searchQuery = '';
                                                        });
                                                      },
                                                    )
                                                    : null,
                                            hintText: "Search Anything...",
                                            hintStyle: GoogleFonts.dmSans(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color.fromARGB(
                                                255,
                                                97,
                                                91,
                                                104,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40.r),
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40.r),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 16.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 130.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      child: ListView.builder(
                                        itemCount: categoryList.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: 15.w,
                                              right: 15.w,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ClothingPage(
                                                          categoryList[index]['title'],
                                                          categoryList[index]['subTitle'],
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 54.w,
                                                    height: 54.h,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromARGB(
                                                        255,
                                                        246,
                                                        245,
                                                        250,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: ClipOval(
                                                        child:
                                                            categoryList[index]['icon'],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  SizedBox(
                                                    width: 85.w,
                                                    child: Center(
                                                      child: Text(
                                                        maxLines: 2,
                                                        categoryList[index]['title'] ==
                                                                "Commercials"
                                                            ? "Commercials\nVehicles"
                                                            : categoryList[index]['title'],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style:
                                                            GoogleFonts.dmSans(
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Color.fromARGB(
                                                                    255,
                                                                    97,
                                                                    91,
                                                                    104,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  SizedBox(
                                    height: 180.h,
                                    child: CarouselSlider(
                                      scrollPhysics:
                                          NeverScrollableScrollPhysics(),
                                      slideTransform: DefaultTransform(),
                                      autoSliderTransitionTime: Duration(
                                        seconds: 1,
                                      ),
                                      autoSliderDelay: Duration(seconds: 2),
                                      enableAutoSlider: true,
                                      unlimitedMode: true,
                                      children: [
                                        Image.asset('assets/frame.png'),
                                        Image.asset('assets/frame1.png'),
                                        Image.asset('assets/frame2.png'),
                                        Image.asset("assets/frame3.png"),
                                        Image.asset("assets/frame4.png"),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20.h),

                                  if (_isAdLoaded && _bannerAd != null)
                                    Center(
                                      // Yeh add kiya center karne ke liye
                                      child: SizedBox(
                                        width: _bannerAd!.size.width.toDouble(),
                                        height:
                                            _bannerAd!.size.height.toDouble(),
                                        child: AdWidget(ad: _bannerAd!),
                                      ),
                                    ),

                                  SizedBox(height: 26.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Top Deal",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 26.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              36,
                                              33,
                                              38,
                                            ),
                                          ),
                                        ),

                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        ViewAllPage(true),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 65.w,
                                            height: 26.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    35.45.r,
                                                  ),
                                              color: Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "View all",
                                                style: GoogleFonts.dmSans(
                                                  fontSize: 11.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                    255,
                                                    97,
                                                    91,
                                                    104,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 300.h,
                                    child: homepageData.when(
                                      data: (listing) {
                                        return ListView.builder(
                                          key: ValueKey(
                                            listing,
                                          ), // Ensure ListView rebuilds on data change
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              listing.latestListings?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            final product =
                                                listing.latestListings![index];
                                            final productId =
                                                product.id.toString();
                                            Map<String, dynamic> jsonData = {};
                                            try {
                                              if (product.jsonData != null) {
                                                jsonData =
                                                    jsonDecode(
                                                          product.jsonData!,
                                                        )
                                                        as Map<String, dynamic>;
                                              }
                                            } catch (e) {
                                              print(
                                                "Error parsing jsonData: $e",
                                              );
                                            }
                                            final title =
                                                jsonData['title']?.toString() ??
                                                'No Title Available';

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                top: 21.h,
                                                left: 20.w,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => ParticularDealsPage(
                                                                    id: productId,
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15.r,
                                                              ),
                                                          child: Image.network(
                                                            product.image ??
                                                                "https://www.irisoele.com/img/noimage.png",
                                                            width: 240.w,
                                                            height: 160.h,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),

                                                      // Row(
                                                      //
                                                      //   children: [
                                                      product.listingType !=
                                                              "2km_redis"
                                                          ? Positioned(
                                                            top: 10,
                                                            left: 10,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    4.sp,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .purple,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      5.sp,
                                                                    ),
                                                              ),

                                                              height: 30.h,
                                                              child: Text(
                                                                "Featured",
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 10,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                          : SizedBox(),

                                                      Positioned(
                                                        top: 10,
                                                        right: 10,

                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            bool isLikes =
                                                                product
                                                                    .userlike ??
                                                                false;
                                                            final body =
                                                                LikeBodyModel(
                                                                  productId:
                                                                      productId,
                                                                  type: "like",
                                                                  userId:
                                                                      "${box.get("id")}",
                                                                );
                                                            await ref
                                                                .read(
                                                                  likeNotiferProvider
                                                                      .notifier,
                                                                )
                                                                .likeProduct(
                                                                  body,
                                                                );
                                                            ref.invalidate(
                                                              homepageController,
                                                            );
                                                            ref.invalidate(
                                                              allCategoryController,
                                                            );
                                                            await Future.delayed(
                                                              Duration.zero,
                                                            );
                                                            Fluttertoast.showToast(
                                                              msg:
                                                                  isLikes
                                                                      ? "Removed from Liked"
                                                                      : "Added to Liked",
                                                              toastLength:
                                                                  Toast
                                                                      .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                            );
                                                          },
                                                          child: Container(
                                                            width: 30.w,
                                                            height: 30.h,
                                                            decoration:
                                                                const BoxDecoration(
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                            child: Center(
                                                              child: Icon(
                                                                product.userlike ??
                                                                        false
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border,
                                                                color:
                                                                    product.userlike ??
                                                                            false
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .grey,
                                                                size: 18.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(height: 15.h),
                                                  Container(
                                                    height: 25.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            30.r,
                                                          ),
                                                      color: Color.fromARGB(
                                                        25,
                                                        137,
                                                        26,
                                                        255,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 6.w,
                                                        right: 6.w,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            size: 15.sp,
                                                            color:
                                                                Color.fromARGB(
                                                                  255,
                                                                  137,
                                                                  26,
                                                                  255,
                                                                ),
                                                          ),

                                                          // if (product
                                                          //         .listingType ==
                                                          //     "Free")
                                                          //   Text(
                                                          //     listing.location ??
                                                          //         'Unknown Location',
                                                          //     style: GoogleFonts.dmSans(
                                                          //       fontSize: 12.sp,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w500,
                                                          //       color:
                                                          //           Color.fromARGB(
                                                          //             255,
                                                          //             137,
                                                          //             26,
                                                          //             255,
                                                          //           ),
                                                          //     ),
                                                          //   ),
                                                          if (product
                                                                  .listingType ==
                                                              "city")
                                                            Text(
                                                              "City" ??
                                                                  'Unknown Location',
                                                              style: GoogleFonts.dmSans(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Color.fromARGB(
                                                                      255,
                                                                      137,
                                                                      26,
                                                                      255,
                                                                    ),
                                                              ),
                                                            ),

                                                          if (product
                                                                  .listingType ==
                                                              "state")
                                                            Text(
                                                              "State" ??
                                                                  'Unknown Location',
                                                              style: GoogleFonts.dmSans(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Color.fromARGB(
                                                                      255,
                                                                      137,
                                                                      26,
                                                                      255,
                                                                    ),
                                                              ),
                                                            ),

                                                          if (product
                                                                  .listingType ==
                                                              "country")
                                                            Text(
                                                              "India" ??
                                                                  'Unknown Location',
                                                              style: GoogleFonts.dmSans(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Color.fromARGB(
                                                                      255,
                                                                      137,
                                                                      26,
                                                                      255,
                                                                    ),
                                                              ),
                                                            ),

                                                          if (product
                                                                  .listingType ==
                                                              "2km_redis")
                                                            Text(
                                                              "2 KM Radius" ??
                                                                  'Unknown Location',
                                                              style: GoogleFonts.dmSans(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Color.fromARGB(
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                        255,
                                                        97,
                                                        91,
                                                        104,
                                                      ),
                                                      letterSpacing: -0.80,
                                                    ),
                                                  ),
                                                  Text(
                                                    "₹ ${product.price ?? 'N/A'}",
                                                    style: GoogleFonts.dmSans(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                            );
                                          },
                                        );
                                      },
                                      error:
                                          (error, stackTrace) => Center(
                                            child: Text(error.toString()),
                                          ),
                                      loading:
                                          () => Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 20.w,
                                          right: 20.w,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "All Products",
                                              style: GoogleFonts.dmSans(
                                                fontSize: 26.sp,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                  255,
                                                  36,
                                                  33,
                                                  38,
                                                ),
                                                letterSpacing: -1,
                                              ),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder:
                                                        (context) =>
                                                            ViewAllPage(true),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 65.w,
                                                height: 26.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        35.45.r,
                                                      ),
                                                  color: Color.fromARGB(
                                                    255,
                                                    255,
                                                    255,
                                                    255,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "View all",
                                                    style: GoogleFonts.dmSans(
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromARGB(
                                                        255,
                                                        97,
                                                        91,
                                                        104,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  AllProductBody(
                                    searchQuery: _searchQuery,
                                    key: ValueKey(_searchQuery),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : tabBottom == 1
                ? ChatPage()
                : tabBottom == 2
                ? ListingPage()
                : ProfilePage(),

            /*   if (_showSafetyOverlay)
            GestureDetector(
              onTap: () {}, // Tap ko absorb karta hai, kuch nahi hone deta
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.7), // Dark overlay
                child: GestureDetector(
                  onTap: () {}, // Inner taps bhi block (safety card ke bahar)
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[900], // Dark background jaise OLX
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Optional: Drag handle
                            Container(
                              width: 40.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            Text(
                              'Be Safe on MMP',
                              style: GoogleFonts.dmSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Beware of Fake Ids, Fraudsters and QR code scams',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 30.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Future mein Learn More page add kar sakte ho
                                  },
                                  child: Text(
                                    'Learn more',
                                    style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showSafetyOverlay = false;
                                    });
                                    // Optional: Hive mein save kar do ki dikha diya
                                    Hive.box("data").put("shownSafetyWarning", false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(14),
                                  ),
                                  child: Icon(Icons.close, color: Colors.black, size: 20.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h), // Safe area ke liye
                    ],
                  ),
                ),
              ),
            ),*/
            if (_showSafetyOverlay)
              GestureDetector(
                onTap: () {}, // Poora screen tap absorb kare
                behavior:
                    HitTestBehavior.opaque, // Important: Sab taps block kare
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.75), // Dark overlay
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
                        padding: EdgeInsets.fromLTRB(24.w, 30.h, 24.w, 40.h),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            // Drag handle
                            Container(
                              width: 40.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            SizedBox(height: 24.h),

                            Text(
                              'Be Safe on MMP',
                              style: GoogleFonts.dmSans(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'Beware of Fake Ids, Fraudsters and QR code scams',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 32.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Learn more logic (optional)
                                  },
                                  child: Text(
                                    'Learn more',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                ElevatedButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   _showSafetyOverlay = false;
                                    // });
                                    // Hive.box("data").put("shownSafetyWarning", false);
                                    setState(() {
                                      _showSafetyOverlay = false;
                                    });

                                    var box = Hive.box("data");
                                    String? userId = box.get("id");

                                    if (userId != null) {
                                      String safetyKey =
                                          "safety_seen_user_$userId";
                                      box.put(
                                        safetyKey,
                                        false,
                                      ); // Is user ne dekh liya
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.all(14),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        floatingActionButton:
            _showSafetyOverlay
                ? null
                : // Overlay mein dikhe to FAB hide
                FloatingActionButton(
                  onPressed: () {
                    if (token == null) {
                      Fluttertoast.showToast(msg: "Please login first");
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ChooseCategoryPage(),
                        ),
                      );
                    }
                  },
                  shape: CircleBorder(),
                  backgroundColor: Color.fromARGB(255, 137, 26, 255),
                  child: Icon(Icons.add, color: Colors.white),
                ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar:
            _showSafetyOverlay
                ? Container(
                  height: 80.h,
                  color: Colors.transparent, // Ya dark overlay color
                )
                : BottomAppBar(
                  height: 80.h,
                  padding: EdgeInsets.zero,
                  shape: CircularNotchedRectangle(),
                  notchMargin: 6.0,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTab(
                            icon: Icons.home_outlined,
                            label: "Home",
                            index: 0,
                          ),
                        ),
                        Expanded(
                          child: _buildTab(
                            icon: Icons.messenger_outline,
                            label: "Chat",
                            index: 1,
                          ),
                        ),
                        Expanded(
                          child: _buildTab(
                            icon: Icons.layers_outlined,
                            label: "My Listings",
                            index: 2,
                          ),
                        ),
                        Expanded(
                          child: _buildTab(
                            icon: Icons.person_outline,
                            label: "Profile",
                            index: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = tabBottom == index;
    return MaterialButton(
      onPressed: () {
        setState(() {
          tabBottom = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? const Color.fromARGB(255, 137, 26, 255)
                    : const Color.fromARGB(255, 97, 91, 104),
            size: 26.sp,
          ),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color:
                  isSelected
                      ? const Color.fromARGB(255, 137, 26, 255)
                      : const Color.fromARGB(255, 97, 91, 104),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AllProductBody extends ConsumerStatefulWidget {
  final String searchQuery;
  const AllProductBody({super.key, required this.searchQuery});
  @override
  ConsumerState<AllProductBody> createState() => _AllProductBodyState();
}

class _AllProductBodyState extends ConsumerState<AllProductBody> {
  List<Map<String, String>> Allproductlist = [
    {
      "imageUrl": "assets/1.png",
      "location": "Udaipur, rajasthan",
      "title": "Nike Air Jorden 55 Medium",
      "price": "\$450.00",
    },
    {
      "imageUrl": "assets/2.png",
      "location": "Jaipur, Rajasthan",
      "title": "Adidas Ultraboost 21",
      "price": "\$180.00",
    },
    {
      "imageUrl": "assets/3.png",
      "location": "Mumbai, Maharashtra",
      "title": "Puma RS-X3",
      "price": "\$120.00",
    },
    {
      "imageUrl": "assets/4.png",
      "location": "Bengaluru, Karnataka",
      "title": "Reebok Nano X1",
      "price": "\$140.00",
    },
    {
      "imageUrl": "assets/5.png",
      "location": "Delhi",
      "title": "Under Armour Charged Escape 3",
      "price": "\$450.00",
    },
    {
      "imageUrl": "assets/6.png",
      "location": "Udaipur, rajasthan",
      "title": "Nike Air Jorden 55 Medium",
      "price": "\$110.00",
    },
    {
      "imageUrl": "assets/7.png",
      "location": "Chennai, Tamil Nadu",
      "title": "New Balance Fresh Foam 1080v11",
      "price": "\$160.00",
    },
    {
      "imageUrl": "assets/8.png",
      "location": "Ahmedabad, Gujarat",
      "title": "Asics Gel-Kayano 27",
      "price": "\$200.00",
    },
    {
      "imageUrl": "assets/9.png",
      "location": "Udaipur, rajasthan",
      "title": "Hoka One One Clifton 7",
      "price": "\$180.00",
    },
    {
      "imageUrl": "assets/10.png",
      "location": "Pune, Maharashtra",
      "title": "Nike Air Jorden 55 Medium",
      "price": "\$450.00",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");

    final homepageData = ref.watch(homepageController);

    return homepageData.when(
      data: (allproduct) {
        // final filteredProducts = allproduct.allProducts?.where((product) {
        //   Map<String, dynamic> jsonData = {};
        //   try {
        //     if (product.jsonData != null) {
        //       jsonData = jsonDecode(product.jsonData!) as Map<String, dynamic>;
        //     }
        //   } catch (e) {
        //     print("Error parsing jsonData: $e");
        //   }
        //   final title = jsonData['title']?.toString().toLowerCase() ?? "";
        //   final location = allproduct.location?.toLowerCase() ?? "";
        //   final price = product.price?.toString().toLowerCase() ?? "";
        //   final query = widget.searchQuery.toLowerCase();
        //   return title.contains(query) || location.contains(query) || price.contains(query);
        // }).toList() ?? [];

        return Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child:
              allproduct.allProducts!.isEmpty
                  ? Center(
                    child: Text(
                      "No products found",
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 97, 91, 104),
                      ),
                    ),
                  )
                  : GridView.builder(
                    key: ValueKey(
                      allproduct,
                    ), // Ensure GridView rebuilds on data change
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: allproduct.allProducts!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final data = allproduct.allProducts![index];
                      final productId = data.id.toString();
                      Map<String, dynamic> jsonData = {};
                      try {
                        if (data.jsonData != null) {
                          jsonData =
                              jsonDecode(data.jsonData!)
                                  as Map<String, dynamic>;
                        }
                      } catch (e) {
                        log("Error parsing jsonData: $e");
                      }
                      final title =
                          jsonData['title']?.toString() ?? 'No Title Available';
                      final listingType =
                          data.listingType ?? 'No listingType Available';
                      final city = data.city ?? 'No listingType Available';
                      final state = data.state ?? 'No listingType Available';
                      final conuntry =
                          data.country ?? 'No listingType Available';

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
                                            id: productId,
                                          ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.network(
                                    data.image ??
                                        "https://www.irisoele.com/img/noimage.png",
                                    width: 196.w,
                                    height: 150.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 15.w,
                              //   top: 15.h,
                              //   child:
                              Container(
                                margin: EdgeInsets.all(10.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    listingType != "2km_redis"
                                        ? Container(
                                          padding: EdgeInsets.all(4.sp),
                                          decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.circular(
                                              5.sp,
                                            ),
                                          ),

                                          height: 30.h,
                                          child: Text(
                                            "Featured",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        )
                                        : SizedBox(),

                                    GestureDetector(
                                      onTap: () async {
                                        bool isLikes = data.userlike ?? false;
                                        final body = LikeBodyModel(
                                          productId: productId,
                                          type: "like",
                                          userId: "${box.get("id")}",
                                        );
                                        await ref
                                            .read(likeNotiferProvider.notifier)
                                            .likeProduct(body);
                                        ref.invalidate(homepageController);
                                        ref.invalidate(allCategoryController);
                                        await Future.delayed(Duration.zero);
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
                                        width: 30.w,
                                        height: 30.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Icon(
                                            data.userlike ?? false
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                data.userlike ?? false
                                                    ? Colors.red
                                                    : Colors.grey,
                                            size: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15.h),

                          Container(
                            width: double.infinity,
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

                                  SizedBox(width: 5.w),
                                  if (listingType == "2km_redis")
                                    Text(
                                      "2 KM Radius",
                                      // allproduct.location ?? 'Unknown Location',
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

                                  if (listingType == "city")
                                    Text(
                                      city ?? 'Unknown Location',
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

                                  if (listingType == "state")
                                    Text(
                                      state ?? 'Unknown Location',
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

                                  if (listingType == "country")
                                    Text(
                                      "India",
                                      // conuntry ?? 'Unknown Location',
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
                              color: Color.fromARGB(255, 97, 91, 104),
                            ),
                          ),

                          Text(
                            "₹ ${data.price ?? 'N/A'}",
                            style: GoogleFonts.dmSans(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 137, 26, 255),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
        );
      },

      error: (error, stackTrace) => Center(child: Text(error.toString())),

      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
