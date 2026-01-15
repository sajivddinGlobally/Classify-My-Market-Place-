// To parse this JSON data, do
//
//     final likeResModel = likeResModelFromJson(jsonString);

import 'dart:convert';

LikeResModel likeResModelFromJson(String str) => LikeResModel.fromJson(json.decode(str));

String likeResModelToJson(LikeResModel data) => json.encode(data.toJson());

class LikeResModel {
    String message;

    LikeResModel({
        required this.message,
    });

    factory LikeResModel.fromJson(Map<String, dynamic> json) => LikeResModel(
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
    };
}
