import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopping_app_olx/product/productSpecification.page.dart';
import 'package:shopping_app_olx/product/service.addproduct/addproductController.dart';

import 'package:shopping_app_olx/register/register.page.dart';

class ProductRegisterPage extends StatefulWidget {
  const ProductRegisterPage({super.key});

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final categoryController = TextEditingController();
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final numberController = TextEditingController();
  final pincodeController = TextEditingController();
  final productDesController = TextEditingController();
  final addressController = TextEditingController();

  bool isAddProduct = false;
  File? image;
  final picker = ImagePicker();

  Future pickImageFromGallery() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final PickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (PickedFile != null) {
        setState(() {
          image = File(PickedFile.path);
        });
      }
    } else {
      print("Gallery permission is denied");
    }
  }

  Future pickImageFromCamera() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      final PickedFile = await picker.pickImage(source: ImageSource.camera);
      if (PickedFile != null) {
        setState(() {
          image = File(PickedFile.path);
        });
      }
    } else {
      print("Camera permission isdened");
    }
  }

  Future showImage() async {
    showCupertinoModalPopup(
      context: context,
      builder:
          (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImageFromGallery();
                },
                child: Text("Gallery"),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  pickImageFromCamera();
                },
                child: Text("Camera"),
              ),
            ],
          ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 2,
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
                        "Enter Product Details",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
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
                        "Join our platform today to showcase your items and boost your earnings!",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color(0xFF615B68),
                          letterSpacing: -0.75,
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
                            title: "Product Category",
                            controller: categoryController,
                            type: TextInputType.text,
                          ),
                          SizedBox(height: 20.h),
                          RegisterBody(
                            title: "Product Name",
                            controller: productNameController,
                            type: TextInputType.text,
                          ),
                          SizedBox(height: 20.h),
                          RegisterBody(
                            title: "Price",
                            controller: priceController,
                            type: TextInputType.number,
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contact at",
                                style: GoogleFonts.dmSans(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF615B68),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              TextFormField(
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                controller: numberController,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pincode",
                                style: GoogleFonts.dmSans(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF615B68),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              TextFormField(
                                maxLength: 6,
                                keyboardType: TextInputType.phone,
                                controller: pincodeController,
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter pincode';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20.h),
                              RegisterBody(
                                title: "Address",
                                controller: addressController,
                                type: TextInputType.text,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product Description ",
                                style: GoogleFonts.dmSans(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF615B68),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              TextFormField(
                                maxLines: 6,
                                keyboardType: TextInputType.text,
                                controller: productDesController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 20.h,
                                    left: 20.w,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFFFFFFF),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Center(
                            child: DottedBorder(
                              color: Color.fromARGB(255, 255, 151, 54),
                              strokeWidth: 2,
                              dashPattern: [6, 3],
                              borderType: BorderType.RRect,
                              radius: Radius.circular(
                                35.r,
                              ), // Border radius for rounded rectangles
                              child: GestureDetector(
                                onTap: () {
                                  showImage();
                                },
                                child: Container(
                                  width: 344.w,
                                  height: 155.h,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(35.r),
                                  ),
                                  child:
                                      image == null
                                          ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.upload),
                                              SizedBox(height: 10.h),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Upload files or",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromARGB(
                                                            255,
                                                            69,
                                                            69,
                                                            69,
                                                          ),
                                                        ),
                                                  ),
                                                  Text(
                                                    " Browse",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color.fromARGB(
                                                            255,
                                                            255,
                                                            101,
                                                            0,
                                                          ),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              Color.fromARGB(
                                                                255,
                                                                255,
                                                                101,
                                                                0,
                                                              ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "Supported formates: JPEG, PNG,PDF,",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                    255,
                                                    69,
                                                    69,
                                                    69,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                          : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              35.r,
                                            ),
                                            child: Image.file(
                                              image!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.r),
                            child: GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (image == null) {
                                    Fluttertoast.showToast(
                                      msg: "Please upload an image",
                                    );
                                    return;
                                  }
                                  try {
                                    setState(() {
                                      isAddProduct = true;
                                    });
                                    var box = await Hive.box("data");
                                    final addprodut =
                                        await AddproductRegisterController.Addregister(
                                          category: categoryController.text,
                                          name: categoryController.text,
                                          price: priceController.text,
                                          contact: numberController.text,
                                          pincode: pincodeController.text,
                                          address: addressController.text,
                                          description:
                                              productDesController.text,
                                          image: image!,
                                          user_id: '${box.get("id")}',
                                        );

                                    Fluttertoast.showToast(
                                      msg: "Add Product Successful",
                                    );
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder:
                                            (context) =>
                                                ProductspecificationPage(
                                                  productId:
                                                      addprodut.product.id
                                                          .toString(),
                                                ),
                                      ),
                                    );
                                  } catch (e) {
                                    setState(() {
                                      isAddProduct = false;
                                    });
                                    Fluttertoast.showToast(msg: "Failed");
                                    log(e.toString());
                                  }
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 49.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35.45.r),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 137, 26, 255),
                                    width: 1.w,
                                  ),
                                ),
                                child: Center(
                                  child:
                                      isAddProduct == false
                                          ? Text(
                                            "Next",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                255,
                                                137,
                                                26,
                                                255,
                                              ),
                                            ),
                                          )
                                          : CircularProgressIndicator(
                                            color: Color.fromARGB(
                                              255,
                                              137,
                                              26,
                                              255,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
