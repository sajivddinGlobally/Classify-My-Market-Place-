import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/login/Model/loginBodyModel.dart';
import 'package:shopping_app_olx/login/otp.page.dart';
import 'package:shopping_app_olx/login/service/loginService.dart';
import 'package:shopping_app_olx/register/register.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  final phoneController = TextEditingController();
  bool islogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [

            Container(
              height: MediaQuery.of(context).size.height + 50,
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
              top: 100.h,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Image.asset("assets/loginimage.png"),
                  SizedBox(height: 50.h),


                  Center(
                    child: Text(
                      "Welcome Back",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w500,
                        fontSize: 26.sp,
                        color: Color(0xFF242126),
                      ),
                    ),
                  ),


                  Padding(
                    padding: EdgeInsets.only(left: 44.w, right: 44.w),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Welcome Back to our platform to get best product and sell your products for extra earnings",
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
                        Text(
                          "Phone Number",
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
                          controller: phoneController,
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(35.45.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(35.45.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),

                        ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              MediaQuery.of(context).size.width,
                              49.h,
                            ),
                            backgroundColor: Color.fromARGB(255, 137, 26, 255),
                          ),

                          onPressed: () async {
                            if (phoneController.text.isEmpty ||
                                phoneController.text.length != 10) {
                              Fluttertoast.showToast(
                                msg: "Please enter valid phone number",
                              );
                              return;
                            }
                            setState(() {
                              islogin = true;
                            });

                            try {
                              final body = LoginBodyModel(
                                phoneNumber: phoneController.text,
                              );

                              final loginservice = LoginService(
                                await createDio(),
                              );

                              final response = await loginservice.login(body);

                              Fluttertoast.showToast(
                                msg: response.message??""
                              );

                              setState(() {
                                islogin = false;
                              });

                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder:
                                      (context) =>
                                          OtpPage(phone: phoneController.text),
                                ),
                              );

                              Fluttertoast.showToast(
                                msg: "${response.message}",
                                fontSize: 30.sp,
                                timeInSecForIosWeb: 40,
                                gravity: ToastGravity.TOP,
                                toastLength: Toast.LENGTH_LONG,
                              );

                            } on DioException catch (e) {
                              setState(() {
                                islogin = false;
                              });
                              if (e.response != null) {
                                Fluttertoast.showToast(
                                  msg: "${e.response?.data['message']}",
                                );
                              }
                            } catch (e) {
                              setState(() {
                                islogin = false;
                              });
                              Fluttertoast.showToast(
                                msg: "Login Failed Try again.",
                              );
                              log(e.toString());
                            }
                          },

                          child:
                              islogin == false
                                  ?

                              Text(
                                    "Login",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )

                                  :

                              SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                        ),

                        SizedBox(height: 50.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don’t have an account?",
                              style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF615B68),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(
                                " Register",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF891AFF),
                                ),
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

          ],
        ),
      ),
    );
  }


}
