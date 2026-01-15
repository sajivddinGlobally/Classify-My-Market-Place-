// To parse this JSON data, do
//
//     final locationBodyModel = locationBodyModelFromJson(jsonString);

import 'dart:convert';

LocationBodyModel locationBodyModelFromJson(String str) => LocationBodyModel.fromJson(json.decode(str));

String locationBodyModelToJson(LocationBodyModel data) => json.encode(data.toJson());

class LocationBodyModel {
    String userId;
    double latitude;
    double longitude;

    LocationBodyModel({
        required this.userId,
        required this.latitude,
        required this.longitude,
    });

    factory LocationBodyModel.fromJson(Map<String, dynamic> json) => LocationBodyModel(
        userId: json["user_id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "latitude": latitude,
        "longitude": longitude,
    };
}
