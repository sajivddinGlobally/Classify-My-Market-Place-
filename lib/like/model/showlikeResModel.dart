// To parse this JSON data, do
//
//     final showlikeResModel = showlikeResModelFromJson(jsonString);

import 'dart:convert';

ShowlikeResModel showlikeResModelFromJson(String str) => ShowlikeResModel.fromJson(json.decode(str));

String showlikeResModelToJson(ShowlikeResModel data) => json.encode(data.toJson());

class ShowlikeResModel {
    int likes;
    int dislikes;

    ShowlikeResModel({
        required this.likes,
        required this.dislikes,
    });

    factory ShowlikeResModel.fromJson(Map<String, dynamic> json) => ShowlikeResModel(
        likes: json["likes"],
        dislikes: json["dislikes"],
    );

    Map<String, dynamic> toJson() => {
        "likes": likes,
        "dislikes": dislikes,
    };
}
