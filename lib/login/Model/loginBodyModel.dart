// To parse this JSON data, do
//
//     final loginBodyModel = loginBodyModelFromJson(jsonString);

import 'dart:convert';

LoginBodyModel loginBodyModelFromJson(String str) => LoginBodyModel.fromJson(json.decode(str));

String loginBodyModelToJson(LoginBodyModel data) => json.encode(data.toJson());

class LoginBodyModel {
    String phoneNumber;

    LoginBodyModel({
        required this.phoneNumber,
    });

    factory LoginBodyModel.fromJson(Map<String, dynamic> json) => LoginBodyModel(
        phoneNumber: json["phone_number"],
    );

    Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
    };
}
