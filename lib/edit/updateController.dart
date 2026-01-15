import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class UpdateController {
  static Future<Map<String, dynamic>> UpdateProfile({
    required BuildContext context,
    required String user_id,
    required String full_name,
    required File images,
  }) async {
    final Uri url = Uri.parse(
      "https://classify.mymarketplace.co.in/api/user/profile-update",
    );
    var box = Hive.box("data");
    var token = box.get("token");

    var request = http.MultipartRequest("POST", url);
    request.headers.addAll({
      //"Content-Type": "application/json",
      "Accept": "application/json", // Ensure content type is correct
      // You can add other custom headers here
      "Authorization": "Bearer $token", // 🔥 Add this
    });
    request.files.add(await http.MultipartFile.fromPath('image', images.path));
    request.fields.addAll({"user_id": user_id, "full_name": full_name});

    try {
      final http.StreamedResponse response = await request.send();
      final ResponseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = jsonDecode(ResponseBody);

      log(ResponseBody);
      log(response.statusCode.toString());

      if (response.statusCode == 201 || response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Profile Update Successful");
        Navigator.pop(context, true);
        return data;
      } else {
        throw Exception("Failed to Upload:${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}
