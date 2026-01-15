/*
// To parse this JSON data, do
//
//     final loginResModel = loginResModelFromJson(jsonString);

import 'dart:convert';

LoginResModel loginResModelFromJson(String str) => LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
    String message;
    int otpForTesting;

    LoginResModel({
        required this.message,
        required this.otpForTesting,
    });

    factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        message: json["message"],
        otpForTesting: json["otp_for_testing"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "otp_for_testing": otpForTesting,
    };
}





*/


// To parse this JSON data, do
//
//     final loginResModel = loginResModelFromJson(jsonString);

import 'dart:convert';

LoginResModel loginResModelFromJson(String str) => LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
    String? message;
    bool? status;
    String? phone;
    Response? response;

    LoginResModel({
        this.message,
        this.status,
        this.phone,
        this.response,
    });

    factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        message: json["message"],
        status: json["status"],
        phone: json["phone"],
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "phone": phone,
        "response": response?.toJson(),
    };
}

class Response {
    String? status;
    String? details;

    Response({
        this.status,
        this.details,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["Status"],
        details: json["Details"],
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
        "Details": details,
    };
}
