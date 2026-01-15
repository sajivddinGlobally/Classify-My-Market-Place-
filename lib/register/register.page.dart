/*
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/login/login.page.dart';
import 'package:shopping_app_olx/register/service/registerController.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      // Form(
      //   key: _formKey,
      //   child:
        SingleChildScrollView(
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

              Positioned.fill(
                top: 168.h,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: Text(
                        "Welcome to App name",
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
                        "Register yourself to our platform to get best product and sell your products for extra earnings",
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
                            title: "Full Name",
                            controller: nameController,
                            type: TextInputType.text,
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(height: 20.h),
                          Column(
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
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      35.45.r,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Phone Numer is required";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          RegisterBody(
                            title: "Street Address",
                            controller: addController,
                            type: TextInputType.streetAddress,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: RegisterBody(
                                  title: "City",
                                  controller: cityController,
                                  type: TextInputType.text,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
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
                                      keyboardType: TextInputType.number,
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
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            35.45.r,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    35.45.r,
                                                  ),
                                              borderSide: BorderSide.none,
                                            ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Pincode is required";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                49.h,
                              ),
                              backgroundColor: Color.fromARGB(
                                255,
                                137,
                                26,
                                255,
                              ),
                            ),
                            onPressed: () async {
                              final nameController = TextEditingController();
                              final emailController = TextEditingController();
                              final phoneController = TextEditingController();
                              final addController = TextEditingController();
                              final cityController = TextEditingController();
                              final pincodeController = TextEditingController();

                              // Validate all fields
                              if (nameController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter a name")),
                                );
                                return;
                              }

                              if (emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter an email")),
                                );
                                return;
                              }

                              if (phoneController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter a phone number")),
                                );
                                return;
                              }

                              if (addController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter an address")),
                                );
                                return;
                              }

                              if (cityController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter a city")),
                                );
                                return;
                              }

                              if (pincodeController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter a pincode")),
                                );
                                return;
                              }

                              try {
                                setState(() {
                                  isRegister = true;
                                });

                                await RegisterController.register(
                                  context: context,
                                  full_name: nameController.text,
                                  phone_number: phoneController.text,
                                  address: addController.text,
                                  city: cityController.text,
                                  pincode: pincodeController.text,
                                );

                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(builder: (context) => LoginPage()),
                                        (route) => false,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Registration failed: ${e.toString()}")),
                                  );
                                }
                                setState(() {
                                  isRegister = false;
                                });
                                log('Registration error: ${e.toString()}');
                              } finally {
                                // Dispose controllers to prevent memory leaks
                                nameController.dispose();
                                emailController.dispose();
                                phoneController.dispose();
                                addController.dispose();
                                cityController.dispose();
                                pincodeController.dispose();
                              }
                            },
                            child:
                                isRegister == false
                                    ? Text(
                                      "Register",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                          SizedBox(height: 50.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
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
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "  Login",
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
      // ),
    );
  }
}





class RegisterBody extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType type;
  const RegisterBody({
    super.key,
    required this.title,
    required this.controller,
    required this.type,
  });
  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          widget.title,
          style: GoogleFonts.dmSans(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF615B68),
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          keyboardType: widget.type,
          controller: widget.controller,
          decoration: InputDecoration(
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
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(35.45.r),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(35.45.r),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "${widget.title} is required";
            }
            return null;
          },
        ),


      ],
    );
  }
}
*/




import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app_olx/login/login.page.dart';
import 'package:shopping_app_olx/register/service/registerController.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  bool isRegister = false;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height + 50,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFECD7FD), Color(0xFFF5F2F7)],
                  ),
                ),
              ),
              Image.asset("assets/bgimage.png"),
              Positioned.fill(
                top: 168.h,
                left: 0,
                right: 0,
                child:
                SingleChildScrollView(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Welcome to App name",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 26.sp,
                          color: const Color(0xFF242126),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 44.w),
                      child: Text(
                        textAlign: TextAlign.center,
                        "Register yourself to our platform to get best product and sell your products for extra earnings",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: const Color(0xFF615B68),
                          letterSpacing: -0.75,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RegisterBody(
                            title: "Full Name",
                            controller: nameController,
                            type: TextInputType.text,
                          ),
                          // SizedBox(height: 20.h),
                          // RegisterBody(
                          //   title: "Email",
                          //   controller: emailController,
                          //   type: TextInputType.emailAddress,
                          // ),
                          SizedBox(height: 20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone Number",
                                style: GoogleFonts.dmSans(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF615B68),
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
                                  fillColor: const Color(0xFFFFFFFF),
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.45.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.45.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.45.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(35.45.r),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Phone Number is required";
                                  }
                                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                    return "Enter a valid 10-digit phone number";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          RegisterBody(
                            title: "Street Address",
                            controller: addController,
                            type: TextInputType.streetAddress,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: RegisterBody(
                                  title: "City",
                                  controller: cityController,
                                  type: TextInputType.text,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pincode",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF615B68),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    TextFormField(
                                      maxLength: 6,
                                      keyboardType: TextInputType.number,
                                      controller: pincodeController,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        filled: true,
                                        fillColor: const Color(0xFFFFFFFF),
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(35.45.r),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(35.45.r),
                                          borderSide: BorderSide.none,
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(35.45.r),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedErrorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.circular(35.45.r),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Pincode is required";
                                        }
                                        if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                                          return "Enter a valid 6-digit pincode";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(
                                MediaQuery.of(context).size.width,
                                49.h,
                              ),
                              backgroundColor: const Color.fromARGB(255, 137, 26, 255),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {

                                  setState(() {
                                    isRegister = true;
                                  });


                                  await RegisterController.register(
                                    context: context,
                                    fullname: nameController.text,
                                    phonenumber: phoneController.text,
                                    address: addController.text,
                                    city: cityController.text,
                                    pincode: pincodeController.text,
                                  );

                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(builder: (context) => const LoginPage()),
                                          (route) => false,
                                    );
                                  }
                                }

                                catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Registration failed. Please try again.")),
                                    );
                                  }
                                  setState(() {
                                    isRegister = false;
                                  });
                                  log('Registration error: ${e.toString()}');
                                }

                              }
                            },
                            child: isRegister
                                ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              "Register",
                              style: GoogleFonts.dmSans(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,

                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF615B68),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  " Login",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF891AFF),
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
              ) ],
          ),
        ),
      ),
    );
  }
}

class RegisterBody extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType type;

  const RegisterBody({
    super.key,
    required this.title,
    required this.controller,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF615B68),
          ),
        ),
        SizedBox(height: 12.h),
        TextFormField(
          keyboardType: type,
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFFFFF),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(35.45.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(35.45.r),
              borderSide: BorderSide.none,
            ),
            errorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(35.45.r),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(35.45.r),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "$title is required";
            }
            if (title == "Email" && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
      ],
    );
  }
}