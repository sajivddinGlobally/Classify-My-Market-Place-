import 'dart:developer';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  Future<String?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final token = result.accessToken?.tokenString;

          log("Facebook Access Token : $token");

          return token;

        case LoginStatus.cancelled:
          log("Facebook Login Cancelled");
          return null;

        case LoginStatus.failed:
          log("Facebook Login Failed : ${result.message}");
          return null;

        case LoginStatus.operationInProgress:
          log("Facebook Login In Progress");
          return null;
      }
    } catch (e, s) {
      log("Facebook Login Exception : $e");
      log("$s");
      return null;
    }
  }

  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }
}
