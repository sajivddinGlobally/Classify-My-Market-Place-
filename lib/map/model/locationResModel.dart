// To parse this JSON data, do
//
//     final locationResModel = locationResModelFromJson(jsonString);

import 'dart:convert';

LocationResModel locationResModelFromJson(String str) => LocationResModel.fromJson(json.decode(str));

String locationResModelToJson(LocationResModel data) => json.encode(data.toJson());

class LocationResModel {
    String message;
    Location location;

    LocationResModel({
        required this.message,
        required this.location,
    });

    factory LocationResModel.fromJson(Map<String, dynamic> json) => LocationResModel(
        message: json["message"],
        location: Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "location": location.toJson(),
    };
}

class Location {
    int id;
    int userId;
    double latitude;
    double longitude;
    DateTime createdAt;
    DateTime updatedAt;

    Location({
        required this.id,
        required this.userId,
        required this.latitude,
        required this.longitude,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        userId: json["user_id"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "latitude": latitude,
        "longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
