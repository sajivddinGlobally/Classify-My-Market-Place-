// To parse this JSON data, do
//
//     final otpBodyModel = otpBodyModelFromJson(jsonString);

import 'dart:convert';

OtpBodyModel otpBodyModelFromJson(String str) => OtpBodyModel.fromJson(json.decode(str));

String otpBodyModelToJson(OtpBodyModel data) => json.encode(data.toJson());

class OtpBodyModel {
    // String idToken;
    String phone_number;
    String otp;
    String fcm_token;

    OtpBodyModel({
        // required this.idToken,
        required this.phone_number,
        required this.otp,
        required this.fcm_token,
    });

    factory OtpBodyModel.fromJson(Map<String, dynamic> json) => OtpBodyModel(
        // idToken: json["idToken"],
        phone_number: json["phone_number"],
        otp: json["otp"],
        fcm_token: json["fcm_token"],
    );

    Map<String, dynamic> toJson() => {
        // "idToken": idToken,
        "phone_number": phone_number,
        "otp": otp,
        "fcm_token": fcm_token,
    };
}
