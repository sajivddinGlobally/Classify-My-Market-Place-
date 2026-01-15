import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/cagetory/car.form.page.dart';
import 'package:shopping_app_olx/cagetory/electronics.form.oage.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/listing/service/getlistingController.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/particularDeals/particularDeals.page.dart';
import '../cagetory/BikeSparsFormPage.dart';
import '../cagetory/ServiceBookForm.dart';
import '../cagetory/accessory.form.page.dart';
import '../cagetory/bicycle.form.page.dart';
import '../cagetory/books.form.page.dart';
import '../cagetory/commerical.form.page.dart';
import '../cagetory/data.entry.form.page.dart';
import '../cagetory/fashion.form.page.dart';
import '../cagetory/furniture.form.page.dart';
import '../cagetory/guesthouse.form.page.dart';
import '../cagetory/jobsekeer.page.dart';
import '../cagetory/land.and.plot.form.page.dart';
import '../cagetory/mobile.form.page.dart';
import '../cagetory/motorcycle.form.page.dart';
import '../cagetory/rent.property.form.page.dart';
import '../cagetory/sale.property.form.page.dart';
import '../cagetory/scotor.form.page.dart';
import '../cagetory/shopsoffice.form.page.dart';
import '../cagetory/spare.parts.form.page.dart';
import '../cagetory/tablet.form.page.dart';

class ListingPage extends ConsumerStatefulWidget {
  const ListingPage({super.key});
  @override
  ConsumerState<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends ConsumerState<ListingPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(listingController));
  }

  Future<void> _onRefresh() async {
    ref.invalidate(listingController);
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {

    final listingProvider = ref.watch(listingController);
    final box = Hive.box("data");
    final planid = box.get("plan_id");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 242, 247),
      body:


      listingProvider.when(
        data: (listing) {
          if (listing.data!.sellList!.isEmpty) {
            return Center(
              child: Text(
                "No List Available",
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _onRefresh, // Call the refresh handler
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "My Listing",
                      style: GoogleFonts.dmSans(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 36, 33, 38),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30.h),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    itemCount: listing.data!.sellList!.length,
                    itemBuilder: (context, index) {
                      final data = listing.data!.sellList![index];
                      var jsondata =
                          listing.data!.sellList![index].jsonData!.entries
                              .toList();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder:
                                  (context) => ParticularDealsPage(
                                    id: data.id.toString(),
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 20.w,
                            right: 20.w,
                            top: 20.h,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 12.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Image.network(
                                      listing.data!.sellList![index].image ??
                                          "https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg",
                                      width: MediaQuery.of(context).size.width,
                                      height: 133.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  Text(
                                    jsondata[0].value.toString(),
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 97, 91, 104),
                                    ),
                                  ),

                                  SizedBox(height: 10.h),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5.sp),
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.sp,
                                          ),
                                        ),
                                        child:
                                            listing
                                                        .data!
                                                        .sellList![index]
                                                        .status ==
                                                    0
                                                ? Text(
                                                  "Pending",
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                )
                                                : listing
                                                        .data!
                                                        .sellList![index]
                                                        .status ==
                                                    1
                                                ? Text(
                                                  "Approved",
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                )
                                                : Text(
                                                  "Rejected",
                                                  style: GoogleFonts.dmSans(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                      ),

                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Properties Sale") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => SalePropertyFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Properties Rent") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => RentPropertyFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Cars") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => CarFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Properties Land") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => LandAndPlotFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Properties Shops") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ShopsOfficeFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Properties ShopsOffice") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ShopsOfficeFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Properties Guest") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => GuesthouseFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Mobiles") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => MobileFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Accessories") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => AccessoryFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Tablets") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => TabletFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Jobs") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => DataEntryFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Bikes motorcycle") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => MotorcycleFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing
                                                      .data!
                                                      .sellList![index]
                                                      .subcategory ==
                                                  "Scooters motorcycle") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ScooterFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Bikes SpareParts") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => BikeSparsFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "SpareParts") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => SparePartsFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Bikes Bicycles") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => BicycleFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "TVs, Video-Audio") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "TVs, Video-Audio",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Kitchen & Other Appliances") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "Kitchen & Other Appliances",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Computers & Laptops") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "Computers & Laptops",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Cameras & Lenses") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "Cameras & Lenses",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Games & Entertainment") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "Games & Entertainment",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Hard Disks, Printers & Monitors") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "Hard Disks, Printers & Monitors",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "ACS") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ElectronicsFormPage(
                                                          "ACS",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Commercial Vehicles") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => CommercialFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Furniture") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => FurnitureFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Fashion") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => FashionFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Books") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => BooksFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "JobsSeeker") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => JobSeekerFormPage(
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Education & Classes") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Education & Classes",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Tours/Travel") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Tours/Travel",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Electronics Repair Services") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Electronics Repair Services",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Health Beauty") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Health Beauty",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Home Renovation Repair") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Home Renovation Repair",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Cleaning Pest Control") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Cleaning Pest Control",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Legal Documentation Services") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Legal Documentation Services",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Packers Movers") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Packers Movers",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Banking and Finance") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Banking and Finance",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              } else if (listing.data!.sellList![index].subcategory ==
                                                  "Other Services") {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => ServicesBookFormPage(
                                                          serviceType:
                                                              "Other Services",
                                                          productToEdit:
                                                              listing
                                                                  .data!
                                                                  .sellList![index], // Pass the specific SellList item
                                                        ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5.sp),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      10.sp,
                                                    ),
                                              ),
                                              child: Icon(
                                                Icons.edit,
                                                color: Color.fromARGB(
                                                  255,
                                                  137,
                                                  26,
                                                  255,
                                                ),
                                                size: 35.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),

                                          GestureDetector(
                                            onTap: () async {
                                              final confirm = await showDialog<
                                                bool
                                              >(
                                                context: context,
                                                builder:
                                                    (context) => Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Card(
                                                        margin: EdgeInsets.zero,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        elevation: 8,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                20,
                                                              ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Text(
                                                                'Confirm Deletion',
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 12,
                                                              ),
                                                              const Text(
                                                                'Are you sure you want to delete this product?',
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () => Navigator.of(
                                                                          context,
                                                                        ).pop(
                                                                          false,
                                                                        ),
                                                                    child:
                                                                        const Text(
                                                                          'No',
                                                                        ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 8,
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () => Navigator.of(
                                                                          context,
                                                                        ).pop(
                                                                          true,
                                                                        ),
                                                                    child:
                                                                        const Text(
                                                                          'Yes',
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              );

                                              if (confirm == true) {
                                                final service = APIService(
                                                  await createDio(),
                                                );
                                                await service.deleteProduct(
                                                  listing
                                                      .data!
                                                      .sellList![index]
                                                      .id!,
                                                );
                                                ref.invalidate(
                                                  listingController,
                                                );
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Product Deleted Successfully",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                );
                                              }
                                            },

                                            child: Container(
                                              padding: EdgeInsets.all(5.sp),
                                              decoration: BoxDecoration(
                                                // color: Color.fromARGB(255, 137, 26, 255),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      10.sp,
                                                    ),
                                              ),
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                                size: 35.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start, // Align text to the top
                                    children: [
                                      Text(
                                        "Views",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),

                                      SizedBox(width: 8.w),
                                      Text(
                                        listing.data!.sellList![index].viewCount
                                                .toString() ??
                                            "No reason provided",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                        ),
                                        textAlign:
                                            TextAlign
                                                .end, // Align rejection reason to the right
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // Handle long text gracefully
                                        maxLines:
                                            2, // Limit to 2 lines for long text
                                      ),
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start, // Align text to the top
                                    children: [
                                      Text(
                                        "likes",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),

                                      Text(
                                        listing.data!.sellList![index].likes
                                                .toString() ??
                                            "No reason provided",
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            255,
                                            137,
                                            26,
                                            255,
                                          ),
                                        ),
                                        textAlign:
                                            TextAlign
                                                .end, // Align rejection reason to the right
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // Handle long text gracefully
                                        maxLines:
                                            2, // Limit to 2 lines for long text
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  if (listing.data!.sellList![index].status ==
                                      2)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start, // Align text to the top
                                      children: [
                                        Text(
                                          "Rejection Reason",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ), // Add spacing between the texts
                                        Expanded(
                                          child: Text(
                                            listing
                                                    .data!
                                                    .sellList![index]
                                                    .rejectionReason ??
                                                "No reason provided",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                255,
                                                137,
                                                26,
                                                255,
                                              ),
                                            ),
                                            textAlign:
                                                TextAlign
                                                    .end, // Align rejection reason to the right
                                            overflow:
                                                TextOverflow
                                                    .ellipsis, // Handle long text gracefully
                                            maxLines:
                                                2, // Limit to 2 lines for long text
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          );
        },
        error: (error, stackTrace) {
          if (error is UserNotLoggedInException) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed('/login');
            });
          }
          return Center(child: Text("$error"));
        },
        loading: () => Center(child: CircularProgressIndicator()),
      ),


    );
  }
}
