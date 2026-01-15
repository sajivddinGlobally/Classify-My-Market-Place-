// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String status;
  String message;
  Data data;

  ProfileModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  int id;
  String fullName;
  String phoneNumber;
  String? address;
  String? city;
  String? pincode;
  String profile_approved;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.address,
    this.city,
    this.pincode,
    required this.profile_approved,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    profile_approved: json["profile_approved"],
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
    "profile_approved": profile_approved,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
