// To parse this JSON data, do
//
//     final addproductResModel = addproductResModelFromJson(jsonString);

import 'dart:convert';

AddproductResModel addproductResModelFromJson(String str) => AddproductResModel.fromJson(json.decode(str));

String addproductResModelToJson(AddproductResModel data) => json.encode(data.toJson());

class AddproductResModel {
    String message;
    Product product;

    AddproductResModel({
        required this.message,
        required this.product,
    });

    factory AddproductResModel.fromJson(Map<String, dynamic> json) => AddproductResModel(
        message: json["message"],
        product: Product.fromJson(json["product"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "product": product.toJson(),
    };
}

class Product {
    String category;
    String name;
    String price;
    String contact;
    String pincode;
    String description;
    DateTime updatedAt;
    DateTime createdAt;
    int id;

    Product({
        required this.category,
        required this.name,
        required this.price,
        required this.contact,
        required this.pincode,
        required this.description,
        required this.updatedAt,
        required this.createdAt,
        required this.id,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        category: json["category"],
        name: json["name"],
        price: json["price"],
        contact: json["contact"],
        pincode: json["pincode"],
        description: json["description"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "category": category,
        "name": name,
        "price": price,
        "contact": contact,
        "pincode": pincode,
        "description": description,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
    };
}
