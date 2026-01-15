// To parse this JSON data, do
//
//     final showlikeBodyModel = showlikeBodyModelFromJson(jsonString);

import 'dart:convert';

ShowlikeBodyModel showlikeBodyModelFromJson(String str) => ShowlikeBodyModel.fromJson(json.decode(str));

String showlikeBodyModelToJson(ShowlikeBodyModel data) => json.encode(data.toJson());

class ShowlikeBodyModel {
    String productId;

    ShowlikeBodyModel({
        required this.productId,
    });

    factory ShowlikeBodyModel.fromJson(Map<String, dynamic> json) => ShowlikeBodyModel(
        productId: json["product_id"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
    };
}
