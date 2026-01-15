/*


// To parse this JSON data, do
//
//     final getListingModel = getListingModelFromJson(jsonString);

import 'dart:convert';

GetListingModel getListingModelFromJson(String str) => GetListingModel.fromJson(json.decode(str));

String getListingModelToJson(GetListingModel data) => json.encode(data.toJson());

class GetListingModel {
    bool success;
    Data data;

    GetListingModel({
        required this.success,
        required this.data,
    });

    factory GetListingModel.fromJson(Map<String, dynamic> json) => GetListingModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    List<dynamic> buyList;
    List<SellList> sellList;

    Data({
        required this.buyList,
        required this.sellList,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        buyList: List<dynamic>.from(json["buy_list"].map((x) => x)),
        sellList: List<SellList>.from(json["sell_list"].map((x) => SellList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "buy_list": List<dynamic>.from(buyList.map((x) => x)),
        "sell_list": List<dynamic>.from(sellList.map((x) => x.toJson())),
    };
}

class SellList {
    int id;
    int userId;
    String price;
    String latitude;
    String longitude;
    String category;
    String? image;
    String jsonDataRaw;
     Map<String, dynamic> jsonData;
    int status;
    int likes;
    int dislikes;
    int view_count;
    bool userlike;
    String? rejectionReason;
    DateTime createdAt;
    DateTime updatedAt;

    SellList({
        required this.id,
        required this.userId,
        required this.price,
        required this.latitude,
        required this.longitude,
        required this.category,
        required this.image,
        required this.jsonData,
        required this.status,
        required this.likes,
        required this.dislikes,
        required this.view_count,
        required this.userlike,
        required this.rejectionReason,
        required this.createdAt,
        required this.updatedAt,
        required this.jsonDataRaw,
    });

    factory SellList.fromJson(Map<String, dynamic> json) {
        String raw = json["json_data"] ?? "";
    Map<String, dynamic> parsed = {};
    try {
      parsed = jsonDecode(raw);
    } catch (e) {
      print("Invalid json_data format: $e");
    }

      return SellList(
      
        id: json["id"],
        userId: json["user_id"],
        price: json["price"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        category: json["category"],
        image: json["image"],
        jsonDataRaw: raw,
        jsonData: parsed,
        status: json["status"],
        likes: json["likes"],
        dislikes: json["dislikes"],
        view_count: json["view_count"],
        userlike: json["userlike"],
        rejectionReason: json["rejection_reason"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "likes": likes,
        "dislikes": dislikes,
        "view_count": view_count,
        "userlike": userlike,
        "rejection_reason": rejectionReason,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
*/




import 'dart:convert';

GetListingModel getListingModelFromJson(String str) => GetListingModel.fromJson(json.decode(str));

String getListingModelToJson(GetListingModel data) => json.encode(data.toJson());

class GetListingModel {
  bool? success;
  Data? data;

  GetListingModel({
    this.success,
    this.data,
  });

  factory GetListingModel.fromJson(Map<String, dynamic> json) => GetListingModel(
    success: json["success"] as bool?,
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<dynamic>? buyList;
  List<SellList>? sellList;

  Data({
    this.buyList,
    this.sellList,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    buyList: json["buy_list"] != null ? List<dynamic>.from(json["buy_list"].map((x) => x)) : null,
    sellList: json["sell_list"] != null
        ? List<SellList>.from(json["sell_list"].map((x) => SellList.fromJson(x)))
        : null,
  );

  Map<String, dynamic> toJson() => {
    "buy_list": buyList != null ? List<dynamic>.from(buyList!.map((x) => x)) : null,
    "sell_list": sellList != null ? List<dynamic>.from(sellList!.map((x) => x.toJson())) : null,
  };
}

class SellList {
  int? id;
  int? userId;
  String? price;
  String? latitude;
  String? longitude;
  String? category;
  String? image;
  String? jsonDataRaw;
  Map<String, dynamic>? jsonData;
  int? status;
  int? likes;
  int? dislikes;
  int? viewCount;
  bool? userlike;
  String? rejectionReason;
  String? subcategory;
  DateTime? createdAt;
  DateTime? updatedAt;

  SellList({
    this.id,
    this.userId,
    this.price,
    this.latitude,
    this.longitude,
    this.category,
    this.image,
    this.jsonDataRaw,
    this.jsonData,
    this.status,
    this.likes,
    this.dislikes,
    this.viewCount,
    this.userlike,
    this.rejectionReason,
    this.subcategory,
    this.createdAt,
    this.updatedAt,
  });

  factory SellList.fromJson(Map<String, dynamic> json) {
    String? raw = json["json_data"] as String?;
    Map<String, dynamic>? parsed;
    if (raw != null) {
      try {
        parsed = jsonDecode(raw);
      } catch (e) {
        print("Invalid json_data format: $e");
      }
    }

    return SellList(
      id: json["id"] as int?,
      userId: json["user_id"] as int?,
      price: json["price"] as String?,
      latitude: json["latitude"] as String?,
      longitude: json["longitude"] as String?,
      category: json["category"] as String?,
      image: json["image"] as String?,
      jsonDataRaw: raw,
      jsonData: parsed,
      status: json["status"] as int?,
      likes: json["likes"] as int?,
      dislikes: json["dislikes"] as int?,
      viewCount: json["view_count"] as int?,
      userlike: json["userlike"] as bool?,
      rejectionReason: json["rejection_reason"] as String?,
      subcategory: json["subcategory"],
      createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
      updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
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
    "likes": likes,
    "dislikes": dislikes,
    "view_count": viewCount,
    "userlike": userlike,
    "rejection_reason": rejectionReason,
    "subcategory": subcategory,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}