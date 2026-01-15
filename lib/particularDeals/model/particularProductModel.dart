/*
import 'dart:convert';

ParticularProductModel particularProductModelFromJson(String str) =>
    ParticularProductModel.fromJson(json.decode(str));

String particularProductModelToJson(ParticularProductModel data) =>
    json.encode(data.toJson());

class ParticularProductModel {
  String status;
  String message;
  ParticularProductData data;

  ParticularProductModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ParticularProductModel.fromJson(Map<String, dynamic> json) =>
      ParticularProductModel(
        status: json["status"],
        message: json["message"],
        data: ParticularProductData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}


class ParticularProductData {
  int id;
  int userId;
  String price;
  String latitude;
  String longitude;
  String category;
  List<String> image; // Changed to List<String>
  String jsonDataRaw;
  Map<String, dynamic> jsonData;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> specification;
  List<String> images; // Changed to List<String>

  ParticularProductData({
    required this.id,
    required this.userId,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.image,
    required this.jsonDataRaw,
    required this.jsonData,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.specification,
    required this.images,
  });

  factory ParticularProductData.fromJson(Map<String, dynamic> json) {
    String raw = json["json_data"] ?? "";
    Map<String, dynamic> parsed = {};
    try {
      parsed = jsonDecode(raw);
    } catch (e) {
      parsed = {};
    }

    return ParticularProductData(
      id: json["id"],
      userId: json["user_id"],
      price: json["price"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      category: json["category"],
      image: List<String>.from(json["image"] ?? []),
      jsonDataRaw: raw,
      jsonData: parsed,
      status: json["status"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      specification: List<dynamic>.from(json["specification"] ?? []),
      images: List<String>.from(json["images"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": category,
    "image": image,
    "json_data": jsonDataRaw,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "specification": specification,
    "images": images,
  };
}
*//*
*/
/*


import 'dart:convert';

ParticularProductModel particularProductModelFromJson(String str) =>
    ParticularProductModel.fromJson(json.decode(str));

String particularProductModelToJson(ParticularProductModel data) =>
    json.encode(data.toJson());

class ParticularProductModel {
  String status;
  String message;
  ParticularProductData data;
int likes;
int dislikes;
bool user_like;


  ParticularProductModel({
    required this.status,
    required this.message,
    required this.data,
    required this.likes,
    required this.dislikes,
    required this.user_like,
  });

  factory ParticularProductModel.fromJson(Map<String, dynamic> json) =>
      ParticularProductModel(
        status: json["status"] ?? "",
        message: json["message"] ?? "",
        data: ParticularProductData.fromJson(json["data"] ?? {}),
        likes: json["likes"] ?? "",
        dislikes: json["dislikes"] ?? "",
        user_like: json["user_like"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
    "likes": likes,
    "dislikes": dislikes,
    "user_like": user_like,
  };
}

class ParticularProductData {
  int id;
  int userId;
  String? price; // Made nullable
  String? latitude; // Made nullable
  String? longitude; // Made nullable
  String? category; // Made nullable
  List<String> image;
  String jsonDataRaw;
  Map<String, dynamic> jsonData;
  int status;
  String? rejectionReason; // Made nullable
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> specification;
  List<String> images;

  ParticularProductData({
    required this.id,
    required this.userId,
    this.price,
    this.latitude,
    this.longitude,
    this.category,
    required this.image,
    required this.jsonDataRaw,
    required this.jsonData,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    required this.specification,
    required this.images,
  });

  factory ParticularProductData.fromJson(Map<String, dynamic> json) {
    String raw = json["json_data"] ?? "";
    Map<String, dynamic> parsed = {};
    try {
      parsed = raw.isNotEmpty ? jsonDecode(raw) : {};
    } catch (e) {
      print('Error parsing json_data: $e');
      parsed = {};
    }

    return ParticularProductData(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      price: json["price"]?.toString(), // Convert to string, allow null
      latitude: json["latitude"]?.toString(), // Convert to string, allow null
      longitude: json["longitude"]?.toString(), // Convert to string, allow null
      category: json["category"],
      image: List<String>.from(json["image"] ?? []),
      jsonDataRaw: raw,
      jsonData: parsed,
      status: json["status"] ?? 0,
      rejectionReason: json["rejection_reason"],
      createdAt: DateTime.tryParse(json["created_at"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? "") ?? DateTime.now(),
      specification: List<dynamic>.from(json["specification"] ?? []),
      images: List<String>.from(json["images"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": category,
    "image": image,
    "json_data": jsonDataRaw,
    "status": status,
    "rejection_reason": rejectionReason,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "specification": specification,
    "images": images,
  };
}*//*





// To parse this JSON data, do
//
//     final particularProductModel = particularProductModelFromJson(jsonString);

import 'dart:convert';

ParticularProductModel particularProductModelFromJson(String str) => ParticularProductModel.fromJson(json.decode(str));

String particularProductModelToJson(ParticularProductModel data) => json.encode(data.toJson());

class ParticularProductModel {
  String? status;
  String? message;
  Data? data;
  int? likes;
  int? dislikes;
  bool? userLike;

  ParticularProductModel({
    this.status,
    this.message,
    this.data,
    this.likes,
    this.dislikes,
    this.userLike,
  });

  factory ParticularProductModel.fromJson(Map<String, dynamic> json) => ParticularProductModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    likes: json["likes"],
    dislikes: json["dislikes"],
    userLike: json["user_like"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "likes": likes,
    "dislikes": dislikes,
    "user_like": userLike,
  };
}

class Data {
  Product? product;
  User? user;

  Data({
    this.product,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    user: json["User"] == null ? null : User.fromJson(json["User"]),
  );

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
    "User": user?.toJson(),
  };
}

class Product {
  int? id;
  int? userId;
  String? price;
  String? latitude;
  String? longitude;
  String? category;
  List<String>? image;
  String? jsonData;
  int? status;
  dynamic rejectionReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? viewCount;

  Product({
    this.id,
    this.userId,
    this.price,
    this.latitude,
    this.longitude,
    this.category,
    this.image,
    this.jsonData,
    this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.viewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    userId: json["user_id"],
    price: json["price"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    category: json["category"],
    image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
    jsonData: json["json_data"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    viewCount: json["view_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": category,
    "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
    "json_data": jsonData,
    "status": status,
    "rejection_reason": rejectionReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "view_count": viewCount,
  };
}

class User {
  int? id;
  String? fullName;
  String? phoneNumber;
  String? address;
  String? city;
  String? pincode;
  String? image;
  String? profileApproved;
  DateTime? lastActiveAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.city,
    this.pincode,
    this.image,
    this.profileApproved,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    image: json["image"],
    profileApproved: json["profile_approved"],
    lastActiveAt: json["last_active_at"] == null ? null : DateTime.parse(json["last_active_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "address": address,
    "city": city,
    "pincode": pincode,
    "image": image,
    "profile_approved": profileApproved,
    "last_active_at": lastActiveAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
*/


// To parse this JSON data, do
//
//     final particularProductModel = particularProductModelFromJson(jsonString);

import 'dart:convert';

ParticularProductModel particularProductModelFromJson(String str) => ParticularProductModel.fromJson(json.decode(str));

String particularProductModelToJson(ParticularProductModel data) => json.encode(data.toJson());

class ParticularProductModel {
  String? status;
  String? message;
  Data? data;
  int? likes;
  int? dislikes;
  bool? userLike;

  ParticularProductModel({
    this.status,
    this.message,
    this.data,
    this.likes,
    this.dislikes,
    this.userLike,
  });

  factory ParticularProductModel.fromJson(Map<String, dynamic> json) => ParticularProductModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    likes: json["likes"],
    dislikes: json["dislikes"],
    userLike: json["user_like"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
    "likes": likes,
    "dislikes": dislikes,
    "user_like": userLike,
  };
}

class Data {
  Product? product;
  User? user;

  Data({
    this.product,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    product: json["product"] == null ? null : Product.fromJson(json["product"]),
    user: json["User"] == null ? null : User.fromJson(json["User"]),
  );

  Map<String, dynamic> toJson() => {
    "product": product?.toJson(),
    "User": user?.toJson(),
  };
}

class Product {
  int? id;
  int? userId;
  String? price;
  String? latitude;
  String? longitude;
  String? category;
  List<String>? image;
  String? jsonData;
  int? status;
  dynamic rejectionReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? viewCount;

  Product({
    this.id,
    this.userId,
    this.price,
    this.latitude,
    this.longitude,
    this.category,
    this.image,
    this.jsonData,
    this.status,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
    this.viewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    userId: json["user_id"],
    price: json["price"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    category: json["category"],
    image: json["image"] == null ? [] : List<String>.from(json["image"]!.map((x) => x)),
    jsonData: json["json_data"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    viewCount: json["view_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": category,
    "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
    "json_data": jsonData,
    "status": status,
    "rejection_reason": rejectionReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "view_count": viewCount,
  };
}

class User {
  int? id;
  String? fullName;
  String? phoneNumber;
  String? address;
  String? city;
  String? pincode;
  String? image;
  String? profileApproved;
  DateTime? lastActiveAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.city,
    this.pincode,
    this.image,
    this.profileApproved,
    this.lastActiveAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    image: json["image"],
    profileApproved: json["profile_approved"],
    lastActiveAt: json["last_active_at"] == null ? null : DateTime.parse(json["last_active_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "address": address,
    "city": city,
    "pincode": pincode,
    "image": image,
    "profile_approved": profileApproved,
    "last_active_at": lastActiveAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
