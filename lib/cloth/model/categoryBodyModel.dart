// // To parse this JSON data, do
// //
// //     final categoryBodyModel = categoryBodyModelFromJson(jsonString);

// import 'dart:convert';

// CategoryBodyModel categoryBodyModelFromJson(String str) => CategoryBodyModel.fromJson(json.decode(str));

// String categoryBodyModelToJson(CategoryBodyModel data) => json.encode(data.toJson());

// class CategoryBodyModel {
//     String category;

//     CategoryBodyModel({
//         required this.category,
//     });

//     factory CategoryBodyModel.fromJson(Map<String, dynamic> json) => CategoryBodyModel(
//         category: json["category"],
//     );

//     Map<String, dynamic> toJson() => {
//         "category": category,
//     };
// }
