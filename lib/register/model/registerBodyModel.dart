// To parse this JSON data, do
//
//     final registerBodyModel = registerBodyModelFromJson(jsonString);

import 'dart:convert';

RegisterBodyModel registerBodyModelFromJson(String str) => RegisterBodyModel.fromJson(json.decode(str));

String registerBodyModelToJson(RegisterBodyModel data) => json.encode(data.toJson());

class RegisterBodyModel {
    String fullName;
    String phoneNumber;
    String address;
    String city;
    String pincode;

    RegisterBodyModel({
        required this.fullName,
        required this.phoneNumber,
        required this.address,
        required this.city,
        required this.pincode,
    });

    factory RegisterBodyModel.fromJson(Map<String, dynamic> json) => RegisterBodyModel(
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        city: json["city"],
        pincode: json["pincode"],
    );

    Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "phone_number": phoneNumber,
        "address": address,
        "city": city,
        "pincode": pincode,
    };
}
