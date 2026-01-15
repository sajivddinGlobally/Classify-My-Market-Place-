// To parse this JSON data, do
//
//     final productSpecificationResModel = productSpecificationResModelFromJson(jsonString);

import 'dart:convert';

ProductSpecificationResModel productSpecificationResModelFromJson(String str) => ProductSpecificationResModel.fromJson(json.decode(str));

String productSpecificationResModelToJson(ProductSpecificationResModel data) => json.encode(data.toJson());

class ProductSpecificationResModel {
    String message;
    Data data;

    ProductSpecificationResModel({
        required this.message,
        required this.data,
    });

    factory ProductSpecificationResModel.fromJson(Map<String, dynamic> json) => ProductSpecificationResModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String productId;
    String material;
    String sizeOrShoeNumber;
    String ageOrHowOld;
    String model;
    String idealFor;
    String style;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Data({
        required this.productId,
        required this.material,
        required this.sizeOrShoeNumber,
        required this.ageOrHowOld,
        required this.model,
        required this.idealFor,
        required this.style,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        productId: json["product_id"],
        material: json["material"],
        sizeOrShoeNumber: json["size_or_shoe_number"],
        ageOrHowOld: json["age_or_how_old"],
        model: json["model"],
        idealFor: json["ideal_for"],
        style: json["style"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "material": material,
        "size_or_shoe_number": sizeOrShoeNumber,
        "age_or_how_old": ageOrHowOld,
        "model": model,
        "ideal_for": idealFor,
        "style": style,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
