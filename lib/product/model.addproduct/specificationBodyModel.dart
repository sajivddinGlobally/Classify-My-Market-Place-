// To parse this JSON data, do
//
//     final productSpecificationBodyModel = productSpecificationBodyModelFromJson(jsonString);

import 'dart:convert';

ProductSpecificationBodyModel productSpecificationBodyModelFromJson(String str) => ProductSpecificationBodyModel.fromJson(json.decode(str));

String productSpecificationBodyModelToJson(ProductSpecificationBodyModel data) => json.encode(data.toJson());

class ProductSpecificationBodyModel {
    String productId;
    String material;
    String sizeOrShoeNumber;
    String ageOrHowOld;
    String model;
    String idealFor;
    String style;

    ProductSpecificationBodyModel({
        required this.productId,
        required this.material,
        required this.sizeOrShoeNumber,
        required this.ageOrHowOld,
        required this.model,
        required this.idealFor,
        required this.style,
    });

    factory ProductSpecificationBodyModel.fromJson(Map<String, dynamic> json) => ProductSpecificationBodyModel(
        productId: json["product_id"],
        material: json["material"],
        sizeOrShoeNumber: json["size_or_shoe_number"],
        ageOrHowOld: json["age_or_how_old"],
        model: json["model"],
        idealFor: json["ideal_for"],
        style: json["style"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "material": material,
        "size_or_shoe_number": sizeOrShoeNumber,
        "age_or_how_old": ageOrHowOld,
        "model": model,
        "ideal_for": idealFor,
        "style": style,
    };
}
