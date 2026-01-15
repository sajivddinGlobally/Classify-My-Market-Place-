// To parse this JSON data, do
//
//     final categoryResModel = categoryResModelFromJson(jsonString);

import 'dart:convert';


CategoryResModel categoryResModelFromJson(String str) => CategoryResModel.fromJson(json.decode(str));

String categoryResModelToJson(CategoryResModel data) => json.encode(data.toJson());

class CategoryResModel {
    bool success;
    String message;
    List<Datum> data;

    CategoryResModel({
        required this.success,
        required this.message,
        required this.data,
    });

    factory CategoryResModel.fromJson(Map<String, dynamic> json) => CategoryResModel(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}


class Datum {
    int id;
    int userId;
    String category;
    String image;
    String jsonDataRaw;
    int status;
    DateTime createdAt;
    DateTime updatedAt;
    Map<String, dynamic> jsonData;
    String? price; // Make price nullable
    String? listing_type; // Make price nullable
    int? likes; // Make price nullable
    int? dislikes; // Make price nullable
    bool? userlike; // Make price nullable


    Datum({
        required this.id,
        required this.userId,
        required this.category,
        required this.image,
        required this.jsonDataRaw,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.jsonData,
        this.price, // Nullable, so no `required`
        this.listing_type, // Nullable, so no `required`
this.likes,
        this.dislikes,
        this.userlike,

    });

    factory Datum.fromJson(Map<String, dynamic> json) {
        final raw = json["json_data"] ?? "";
        Map<String, dynamic> parsed = {};

        try {
            final decoded = jsonDecode(raw);
            if (decoded is Map<String, dynamic>) {
                parsed = decoded;
            }
        } catch (e) {
            // log("Invalid json_data: $e");
        }

        return Datum(
            id: json["id"],
            userId: json["user_id"],
            category: json["category"] ?? "", // Provide default if null
            image: json["image"] ?? "", // Provide default if null
            jsonData: parsed,
            jsonDataRaw: raw,
            status: json["status"],
            createdAt: DateTime.parse(json["created_at"]),
            updatedAt: DateTime.parse(json["updated_at"]),
            price: json["price"], // Nullable, so null is fine
            listing_type: json["listing_type"], // Nullable, so null is fine
            likes: json["likes"], // Nullable, so null is fine
            dislikes: json["dislikes"], // Nullable, so null is fine
            userlike: json["userlike"], // Nullable, so null is fine
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "category": category,
        "image": image,
        "json_data": jsonData,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "price": price, // Nullable, so null is fine
        "listing_type": listing_type, // Nullable, so null is fine
        "likes": likes, // Nullable, so null is fine
        "dislikes": dislikes, // Nullable, so null is fine
        "userlike": userlike, // Nullable, so null is fine
    };
}