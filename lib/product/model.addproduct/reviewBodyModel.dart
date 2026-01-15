// To parse this JSON data, do
//
//     final reviewBodyModel = reviewBodyModelFromJson(jsonString);

import 'dart:convert';

ReviewBodyModel reviewBodyModelFromJson(String str) => ReviewBodyModel.fromJson(json.decode(str));

String reviewBodyModelToJson(ReviewBodyModel data) => json.encode(data.toJson());

class ReviewBodyModel {
    String productId;
    String buyerId;
    String sellerId;
    int rating;
    String comment;

    ReviewBodyModel({
        required this.productId,
        required this.buyerId,
        required this.sellerId,
        required this.rating,
        required this.comment,
    });

    factory ReviewBodyModel.fromJson(Map<String, dynamic> json) => ReviewBodyModel(
        productId: json["product_id"],
        buyerId: json["buyer_id"],
        sellerId: json["seller_id"],
        rating: json["rating"],
        comment: json["comment"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "buyer_id": buyerId,
        "seller_id": sellerId,
        "rating": rating,
        "comment": comment,
    };
}
