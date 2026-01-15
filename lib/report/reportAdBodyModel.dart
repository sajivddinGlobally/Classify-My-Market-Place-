// To parse this JSON data, do
//
//     final reportAdBodyModel = reportAdBodyModelFromJson(jsonString);

import 'dart:convert';

ReportAdBodyModel reportAdBodyModelFromJson(String str) => ReportAdBodyModel.fromJson(json.decode(str));

String reportAdBodyModelToJson(ReportAdBodyModel data) => json.encode(data.toJson());

class ReportAdBodyModel {
    String userId;
    String productId;
    String reason;

    ReportAdBodyModel({
        required this.userId,
        required this.productId,
        required this.reason,
    });

    factory ReportAdBodyModel.fromJson(Map<String, dynamic> json) => ReportAdBodyModel(
        userId: json["user_id"],
        productId: json["product_id"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "product_id": productId,
        "reason": reason,
    };
}




