// To parse this JSON data, do
//
//     final registerResModel = registerResModelFromJson(jsonString);

import 'dart:convert';

RegisterResModel registerResModelFromJson(String str) => RegisterResModel.fromJson(json.decode(str));

String registerResModelToJson(RegisterResModel data) => json.encode(data.toJson());

class RegisterResModel {
    bool status;
    String message;
    Data data;

    RegisterResModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory RegisterResModel.fromJson(Map<String, dynamic> json) => RegisterResModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String fullName;
    String phoneNumber;
    String address;
    String city;
    String pincode;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.fullName,
        required this.phoneNumber,
        required this.address,
        required this.city,
        required this.pincode,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        address: json["address"],
        city: json["city"],
        pincode: json["pincode"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "phone_number": phoneNumber,
        "address": address,
        "city": city,
        "pincode": pincode,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
