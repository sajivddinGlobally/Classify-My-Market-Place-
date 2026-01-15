// To parse this JSON data, do
//
//     final HelpSupportBodyModel = HelpSupportBodyModelFromJson(jsonString);

import 'dart:convert';

HelpSupportBodyModel HelpSupportBodyModelFromJson(String str) => HelpSupportBodyModel.fromJson(json.decode(str));

String HelpSupportBodyModelToJson(HelpSupportBodyModel data) => json.encode(data.toJson());

class HelpSupportBodyModel {
  String userId;
  String description;


  HelpSupportBodyModel({
    required this.userId,
    required this.description,

  });

  factory HelpSupportBodyModel.fromJson(Map<String, dynamic> json) => HelpSupportBodyModel(
    userId: json["user_id"],
    description: json["description"],

  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "description": description,

  };
}
