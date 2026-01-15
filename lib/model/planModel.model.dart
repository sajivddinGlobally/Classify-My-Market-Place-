// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
    bool status;
    String message;
    List<Datum> data;

    PlanModel({
        required this.status,
        required this.message,
        required this.data,
    });

    factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    int id;
    String? price;
    int duration;
    String planType;
    String description;
    int boostCount;
    DateTime createdAt;
    DateTime updatedAt;
    String? listing_type;

    Datum({
        required this.id,
         this.price,
        required this.duration,
        required this.planType,
        required this.description,
        required this.boostCount,
        required this.createdAt,
        required this.updatedAt,
        required this.listing_type,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        price: json["price"],
        duration: json["duration"],
        planType: json["plan_type"],
        description: json["description"],
        boostCount: json["boost_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        listing_type:  json["listing_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "duration": duration,
        "plan_type": planType,
        "description": description,
        "boost_count": boostCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "listing_type": listing_type,
    };
}
