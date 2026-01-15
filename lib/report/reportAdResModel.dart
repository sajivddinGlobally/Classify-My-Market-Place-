// To parse this JSON data, do
//
//     final reportAdResModel = reportAdResModelFromJson(jsonString);

import 'dart:convert';

ReportAdResModel reportAdResModelFromJson(String str) => ReportAdResModel.fromJson(json.decode(str));

String reportAdResModelToJson(ReportAdResModel data) => json.encode(data.toJson());

class ReportAdResModel {
    bool success;
    String message;
    Data data;

    ReportAdResModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory ReportAdResModel.fromJson(Map<String, dynamic> json) => ReportAdResModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String userId;
    String productId;
    String reason;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.userId,
        required this.productId,
        required this.reason,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        productId: json["product_id"],
        reason: json["reason"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "product_id": productId,
        "reason": reason,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
