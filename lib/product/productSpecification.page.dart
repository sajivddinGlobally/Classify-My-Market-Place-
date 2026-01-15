import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/product/listingReview.page.dart';
import 'package:shopping_app_olx/product/model.addproduct/specificationBodyModel.dart';
import 'package:shopping_app_olx/product/service.addproduct/specificationService.dart';
import 'package:shopping_app_olx/register/register.page.dart';

class ProductspecificationPage extends ConsumerStatefulWidget {
  final String productId;
  const ProductspecificationPage({super.key, required this.productId});

  @override
  ConsumerState<ProductspecificationPage> createState() =>
      _ProductspecificationPageState();
}

class _ProductspecificationPageState
    extends ConsumerState<ProductspecificationPage> {
  final materialController = TextEditingController();
  final shoeNumberController = TextEditingController();
  final ageController = TextEditingController();
  final modelController = TextEditingController();
  final idealController = TextEditingController();
  final styleController = TextEditingController();

  bool isSpecification = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height + 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                ),
              ),
            ),
            Image.asset("assets/bgimage.png"),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 60.h),
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
            Positioned(
              top: 168.h,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Enter Specification",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 26.sp,
                        color: Color(0xFF242126),
                        letterSpacing: -0.65,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 44.w, right: 44.w),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Upload picture of your products, add multiple images to better reach",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Color(0xFF615B68),
                        letterSpacing: -0.40,
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegisterBody(
                          title: "Material",
                          controller: materialController,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        RegisterBody(
                          title: "Shoe number",
                          controller: shoeNumberController,
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 20.h),
                        RegisterBody(
                          title: "How Old",
                          controller: ageController,
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 20.h),
                        RegisterBody(
                          title: "Model",
                          controller: modelController,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        RegisterBody(
                          title: "Ideal for",
                          controller: idealController,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        RegisterBody(
                          title: "Style",
                          controller: styleController,
                          type: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.h),
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          setState(() {
                            isSpecification = true;
                          });
                          // await ref.read(
                          //   specificationProvider(
                          //     ProductSpecificationBodyModel(
                          //       productId: widget.id,
                          //       material: materialController.text,
                          //       sizeOrShoeNumber: shoeNumberController.text,
                          //       ageOrHowOld: ageController.text,
                          //       model: modelController.text,
                          //       idealFor: idealController.text,
                          //       style: styleController.text,
                          //     ),
                          //   ).future,
                          // );
                          final res = ProductSpecificationBodyModel(
                            productId: widget.productId,
                            material: materialController.text,
                            sizeOrShoeNumber: shoeNumberController.text,
                            ageOrHowOld: ageController.text,
                            model: modelController.text,
                            idealFor: idealController.text,
                            style: styleController.text,
                          );
                          final specificationservice = SpecificationService(
                            await createDio(),
                          );
                          final response = await specificationservice
                              .addSpecificationProduct(res);
                          Fluttertoast.showToast(msg: "complete");
                          log(res.productId.toString());
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder:
                                  (context) => ListingReviewPage(
                                    proId: widget.productId,
                                  ),
                            ),
                          );
                        } catch (e) {
                          setState(() {
                            isSpecification = false;
                          });
                          log(e.toString());
                          Fluttertoast.showToast(
                            msg: "Add Product Specification Failed",
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 49.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.45.r),
                          color: Color.fromARGB(255, 137, 26, 255),
                        ),
                        child: Center(
                          child:
                              isSpecification == false
                                  ? Text(
                                    "Upload your products",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                  : CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
