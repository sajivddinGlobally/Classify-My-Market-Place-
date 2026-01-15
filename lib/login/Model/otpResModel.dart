/*
// To parse this JSON data, do
//
//     final otpResModel = otpResModelFromJson(jsonString);

import 'dart:convert';

OtpResModel otpResModelFromJson(String str) => OtpResModel.fromJson(json.decode(str));

String otpResModelToJson(OtpResModel data) => json.encode(data.toJson());

class OtpResModel {
    String message;
    String token;
    User user;

    OtpResModel({
        required this.message,
        required this.token,
        required this.user,
    });

    factory OtpResModel.fromJson(Map<String, dynamic> json) => OtpResModel(
        message: json["message"],
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    int id;
    String fullName;
    String phoneNumber;
    String address;
    String city;
    String pincode;
    dynamic image;
    DateTime createdAt;
    DateTime updatedAt;

    User({
        required this.id,
        required this.fullName,
        required this.phoneNumber,
        required this.address,
        required this.city,
        required this.pincode,
        required this.image,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        city: json["city"],
        pincode: json["pincode"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "address": address,
        "city": city,
        "pincode": pincode,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
*/


// To parse this JSON data, do
//
//     final otpResModel = otpResModelFromJson(jsonString);

import 'dart:convert';

OtpResModel otpResModelFromJson(String str) => OtpResModel.fromJson(json.decode(str));

String otpResModelToJson(OtpResModel data) => json.encode(data.toJson());

class OtpResModel {
    String? message;
    String? token;
    User? user;

    OtpResModel({
        this.message,
        this.token,
        this.user,
    });

    factory OtpResModel.fromJson(Map<String, dynamic> json) => OtpResModel(
        message: json["message"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? fullName;
    String? phoneNumber;
    dynamic otp;
    dynamic otpExpiresAt;
    bool? isOtpVerified;
    dynamic firebaseUid;
    dynamic address;
    dynamic city;
    dynamic pincode;
    dynamic image;
    String? profileApproved;
    dynamic lastActiveAt;
    dynamic fcmToken;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? userFcmToken;

    User({
        this.id,
        this.fullName,
        this.phoneNumber,
        this.otp,
        this.otpExpiresAt,
        this.isOtpVerified,
        this.firebaseUid,
        this.address,
        this.city,
        this.pincode,
        this.image,
        this.profileApproved,
        this.lastActiveAt,
        this.fcmToken,
        this.createdAt,
        this.updatedAt,
        this.userFcmToken,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        otp: json["otp"],
        otpExpiresAt: json["otp_expires_at"],
        isOtpVerified: json["is_otp_verified"],
        firebaseUid: json["firebase_uid"],
        address: json["address"],
        city: json["city"],
        pincode: json["pincode"],
        image: json["image"],
        profileApproved: json["profile_approved"],
        lastActiveAt: json["last_active_at"],
        fcmToken: json["fcm_Token"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userFcmToken: json["fcm_token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "otp": otp,
        "otp_expires_at": otpExpiresAt,
        "is_otp_verified": isOtpVerified,
        "firebase_uid": firebaseUid,
        "address": address,
        "city": city,
        "pincode": pincode,
        "image": image,
        "profile_approved": profileApproved,
        "last_active_at": lastActiveAt,
        "fcm_Token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "fcm_token": userFcmToken,
    };
}
