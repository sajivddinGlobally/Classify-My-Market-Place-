// To parse this JSON data, do
//
//     final googleLoginResModel = googleLoginResModelFromJson(jsonString);

import 'dart:convert';

GoogleLoginResModel googleLoginResModelFromJson(String str) => GoogleLoginResModel.fromJson(json.decode(str));

String googleLoginResModelToJson(GoogleLoginResModel data) => json.encode(data.toJson());

class GoogleLoginResModel {
    bool? status;
    String? message;
    String? token;
    String? tokenType;
    User? user;

    GoogleLoginResModel({
        this.status,
        this.message,
        this.token,
        this.tokenType,
        this.user,
    });

    factory GoogleLoginResModel.fromJson(Map<String, dynamic> json) => GoogleLoginResModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        tokenType: json["token_type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "token": token,
        "token_type": tokenType,
        "user": user?.toJson(),
    };
}

class User {
    int? id;
    String? fullName;
    String? email;
    String? googleId;
    dynamic facebookId;
    dynamic phoneNumber;
    dynamic otp;
    dynamic otpExpiresAt;
    int? isOtpVerified;
    dynamic firebaseUid;
    dynamic address;
    dynamic city;
    dynamic pincode;
    String? image;
    String? profileApproved;
    DateTime? lastActiveAt;
    dynamic fcmToken;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
        this.id,
        this.fullName,
        this.email,
        this.googleId,
        this.facebookId,
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
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["full_name"],
        email: json["email"],
        googleId: json["google_id"],
        facebookId: json["facebook_id"],
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
        lastActiveAt: json["last_active_at"] == null ? null : DateTime.parse(json["last_active_at"]),
        fcmToken: json["fcm_Token"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "google_id": googleId,
        "facebook_id": facebookId,
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
        "last_active_at": lastActiveAt?.toIso8601String(),
        "fcm_Token": fcmToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
