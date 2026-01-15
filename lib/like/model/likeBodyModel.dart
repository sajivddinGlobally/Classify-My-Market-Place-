// To parse this JSON data, do
//
//     final likeBodyModel = likeBodyModelFromJson(jsonString);

import 'dart:convert';

LikeBodyModel likeBodyModelFromJson(String str) => LikeBodyModel.fromJson(json.decode(str));

String likeBodyModelToJson(LikeBodyModel data) => json.encode(data.toJson());

class LikeBodyModel {
    String productId;
    String type;
    String userId;

    LikeBodyModel({
        required this.productId,
        required this.type,
        required this.userId,
    });

    factory LikeBodyModel.fromJson(Map<String, dynamic> json) => LikeBodyModel(
        productId: json["product_id"],
        type: json["type"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "type": type,
        "user_id": userId,
    };
}
