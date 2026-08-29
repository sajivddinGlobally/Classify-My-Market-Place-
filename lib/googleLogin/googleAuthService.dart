import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize(
      serverClientId:
          "420482925865-d8lguadsoeasrue4uge85vnu87ookqtt.apps.googleusercontent.com",
    );
  }

  Future<String?> signInWithGoogle() async {
    try {
      await initialize();
      final GoogleSignInAccount account = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = account.authentication;
      if (auth.idToken == null) {
        log("Google ID Token is null");
        return null;
      }
      log("Google ID Token received");
      return auth.idToken;
    } on GoogleSignInException catch (e) {
      log("Google Sign-In Error: ${e.code} - ${e.description}");
      return null;
    } catch (e, stackTrace) {
      log("Unexpected Error: $e");
      log("$stackTrace");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
