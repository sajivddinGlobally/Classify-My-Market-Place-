/*
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/new/controller/plan.provider.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/plan/reting.page.dart';
import '../home/home.page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PlanPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? pendingProductData;
  bool booleanData;
  PlanPage(this.pendingProductData, this.booleanData, {super.key});
  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  int tabBottom = 0;
  DateTime? lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(planProvider);

    return PopScope(
      canPop: false,

      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(page: 3)),
          );
        }
      },

      child: Scaffold(
        body: plan.when(
          data: (snap) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height + 100,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(page: 3),
                          ),
                        );
                        // Navigator.pop(context);
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
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Paid Plan",
                              style: GoogleFonts.dmSans(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 33, 36, 38),
                              ),
                            ),
                          ),

                          DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  dividerColor: Color.fromARGB(
                                    255,
                                    137,
                                    25,
                                    255,
                                  ),
                                  dividerHeight: 1.w,
                                  unselectedLabelColor: Color.fromARGB(
                                    255,
                                    30,
                                    30,
                                    30,
                                  ),
                                  labelColor: Colors.black,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                  indicatorWeight: 6.w,
                                  indicatorColor: Color.fromARGB(
                                    255,
                                    137,
                                    25,
                                    255,
                                  ),
                                  tabs: [
                                    if (widget.booleanData)
                                      Tab(
                                        child: Text(
                                          "Single Listing ",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              137,
                                              25,
                                              255,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (widget.booleanData)
                                      Tab(
                                        child: Text(
                                          "Multiple Listing ",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              30,
                                              30,
                                              30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (!widget.booleanData)
                                      Tab(
                                        child: Text(
                                          "",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                              255,
                                              30,
                                              30,
                                              30,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                                SizedBox(
                                  height: 550.h,
                                  child: TabBarView(
                                    children: [
                                      if (widget.booleanData)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder:
                                                    (context) => RetingPage(),
                                              ),
                                            );
                                          },
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                ...snap.data
                                                    .where(
                                                      (e) =>
                                                          e.planType ==
                                                          "single",
                                                    )
                                                    .map(
                                                      (e) => Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              top: 10.h,
                                                            ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.vertical(
                                                                      top: Radius.circular(
                                                                        20.r,
                                                                      ),
                                                                    ),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              builder:
                                                                  (
                                                                    _,
                                                                  ) => PaymentBottomSheet(
                                                                    amount:
                                                                        e.price !=
                                                                                null
                                                                            ? double.tryParse(
                                                                              e.price!,
                                                                            )
                                                                            : 0.0,
                                                                    id:
                                                                        e.id.toString(),
                                                                      booleanData:   widget.booleanData,
                                                                 data:   widget.pendingProductData
                                                                  ),
                                                            );
                                                          },
                                                          child: PlanBody(
                                                            flag: false,
                                                            planID:
                                                                e.id.toString(),
                                                            titlename: e.price,
                                                            duration:
                                                                e.duration
                                                                    .toString(),
                                                            desc: e.description,
                                                            addBoost:
                                                                e.boostCount
                                                                    .toString(),
                                                            bgColor:
                                                                Colors.white,
                                                            plan: Colors.black,
                                                            month: Colors.black,
                                                            name: Colors.black,
                                                            title: Colors.black,
                                                            listing_type:
                                                                e.listing_type
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                        ),

                                      // Multiple Listing Plans
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder:
                                                  (context) => RetingPage(),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            ...snap.data
                                                .where(
                                                  (e) =>
                                                      e.planType == "multiple",
                                                )
                                                .map(
                                                  (e) => Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 10.h,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                  top:
                                                                      Radius.circular(
                                                                        20.r,
                                                                      ),
                                                                ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.white,
                                                          builder:
                                                              (
                                                                _,
                                                              ) => PaymentBottomSheet(
                                                                amount:
                                                                    double.tryParse(
                                                                      e.price!,
                                                                    ) ??
                                                                    0.0,
                                                                id:
                                                                    e.id.toString(),
                                                                  booleanData:   widget.booleanData,
                                                                  data:   widget.pendingProductData
                                                              ),
                                                        );
                                                      },
                                                      child: PlanBody(
                                                        flag: true,
                                                        planID: e.id.toString(),
                                                        titlename: e.price!,
                                                        duration:
                                                            e.duration
                                                                .toString(),
                                                        desc: e.description,
                                                        addBoost:
                                                            e.boostCount
                                                                .toString(),
                                                        bgColor: Colors.white,
                                                        plan: Colors.black,
                                                        month: Colors.black,
                                                        name: Colors.black,
                                                        title: Colors.black,
                                                        listing_type:
                                                            e.listing_type
                                                                .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30.h),

                          SizedBox(height: 15.h),

                          SizedBox(height: 40.h),

                          SizedBox(height: 60.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (err, stack) {
            return Center(child: Text("$err"));
          },
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class PlanBody extends StatefulWidget {
  final bool flag;
  final String planID;
  final Color bgColor;
  final Color plan;
  final Color month;
  final Color name;
  final Color title;
  String? titlename;
  final String duration;
  final String desc;
  final String addBoost;
  final String listing_type;
  PlanBody({
    super.key,
    required this.flag,
    required this.bgColor,
    required this.plan,
    required this.month,
    required this.name,
    required this.title,
    this.titlename,
    required this.duration,
    required this.desc,
    required this.addBoost,
    required this.planID,
    required this.listing_type,
  });

  @override
  State<PlanBody> createState() => _PlanBodyState();
}

class _PlanBodyState extends State<PlanBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 166.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: widget.bgColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.plan,
                ),
                children: [
                  TextSpan(
                    text:
                        widget.titlename != null
                            ? '₹${widget.titlename}/'
                            : 'Free Plan/', // या "Contact Us" या "₹0/"
                    style: GoogleFonts.dmSans(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.plan,
                    ),
                  ),
                  // बाकी WidgetSpan वही रखो
                  widget.flag == true
                      ? WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Text(
                          '${widget.addBoost} Ad / month',
                          style: GoogleFonts.dmSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: widget.month,
                          ),
                        ),
                      )
                      : WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Text(
                          '${widget.addBoost} Ad',
                          style: GoogleFonts.dmSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: widget.month,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, size: 16.sp),
                SizedBox(width: 10.w),
                Text(
                  "Radius",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.title,
                    letterSpacing: -0.50,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(Icons.arrow_forward, size: 16.sp),
                SizedBox(width: 10.w),
                Text(
                  widget.listing_type ?? "",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.title,
                    letterSpacing: -0.50,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Icon(Icons.star, size: 16.sp),
                SizedBox(width: 10.w),
                Text(
                  "${widget.duration} Days Live",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.name,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, size: 16.sp),
                    SizedBox(width: 10.w),
                    Text(
                      "Unlimited Chats",
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: widget.title,
                        letterSpacing: -0.50,
                      ),
                    ),
                  ],
                ),

                Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureBody extends StatefulWidget {
  final String txt;
  const FeatureBody({super.key, required this.txt});

  @override
  State<FeatureBody> createState() => _FeatureBodyState();
}

class _FeatureBodyState extends State<FeatureBody> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: Color.fromARGB(255, 97, 91, 104)),
        SizedBox(width: 10.w),
        SizedBox(
          width: 330.w,
          child: Text(
            overflow: TextOverflow.ellipsis,
            widget.txt,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 97, 91, 104),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentBottomSheet extends StatefulWidget {
  final String id;
  double? amount;
  final double gstPercentage;
  bool? booleanData;
  final Map<String, dynamic>? data;


  PaymentBottomSheet({
    super.key,
    this.amount,
    this.gstPercentage = 18,
    required this.id,
    this.data,
    this.booleanData
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  bool loder = false;
  late Razorpay _razorpay;
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response1) async {
  //   print("Full Response: $response1");
  //   print("Payment ID: ${response1.paymentId}");
  //   print("Order ID: ${response1.orderId}");
  //   print(
  //     "Signature: ${response1.signature}",
  //   ); // Yeh null ho sakta hai non-order payments mein
  //
  //   // Prevent if essential data missing
  //   if (response1.paymentId == null || response1.paymentId!.isEmpty) {
  //     _showSnackBar("Payment ID missing. Try again.", isError: true);
  //     return;
  //   }
  //
  //   try {
  //     final state = APIService(createDio());
  //     final verifyResponse = await state.verify(
  //       paymentId: response1.paymentId!,
  //       orderId: response1.orderId ?? "", // null ho sakta hai
  //       signature:
  //           response1.signature ??
  //           "", // null safe – agar null hai to empty string bhejo
  //     );
  //
  //     if (verifyResponse.success != true) {
  //       throw Exception("Server verification failed: ${verifyResponse}");
  //     }
  //     var box = Hive.box("data");
  //     final userId = box.get('id');
  //
  //     if (userId == null) {
  //       throw Exception("User not logged in");
  //     }
  //
  //     final buyPlanResponse = await state.buyPlanSucees(
  //       userId: userId.toString(),
  //       trnxId: response1.paymentId.toString(),
  //       paymentType: 'success',
  //       status: 'complete',
  //       planId: widget.id.toString(),
  //     );
  //
  //     _showSnackBar("Payment Successful & Plan Activated!", isError: false);
  //
  //     Navigator.pop(context);
  //   } catch (e) {
  //     print("Payment Handle Error: $e");
  //     _showSnackBar("Verification/Payment Failed: $e", isError: true);
  //   } finally {
  //     if (mounted) {
  //       setState(() => loder = false); // ya loader spelling correct kar lo
  //     }
  //   }
  // }


  void _handlePaymentSuccess(PaymentSuccessResponse response1) async {
    if (response1.paymentId == null || response1.paymentId!.isEmpty) {
      _showSnackBar("Payment ID missing.", isError: true);
      return;
    }

    try {
      final apiService = APIService(await createDio());
      // Verify payment
      final verifyResponse = await apiService.verify(
        paymentId: response1.paymentId!,
        orderId: response1.orderId ?? "",
        signature: response1.signature ?? "",
      );
      // if (!verifyResponse.success) throw Exception("Verification failed");
      var box = Hive.box("data");
      final userId = box.get('id');
      if (userId == null) throw Exception("User not logged in");
      // Activate plan
      await apiService.buyPlanSucees(
        userId: userId.toString(),
        trnxId: response1.paymentId!,
        paymentType: 'success',
        status: 'complete',
        planId: widget.id,
      );
      _showSnackBar("Payment Successful! Plan Activated 🎉", isError: false);
      // _showSnackBar("Paid Plan Activated Successfully!", isError: false);

      Fluttertoast.showToast(
        msg: "Paid Plan Active! Now you can post your ad.",
        backgroundColor: Colors.green,
      );

      // Direct product form page pe wapas bhejo (images dobara select karne ke liye)
      if (mounted) {
        Navigator.pop(context); // sheet close
        Navigator.pop(context); // PlanPage close


      }
        catch (e) {
          Fluttertoast.showToast(
            msg: "Plan activated but product posting failed.",
            backgroundColor: Colors.orange,
          );
        }


      // Clean navigation to Home
      // if (mounted) {
      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     CupertinoPageRoute(builder: (_) => const HomePage()),
      //         (route) => false,
      //   );
      // }

      // Pehle bottom sheet safely close karo
      if (mounted) Navigator.pop(context);

// Phir nayi screen pe jao aur stack clear karo
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const HomePage(page: 0)),
              (route) => false,
        );
      }
    } catch (e) {
      _showSnackBar("Payment failed: $e", isError: true);
    } finally {
      if (mounted) setState(() => loder = false);
    }
  }
  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    print("RAZORPAY ERROR CODE: ${response.code}");
    print("RAZORPAY ERROR MESSAGE: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed: ${response.code} - ${response.message}")),
    );
    setState(() => loder = false);
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    // Proper GST calculation with double values
    final double gstAmount = (widget.amount! * widget.gstPercentage) / 100;
    // Total amount (amount + GST)
    final double totalAmount = widget.amount! + gstAmount;
    // Agar aapko integer (whole number) mein chahiye (jaise rupees without paisa)
    final int finalGstAmount =
        gstAmount.round(); // ya .ceil() / .floor() as needed
    final int finalTotalAmount = totalAmount.round(); // commonly used
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Payment Summary",
            style: GoogleFonts.dmSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),
          // _row("Amount", "₹${widget.amount!.toStringAsFixed(2)}"),
          _row(
            "GST (${widget.gstPercentage}%)",
            "₹${gstAmount.toStringAsFixed(2)}",
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gst Legal Name",
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              Text(
                "Numeric Consultants India llp",
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Address",
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  "Near Kapoor Restaurant, 619, Chattarpur Main Road, New Delhi South Delhi, Delhi, 110074",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          _row(
            "Total",
            "₹${finalTotalAmount.toStringAsFixed(2)}",
            isBold: true,
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 26, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.45.r),
                ),
              ),

              onPressed: () async {
                // Prevent multiple taps
                if (loder) return;

                setState(() => loder = true);

                try {
                  var box = Hive.box("data");
                  final userId = box.get('id');

                  if (userId == null) {
                    Fluttertoast.showToast(msg: "User not logged in");
                    return;
                  }

                  final state = APIService(createDio());

                  // Case 1: Free Plan (amount == 0)
               */
/*   if (finalTotalAmount == 0) {
                    final response = await state.buyPlanSucees(
                      userId: userId.toString(),
                      trnxId:
                          "free_plan_${DateTime.now().millisecondsSinceEpoch}", // unique fake ID
                      paymentType: 'free',
                      status: 'complete',
                      planId: widget.id.toString(),
                    );

                    // if (response.response.data == true) {
                    _showSnackBar(
                      "Free Plan Activated Successfully!",
                      isError: false,
                    );
                    Navigator.pop(context); // Close bottom sheet

                    return; // Important: exit early
                  }*//*


                  // onPressed ke free plan wale part mein, success ke baad:
                */
/*  if (finalTotalAmount == 0) {
                    // ... buyPlanSucees call


                    final response = await state.buyPlanSucees(
                      userId: userId.toString(),
                      trnxId:
                      "free_plan_${DateTime.now().millisecondsSinceEpoch}", // unique fake ID
                      paymentType: 'free',
                      status: 'complete',
                      planId: widget.id.toString(),
                    );

                    _showSnackBar("Free Plan Activated Successfully!", isError: false);
                    Navigator.pop(context);

                    // 🔥 Yahan bhi pending product submit kar do
                    final planPageState = context.findAncestorStateOfType<_PlanPageState>();
                    if (planPageState != null && planPageState.widget.pendingProductData.isNotEmpty) {
                      try {
                        final apiService = APIService(await createDio());
                        await apiService.addProduct(planPageState.widget.pendingProductData);
                        Fluttertoast.showToast(msg: "Product Added Successfully with Free Plan!");
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Plan activated but product submit failed.");
                      }
                    }

                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (_) => HomePage(page: 0)),
                          (route) => false,
                    );

                    return;
                  }*//*


//                   if (finalTotalAmount == 0) {
//                     try {
//                       setState(() => loder = true); // loader on kar do
//
//                       final response = await state.buyPlanSucees(
//                         userId: userId.toString(),
//                         trnxId: "free_plan_${DateTime.now().millisecondsSinceEpoch}",
//                         paymentType: 'free',
//                         status: 'complete',
//                         planId: widget.id.toString(),
//                       );
//
//                       _showSnackBar("Free Plan Activated Successfully!", isError: false);
//
//                       // 🔥 Pending product submit — sabse pehle!
//                       final planPageState = context.findAncestorStateOfType<_PlanPageState>();
//                       if (planPageState != null &&
//                           planPageState.widget.booleanData && // ye condition add kar do
//                           planPageState.widget.pendingProductData != null &&
//                           planPageState.widget.pendingProductData!.isNotEmpty) {
//
//                         try {
//                           final apiService = APIService(await createDio());
//                           await apiService.addProduct(planPageState.widget.pendingProductData!);
//                           Fluttertoast.showToast(msg: "Product Added Successfully with Free Plan! 🎉");
//                         } catch (e) {
//                           print("Free plan product submit error: $e");
//                           Fluttertoast.showToast(
//                             msg: "Plan activated but product submit failed. Try again later.",
//                             backgroundColor: Colors.orange,
//                           );
//                         }
//                       }
//
//                       // Ab finally Home pe jao (clean stack)
//                       // Navigator.pushAndRemoveUntil(
//                       //   context,
//                       //   CupertinoPageRoute(builder: (_) => HomePage(page: 0)),
//                       //       (route) => false,
//                       // );
//                       // Pehle bottom sheet safely close karo
//                       if (mounted) Navigator.pop(context);
//
// // Phir nayi screen pe jao aur stack clear karo
//                       if (mounted) {
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           CupertinoPageRoute(builder: (_) => const HomePage(page: 0)),
//                               (route) => false,
//                         );
//                       }
//
//                     } catch (e) {
//                       print("Free plan activation error: $e");
//                       _showSnackBar("Free Plan Activation Failed", isError: true);
//                     } finally {
//                       if (mounted) {
//                         setState(() => loder = false);
//                       }
//                       // Last mein bottom sheet close karo (safe hai ab)
//                       if (mounted) Navigator.pop(context);
//                     }
//
//                     return;
//                   }

                  if (finalTotalAmount == 0) {
                    try {
                      setState(() => loder = true);

                      final response = await state.buyPlanSucees(
                        userId: userId.toString(),
                        trnxId: "free_plan_${DateTime.now().millisecondsSinceEpoch}",
                        paymentType: 'free',
                        status: 'complete',
                        planId: widget.id.toString(),
                      );

                      _showSnackBar("Free Plan Activated Successfully!", isError: false);

                      Fluttertoast.showToast(
                        msg: "Free Plan Active! Now you can post your ad.",
                        backgroundColor: Colors.green,
                      );

                      // Direct product form page pe wapas bhejo (images dobara select karne ke liye)
                      if (mounted) {
                        Navigator.pop(context); // sheet close
                        Navigator.pop(context); // PlanPage close


                      }

                    } catch (e) {
                      _showSnackBar("Free Plan Activation Failed", isError: true);
                    } finally {
                      if (mounted) setState(() => loder = false);
                    }
                    return;
                  }


                  // Case 2: Paid Plan
                  final verifyResponse = await state.buyPlan(
                    currency: 'INR',
                    description: 'Plan Purchase',
                    user_id: userId.toString(),
                    amount: finalTotalAmount,
                    plan_id: widget.id.toString(),
                  );

                  if (verifyResponse.success != true ||
                      verifyResponse.payment?.orderId == null) {
                    throw Exception("Order creation failed on server");
                  }
                  // Safely parse amount
                  String rawAmount = verifyResponse.payment!.amount.toString();
                  int amountInRupees =
                      int.tryParse(rawAmount) ?? finalTotalAmount; // fallback
                  int amountInPaise = amountInRupees * 100;
                  print("Amount from API: $rawAmount");
                  print("Amount in paise: $amountInPaise");
                  var options = {
                    'key': 'rzp_live_RuYohlH5qc2BfF',
                    'amount': amountInPaise,
                    'name': 'MMP-MY MARKET PLACE', // अपनी app का नाम डालो
                    'description': 'Paid Plan Purchase',
                    'order_id': verifyResponse.payment!.orderId,
                    'currency': 'INR',
                    'timeout': 300,
                    'theme': {
                      'color': '#8A2BE2',
                    }, // आपके app के theme से match करो
                    'prefill': {
                      // अगर user का phone/email stored है तो यहाँ डाल सकते हो
                    },
                  };

                  print("Opening Razorpay with options: $options");
                  _razorpay.open(options);

                  // Note: Payment success/failure will be handled in _handlePaymentSuccess & _handlePaymentError
                } catch (e, stackTrace) {
                  print("Payment Setup Error: $e");
                  print(stackTrace);
                  _showSnackBar(
                    "Payment Failed: ${e.toString()}",
                    isError: true,
                  );
                } finally {
                  // Always hide loader, even if Razorpay opens (success handled separately)
                  if (mounted) {
                    setState(() => loder = false);
                  }
                }
              },

              child:
                  loder == true
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Pay Now",

                        style: GoogleFonts.dmSans(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/new/controller/plan.provider.dart';
import 'package:shopping_app_olx/new/new.service.dart';
import 'package:shopping_app_olx/plan/reting.page.dart';
import '../home/home.page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PlanPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? pendingProductData;
  final bool booleanData; // Changed to final, non-nullable since it's always passed
  PlanPage(this.pendingProductData, this.booleanData, {super.key});

  @override
  ConsumerState<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends ConsumerState<PlanPage> {
  int tabBottom = 0;
  DateTime? lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(planProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(page: 3)),
          );
        }
      },
      child: Scaffold(
        body: plan.when(
          data: (snap) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height + 100,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(page: 3),
                          ),
                        );
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
                    top: 100.h,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Paid Plan",
                              style: GoogleFonts.dmSans(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 33, 36, 38),
                              ),
                            ),
                          ),
                          DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  dividerColor: Color.fromARGB(255, 137, 25, 255),
                                  dividerHeight: 1.w,
                                  unselectedLabelColor: Color.fromARGB(255, 30, 30, 30),
                                  labelColor: Colors.black,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                  ),
                                  indicatorWeight: 6.w,
                                  indicatorColor: Color.fromARGB(255, 137, 25, 255),
                                  tabs: [
                                    if (widget.booleanData)
                                      Tab(
                                        child: Text(
                                          "Single Listing",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 137, 25, 255),
                                          ),
                                        ),
                                      ),
                                    if (widget.booleanData)
                                      Tab(
                                        child: Text(
                                          "Multiple Listing",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 30, 30, 30),
                                          ),
                                        ),
                                      ),
                                    if (!widget.booleanData)
                                      Tab(
                                        child: Text(
                                          "",
                                          style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 30, 30, 30),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                                SizedBox(
                                  height: 550.h,
                                  child: TabBarView(
                                    children: [
                                      if (widget.booleanData)
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) => RetingPage(),
                                              ),
                                            );
                                          },
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                ...snap.data
                                                    .where((e) => e.planType == "single")
                                                    .map(
                                                      (e) => Padding(
                                                    padding: EdgeInsets.only(top: 10.h),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.vertical(
                                                              top: Radius.circular(20.r),
                                                            ),
                                                          ),
                                                          backgroundColor: Colors.white,
                                                          builder: (_) => PaymentBottomSheet(
                                                            amount: e.price != null
                                                                ? double.tryParse(e.price!) ?? 0.0
                                                                : 0.0,
                                                            id: e.id.toString(),
                                                            booleanData: widget.booleanData,
                                                            data: widget.pendingProductData,
                                                          ),
                                                        );
                                                      },
                                                      child: PlanBody(
                                                        flag: false,
                                                        planID: e.id.toString(),
                                                        titlename: e.price,
                                                        duration: e.duration.toString(),
                                                        desc: e.description,
                                                        addBoost: e.boostCount.toString(),
                                                        bgColor: Colors.white,
                                                        plan: Colors.black,
                                                        month: Colors.black,
                                                        name: Colors.black,
                                                        title: Colors.black,
                                                        listing_type: e.listing_type.toString(),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) => RetingPage(),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            ...snap.data
                                                .where((e) => e.planType == "multiple")
                                                .map(
                                                  (e) => Padding(
                                                padding: EdgeInsets.only(top: 10.h),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(20.r),
                                                        ),
                                                      ),
                                                      backgroundColor: Colors.white,
                                                      builder: (_) => PaymentBottomSheet(
                                                        amount: double.tryParse(e.price!) ?? 0.0,
                                                        id: e.id.toString(),
                                                        booleanData: widget.booleanData,
                                                        data: widget.pendingProductData,
                                                      ),
                                                    );
                                                  },
                                                  child: PlanBody(
                                                    flag: true,
                                                    planID: e.id.toString(),
                                                    titlename: e.price!,
                                                    duration: e.duration.toString(),
                                                    desc: e.description,
                                                    addBoost: e.boostCount.toString(),
                                                    bgColor: Colors.white,
                                                    plan: Colors.black,
                                                    month: Colors.black,
                                                    name: Colors.black,
                                                    title: Colors.black,
                                                    listing_type: e.listing_type.toString(),
                                                  ),
                                                ),
                                              ),
                                            )
                                                .toList(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(height: 15.h),
                          SizedBox(height: 40.h),
                          SizedBox(height: 60.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          error: (err, stack) {
            return Center(child: Text("$err"));
          },
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class PlanBody extends StatefulWidget {
  final bool flag;
  final String planID;
  final Color bgColor;
  final Color plan;
  final Color month;
  final Color name;
  final Color title;
  final String? titlename;
  final String duration;
  final String desc;
  final String addBoost;
  final String listing_type;

  PlanBody({
    super.key,
    required this.flag,
    required this.bgColor,
    required this.plan,
    required this.month,
    required this.name,
    required this.title,
    this.titlename,
    required this.duration,
    required this.desc,
    required this.addBoost,
    required this.planID,
    required this.listing_type,
  });

  @override
  State<PlanBody> createState() => _PlanBodyState();
}

class _PlanBodyState extends State<PlanBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 166.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: widget.bgColor,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 25.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.plan,
                ),
                children: [
                  TextSpan(
                    text: widget.titlename != null ? '₹${widget.titlename}/' : 'Free Plan/',
                    style: GoogleFonts.dmSans(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.plan,
                    ),
                  ),
                  widget.flag == true
                      ? WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Text(
                      '${widget.addBoost} Ad / month',
                      style: GoogleFonts.dmSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.month,
                      ),
                    ),
                  )
                      : WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: Text(
                      '${widget.addBoost} Ad',
                      style: GoogleFonts.dmSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: widget.month,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, size: 16.sp),
                SizedBox(width: 10.w),
                Text(
                  "Radius",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.title,
                    letterSpacing: -0.50,
                  ),
                ),
                SizedBox(width: 10.w),
                Icon(Icons.arrow_forward, size: 16.sp),
                SizedBox(width: 10.w),
                Text(
                  widget.listing_type ?? "",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.title,
                    letterSpacing: -0.50,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.star, size: 16.sp),
                SizedBox(width: 10.w),
                Text(
                  "${widget.duration} Days Live",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: widget.name,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star, size: 16.sp),
                    SizedBox(width: 10.w),
                    Text(
                      "Unlimited Chats",
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: widget.title,
                        letterSpacing: -0.50,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureBody extends StatefulWidget {
  final String txt;
  const FeatureBody({super.key, required this.txt});

  @override
  State<FeatureBody> createState() => _FeatureBodyState();
}

class _FeatureBodyState extends State<FeatureBody> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: Color.fromARGB(255, 97, 91, 104)),
        SizedBox(width: 10.w),
        SizedBox(
          width: 330.w,
          child: Text(
            overflow: TextOverflow.ellipsis,
            widget.txt,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 97, 91, 104),
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentBottomSheet extends StatefulWidget {
  final String id;
  final double? amount;
  final double gstPercentage;
  final bool booleanData; // Changed to non-nullable
  final Map<String, dynamic>? data;

  PaymentBottomSheet({
    super.key,
    this.amount,
    this.gstPercentage = 18,
    required this.id,
    required this.booleanData,
    this.data,
  });

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  bool loder = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response1) async {
    if (response1.paymentId == null || response1.paymentId!.isEmpty) {
      _showSnackBar("Payment ID missing.", isError: true);
      return;
    }

    try {
      final apiService = APIService(await createDio());
      // Verify payment
      final verifyResponse = await apiService.verify(
        paymentId: response1.paymentId!,
        orderId: response1.orderId ?? "",
        signature: response1.signature ?? "",
      );
      var box = Hive.box("data");
      final userId = box.get('id');
      if (userId == null) throw Exception("User not logged in");

      // Activate plan
      await apiService.buyPlanSucees(
        userId: userId.toString(),
        trnxId: response1.paymentId!,
        paymentType: 'success',
        status: 'complete',
        planId: widget.id,
      );

      _showSnackBar("Payment Successful! Plan Activated 🎉", isError: false);

      Fluttertoast.showToast(
        msg: "Paid Plan Active! Now you can post your ad.",
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );

      // Navigation based on booleanData
      if (mounted) {
        Navigator.pop(context); // close bottom sheet
        if (widget.booleanData) {
          Navigator.pop(context); // back to product form
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (_) => const HomePage(page: 0)),
                (route) => false,
          );
        }
      }
    } catch (e) {
      print("Payment error: $e");
      _showSnackBar("Payment failed: $e", isError: true);
    } finally {
      if (mounted) setState(() => loder = false);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("RAZORPAY ERROR CODE: ${response.code}");
    print("RAZORPAY ERROR MESSAGE: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed: ${response.code} - ${response.message}")),
    );
    setState(() => loder = false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet: ${response.walletName}");
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Safe amount handling
    final double baseAmount = widget.amount ?? 0.0;
    final double gstAmount = (baseAmount * widget.gstPercentage) / 100;
    final double totalAmount = baseAmount + gstAmount;
    final int finalTotalAmount = totalAmount.round();

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Payment Summary",
            style: GoogleFonts.dmSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20.h),
          _row(
            "GST (${widget.gstPercentage}%)",
            "₹${gstAmount.toStringAsFixed(2)}",
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gst Legal Name",
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                "Numeric Consultants India llp",
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text(
                "Address",
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  "Near Kapoor Restaurant, 619, Chattarpur Main Road, New Delhi South Delhi, Delhi, 110074",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          _row(
            "Total",
            "₹${finalTotalAmount.toStringAsFixed(2)}",
            isBold: true,
          ),
          SizedBox(height: 30.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 26, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.45.r),
                ),
              ),
              onPressed: () async {
                if (loder) return;

                setState(() => loder = true);

                try {
                  var box = Hive.box("data");
                  final userId = box.get('id');

                  if (userId == null) {
                    Fluttertoast.showToast(msg: "User not logged in");
                    setState(() => loder = false);
                    return;
                  }

                  final state = APIService(await createDio());

                  // Case 1: Free Plan
                  if (finalTotalAmount == 0) {
                    try {
                      await state.buyPlanSucees(
                        userId: userId.toString(),
                        trnxId: "free_plan_${DateTime.now().millisecondsSinceEpoch}",
                        paymentType: 'free',
                        status: 'complete',
                        planId: widget.id,
                      );

                      _showSnackBar("Free Plan Activated Successfully!", isError: false);

                      Fluttertoast.showToast(
                        msg: "Free Plan Active! Now you can post your ad.",
                        backgroundColor: Colors.green,
                        toastLength: Toast.LENGTH_LONG,
                      );

                      // Navigation based on booleanData
                      if (mounted) {
                        Navigator.pop(context); // close bottom sheet
                        if (widget.booleanData) {
                          Navigator.pop(context); // back to product form
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(builder: (_) => const HomePage(page: 0)),
                                (route) => false,
                          );
                        }
                      }
                    } catch (e) {
                      print("Free plan error: $e");
                      _showSnackBar("Free Plan Activation Failed", isError: true);
                    } finally {
                      if (mounted) setState(() => loder = false);
                    }
                    return;
                  }

                  // Case 2: Paid Plan
                  final verifyResponse = await state.buyPlan(
                    currency: 'INR',
                    description: 'Plan Purchase',
                    user_id: userId.toString(),
                    amount: finalTotalAmount,
                    plan_id: widget.id,
                  );

                  if (verifyResponse.success != true || verifyResponse.payment?.orderId == null) {
                    throw Exception("Order creation failed on server");
                  }

                  String rawAmount = verifyResponse.payment!.amount.toString();
                  int amountInRupees = int.tryParse(rawAmount) ?? finalTotalAmount;
                  int amountInPaise = amountInRupees * 100;

                  print("Amount from API: $rawAmount");
                  print("Amount in paise: $amountInPaise");

                  var options = {
                    'key': 'rzp_live_RuYohlH5qc2BfF',
                    'amount': amountInPaise,
                    'name': 'MMP-MY MARKET PLACE',
                    'description': 'Paid Plan Purchase',
                    'order_id': verifyResponse.payment!.orderId,
                    'currency': 'INR',
                    'timeout': 300,
                    'theme': {'color': '#8A2BE2'},
                    'prefill': {},
                  };

                  print("Opening Razorpay with options: $options");
                  _razorpay.open(options);
                } catch (e, stackTrace) {
                  print("Payment Setup Error: $e");
                  print(stackTrace);
                  _showSnackBar("Payment Failed: ${e.toString()}", isError: true);
                } finally {
                  if (mounted) setState(() => loder = false);
                }
              },
              child: loder
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                "Pay Now",
                style: GoogleFonts.dmSans(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}