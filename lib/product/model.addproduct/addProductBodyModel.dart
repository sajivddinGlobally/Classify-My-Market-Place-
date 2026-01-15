// To parse this JSON data, do
//
//     final addproductBodyModel = addproductBodyModelFromJson(jsonString);

import 'dart:convert';

AddproductBodyModel addproductBodyModelFromJson(String str) => AddproductBodyModel.fromJson(json.decode(str));

String addproductBodyModelToJson(AddproductBodyModel data) => json.encode(data.toJson());

class AddproductBodyModel {
    String category;
    String name;
    String price;
    String contact;
    String pincode;
    String description;

    AddproductBodyModel({
        required this.category,
        required this.name,
        required this.price,
        required this.contact,
        required this.pincode,
        required this.description,
    });

    factory AddproductBodyModel.fromJson(Map<String, dynamic> json) => AddproductBodyModel(
        category: json["category"],
        name: json["name"],
        price: json["price"],
        contact: json["contact"],
        pincode: json["pincode"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "category": category,
        "name": name,
        "price": price,
        "contact": contact,
        "pincode": pincode,
        "description": description,
    };
}
