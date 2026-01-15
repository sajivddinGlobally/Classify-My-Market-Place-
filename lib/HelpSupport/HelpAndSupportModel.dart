// To parse this JSON data, do
//
//     final helpAndSupportModelResponse = helpAndSupportModelResponseFromJson(jsonString);

import 'dart:convert';

HelpAndSupportModelResponse helpAndSupportModelResponseFromJson(String str) => HelpAndSupportModelResponse.fromJson(json.decode(str));

String helpAndSupportModelResponseToJson(HelpAndSupportModelResponse data) => json.encode(data.toJson());

class HelpAndSupportModelResponse {
  bool? status;
  String? message;
  Data? data;

  HelpAndSupportModelResponse({
    this.status,
    this.message,
    this.data,
  });

  factory HelpAndSupportModelResponse.fromJson(Map<String, dynamic> json) => HelpAndSupportModelResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? userId;
  String? description;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.userId,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    description: json["description"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "description": description,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
