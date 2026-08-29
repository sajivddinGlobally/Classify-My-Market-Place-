import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/facebookLogin/facebookService.dart';
import 'package:shopping_app_olx/googleLogin/googleAuthService.dart';
import 'package:shopping_app_olx/googleLogin/googleService.dart';
import 'package:shopping_app_olx/googleLogin/model/googleLoginBodyModel.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/login/Model/loginBodyModel.dart';
import 'package:shopping_app_olx/login/otp.page.dart';
import 'package:shopping_app_olx/login/service/loginService.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/register/register.page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneController = TextEditingController();
  bool islogin = false;
  bool termsAccepted = false; // ← new state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              // height: MediaQuery.of(context).size.height + 50,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height + 250,
              ),
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

                        // ── Checkbox + Terms & Conditions ────────────────────────
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24.h,
                              width: 24.w,
                              child: Checkbox(
                                value: termsAccepted,
                                activeColor: Color(0xFF891AFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                onChanged: (bool? value) {
                                  setState(() {
                                    termsAccepted = value ?? false;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "I agree to the ",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14.sp,
                                    color: Color(0xFF615B68),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14.sp,
                                        color: Color(0xFF891AFF),
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                      ),
                                      // Optional: add recognizer to open terms page
                                      // recognizer: TapGestureRecognizer()
                                      //   ..onTap = () {
                                      //     // Navigator.push(... Terms page)
                                      //   },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24.h),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              MediaQuery.of(context).size.width,
                              49.h,
                            ),
                            backgroundColor: Color.fromARGB(255, 137, 26, 255),
                          ),
                          onPressed: () async {
                            // ── First check terms ─────────────────────────────
                            if (!termsAccepted) {
                              Fluttertoast.showToast(
                                msg: "Please accept Terms & Conditions",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              return;
                            }

                            // ── Then check phone number ───────────────────────
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
                                msg: response.message ?? "",
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
                                msg: "Login Failed. Try again.",
                              );
                              log(e.toString());
                            }
                          },
                          child:
                              islogin == false
                                  ? Text(
                                    "Login",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                  : SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                "OR",
                                style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              showDialog(
                                barrierDismissible: false,
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  );
                                },
                              );
                              final googleAuth = GoogleAuthService();

                              final String? idToken =
                                  await googleAuth.signInWithGoogle();

                              if (idToken == null) {
                                Fluttertoast.showToast(
                                  msg: "Google Sign-In Failed",
                                );
                                return;
                              }
                              final body = GoogleLoginBodyResModel(
                                idToken: idToken,
                              );

                              final service = GoogleService(createDio());

                              final response = await service.googleLogin(body);

                              if (response.status == true) {
                                var box = await Hive.openBox("data");

                                await box.put("token", response.token);
                                await box.put(
                                  "id",
                                  response.user!.id.toString(),
                                );
                                await box.put(
                                  "full_name",
                                  response.user!.fullName ?? "",
                                );
                                await box.put(
                                  "address",
                                  response.user!.address ?? "",
                                );
                                await box.put(
                                  "city",
                                  response.user!.city ?? "",
                                );
                                await box.put(
                                  "phone_number",
                                  response.user!.phoneNumber,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: response.message ?? "Login Failed",
                                );
                                if (Navigator.canPop(context)) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                }
                              }
                            } catch (e, stackTrace) {
                              log("ERROR: $e");
                              log("STACK: $stackTrace");

                              Fluttertoast.showToast(
                                msg: "Something went wrong",
                              );
                            } finally {
                              if (Navigator.canPop(context)) {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 52.h),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          icon: Image.asset("assets/g.png", height: 24),
                          label: Text(
                            "Continue with Google",
                            style: GoogleFonts.dmSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.w),
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              showDialog(
                                barrierDismissible: false,
                                barrierColor: Colors.transparent,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  );
                                },
                              );

                              final facebookAuth = FacebookAuthService();

                              final String? token =
                                  await facebookAuth.signInWithFacebook();

                              if (token == null) {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }

                                Fluttertoast.showToast(
                                  msg: "Facebook Login Failed or Cancelled",
                                );
                                return;
                              }

                              log("Facebook Token => $token");

                              final body = FacebookLoginBodyModel(
                                accessToken: token,
                              );
                              final service = GoogleService(createDio());
                              final response = await service.facebookLogin(
                                body,
                              );
                              if (response.status == true) {
                                var box = await Hive.openBox("data");

                                await box.put("token", response.token);
                                await box.put(
                                  "id",
                                  response.user!.id.toString(),
                                );
                                await box.put(
                                  "full_name",
                                  response.user!.fullName ?? "",
                                );
                                await box.put(
                                  "address",
                                  response.user!.address ?? "",
                                );
                                await box.put(
                                  "city",
                                  response.user!.city ?? "",
                                );
                                await box.put(
                                  "phone_number",
                                  response.user!.phoneNumber,
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: response.message ?? "Login Failed",
                                );
                                if (Navigator.canPop(context)) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                }
                              }
                            } catch (e, stackTrace) {
                              log("ERROR: $e");
                              log("STACK: $stackTrace");

                              Fluttertoast.showToast(
                                msg: "Something went wrong",
                              );
                            } finally {
                              if (Navigator.canPop(context)) {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 52.h),
                            backgroundColor: Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          icon: Image.asset(
                            "assets/f.png",
                            height: 24,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Continue with Facebook",
                            style: GoogleFonts.dmSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
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

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
