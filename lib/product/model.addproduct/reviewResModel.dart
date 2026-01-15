// To parse this JSON data, do
//
//     final reviewResModel = reviewResModelFromJson(jsonString);

import 'dart:convert';

ReviewResModel reviewResModelFromJson(String str) => ReviewResModel.fromJson(json.decode(str));

String reviewResModelToJson(ReviewResModel data) => json.encode(data.toJson());

class ReviewResModel {
    String message;

    ReviewResModel({
        required this.message,
    });

    factory ReviewResModel.fromJson(Map<String, dynamic> json) => ReviewResModel(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
