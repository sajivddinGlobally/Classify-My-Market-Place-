import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = 'card';

  final List<Map<String, String>> paymentMethods = [
    {
      'id': 'card',
      'title': 'Credit/Debit Card',
      'subtitle': 'Choose one of your credit/debit card',
    },
    {
      'id': 'netbanking',
      'title': 'Net Banking',
      'subtitle': 'Add your net banking credentials',
    },
    {
      'id': 'upi',
      'title': 'UPI Platform',
      'subtitle': 'Choose any UPI platform of your choice',
    },
    {
      'id': 'cod',
      'title': 'Cash on delivery',
      'subtitle': 'Pay on the time of delivery',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 242, 247),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60.h),
          Row(
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
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
                  child: Center(child: Icon(Icons.arrow_back)),
                ),
              ),
              SizedBox(width: 100.w),
              Text(
                "Checkout",
                style: GoogleFonts.dmSans(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 33, 36, 38),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 25.h),
            child: Text(
              "Choose Payment Method",
              style: GoogleFonts.dmSans(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 33, 36, 38),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children:
                  paymentMethods.map((method) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              selectedMethod == method['id']
                                  ? Color(0xFF8D3AFF)
                                  : Colors.transparent,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: method['id']!,
                        groupValue: selectedMethod,
                        onChanged: (value) {
                          setState(() {
                            selectedMethod = value!;
                          });
                        },
                        activeColor: const Color(0xFF8D3AFF),
                        title: Text(
                          method['title']!,
                          style: GoogleFonts.dmSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          method['subtitle']!,
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 119, 112, 128),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 2.h,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 50.h),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 49.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.45.r),
                  color: Color.fromARGB(255, 137, 26, 255),
                ),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: GoogleFonts.dmSans(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}

class Paymentbody extends StatefulWidget {
  final String title;
  final String subtitle;
  final String groupValue;
  final ValueChanged<String> onChanged;
  const Paymentbody({
    super.key,
    required this.title,
    required this.subtitle,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  State<Paymentbody> createState() => _PaymentbodyState();
}

class _PaymentbodyState extends State<Paymentbody> {
  String selectedOption = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 71.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Radio(
              activeColor: Color.fromARGB(255, 137, 26, 255),
              value: "",
              groupValue: selectedOption,
              onChanged: (value) {},
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 33, 36, 38),
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 119, 112, 128),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
