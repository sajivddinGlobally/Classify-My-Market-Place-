import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shopping_app_olx/cagetory/locationCheckrPafge.dart';
import 'package:shopping_app_olx/chat/chating.page.dart';
import 'package:shopping_app_olx/config/pretty.dio.dart';
import 'package:shopping_app_olx/home/home.page.dart';
import 'package:shopping_app_olx/login/login.page.dart';
import 'package:shopping_app_olx/noInterNet.dart' show NoInternetPage;
import 'package:firebase_core/firebase_core.dart';
import 'firbaseOption.dart';
import 'notificationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService().init();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  await Hive.openBox("data");
  runApp(ProviderScope(child: MyApp()));
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}
class _MyAppState extends ConsumerState<MyApp> {
  late final StreamSubscription<InternetStatus> _listener;
  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    listenForegroundNotification();
    logoutNotifier.addListener(() {
      if (logoutNotifier.value) {
        logoutNotifier.value = false; // reset
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (_) => false,
        );
      }
    });
  }
  void listenForegroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔹 Foreground message: ${message.data}");
      // You can show a dialog/snackbar here if needed
    });
  }
  // Handle notification click (terminated + background)
  void setupInteractedMessage() async {
    // App terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // App background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  void _handleMessage(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      final String id = message.data['userid'] ?? '';
      final String title = message.data['fullname'] ?? 'No Title';

      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => ChatingPage(
          conversationId: '',
            userid: id, name: title)),
      );
    }
  }
  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("data");
    var token = box.get("token");
    log("///////////////////////////////////");
    log(token?.toString() ?? "No token found");
    return ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'MMP-MY MARKET PLACE',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),

            home: LocationPermissionPage(), // Check if token exists

            routes: {
              '/home': (context) => const HomePage(),
              '/no-internet': (context) => const NoInternetPage(),
              '/login': (context) => const LoginPage(),
            },
          ),
        );
      },
    );
  }

}

