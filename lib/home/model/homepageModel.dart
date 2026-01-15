/*

import 'dart:convert';

HomepageModel homepageModelFromJson(String str) =>
    HomepageModel.fromJson(json.decode(str));

String homepageModelToJson(HomepageModel data) =>
    json.encode(data.toJson());

class HomepageModel {
  bool status;
  String location;
  List<Category> categories;
  List<AllProduct> latestListings;
  List<AllProduct> allProducts;

  HomepageModel({
    required this.status,
    required this.location,
    required this.categories,
    required this.latestListings,
    required this.allProducts,
  });

  factory HomepageModel.fromJson(Map<String, dynamic> json) => HomepageModel(
        status: json["status"],
        location: json["location"],
        categories: List<Category>.from(
          json["categories"].map((x) => Category.fromJson(x)),
        ),
        latestListings: List<AllProduct>.from(
          json["latest_listings"].map((x) => AllProduct.fromJson(x)),
        ),
        allProducts: List<AllProduct>.from(
          json["all_products"].map((x) => AllProduct.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "location": location,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "latest_listings":
            List<dynamic>.from(latestListings.map((x) => x.toJson())),
        "all_products": List<dynamic>.from(allProducts.map((x) => x.toJson())),
      };
}

class AllProduct {
  int id;
  int userId;
  String? price;
  String latitude;
  String longitude;
  String category;
  String? image;
  String jsonDataRaw; // raw string from API
  Map<String, dynamic> jsonData; // parsed map
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  int likes;
  int dislikes;
  bool userlike;

  AllProduct({
    required this.id,
    required this.userId,
     this.price,
    required this.latitude,
    required this.longitude,
    required this.category,
    required this.image,
    required this.jsonDataRaw,
    required this.jsonData,
    required this.status,
    required this.createdAt,
    required this.updatedAt,

    required this.likes,
    required this.dislikes,
    required this.userlike,
  });

  factory AllProduct.fromJson(Map<String, dynamic> json) {
    final raw = json["json_data"] ?? "";
    Map<String, dynamic> parsed = {};

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        parsed = decoded;
      }
    } catch (e) {
      print("Invalid json_data: $e");
    }

    return AllProduct(
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
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),

      likes: json["likes"],
      dislikes: json["dislikes"],
      userlike: json["userlike"],
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

        "likes": likes,
        "dislikes": dislikes,
        "userlike": userlike,
      };
}

class Category {
  int id;
  String title;
  String? imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        imageUrl: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
*/


/*

// To parse this JSON data, do
//
//     final homepageModel = homepageModelFromJson(jsonString);

import 'dart:convert';

HomepageModel homepageModelFromJson(String str) => HomepageModel.fromJson(json.decode(str));

String homepageModelToJson(HomepageModel data) => json.encode(data.toJson());

class HomepageModel {
  bool? status;
  String? location;
  List<CategoryElement>? categories;
  List<LatestListing>? latestListings;
  List<AllProduct>? allProducts;

  HomepageModel({
    this.status,
    this.location,
    this.categories,
    this.latestListings,
    this.allProducts,
  });

  factory HomepageModel.fromJson(Map<String, dynamic> json) => HomepageModel(
    status: json["status"],
    location: json["location"],
    categories: json["categories"] == null ? [] : List<CategoryElement>.from(json["categories"]!.map((x) => CategoryElement.fromJson(x))),
    latestListings: json["latest_listings"] == null ? [] : List<LatestListing>.from(json["latest_listings"]!.map((x) => LatestListing.fromJson(x))),
    allProducts: json["all_products"] == null ? [] : List<AllProduct>.from(json["all_products"]!.map((x) => AllProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "location": location,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "latest_listings": latestListings == null ? [] : List<dynamic>.from(latestListings!.map((x) => x.toJson())),
    "all_products": allProducts == null ? [] : List<dynamic>.from(allProducts!.map((x) => x.toJson())),
  };
}

class AllProduct {
  int? id;
  int? userId;
  String? price;
  String? latitude;
  String? longitude;
  CategoryEnum? category;
  String? image;
  String? jsonData;
  int? status;
  dynamic rejectionReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? viewCount;
  double? distance;
  int? likes;
  int? dislikes;
  bool? userlike;

  AllProduct({
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
    this.distance,
    this.likes,
    this.dislikes,
    this.userlike,
  });

  factory AllProduct.fromJson(Map<String, dynamic> json) => AllProduct(
    id: json["id"],
    userId: json["user_id"],
    price: json["price"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    category: categoryEnumValues.map[json["category"]]!,
    image: json["image"],
    jsonData: json["json_data"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    viewCount: json["view_count"],
    distance: json["distance"]?.toDouble(),
    likes: json["likes"],
    dislikes: json["dislikes"],
    userlike: json["userlike"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": categoryEnumValues.reverse[category],
    "image": image,
    "json_data": jsonData,
    "status": status,
    "rejection_reason": rejectionReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "view_count": viewCount,
    "distance": distance,
    "likes": likes,
    "dislikes": dislikes,
    "userlike": userlike,
  };
}

enum CategoryEnum {
  BICYCLE,
  BIKES,
  CAR,
  CARS,
  CATEGORY_CAR,
  COMMERCIALS,
  EDUCATION_CLASSES,
  ELECTRONICS,
  JOBS,
  MOBILES,
  PACKERS_MOVERS,
  PROPERTIES,
  TOURS_TRAVEL
}

final categoryEnumValues = EnumValues({
  "bicycle": CategoryEnum.BICYCLE,
  "Bikes": CategoryEnum.BIKES,
  "car": CategoryEnum.CAR,
  "Cars": CategoryEnum.CARS,
  "Car": CategoryEnum.CATEGORY_CAR,
  "Commercials": CategoryEnum.COMMERCIALS,
  "Education & Classes": CategoryEnum.EDUCATION_CLASSES,
  "Electronics": CategoryEnum.ELECTRONICS,
  "Jobs": CategoryEnum.JOBS,
  "Mobiles": CategoryEnum.MOBILES,
  "Packers Movers": CategoryEnum.PACKERS_MOVERS,
  "Properties": CategoryEnum.PROPERTIES,
  "Tours/Travel": CategoryEnum.TOURS_TRAVEL
});

class CategoryElement {
  int? id;
  CategoryEnum? title;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  CategoryElement({
    this.id,
    this.title,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) => CategoryElement(
    id: json["id"],
    title: categoryEnumValues.map[json["title"]]!,
    imageUrl: json["image_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": categoryEnumValues.reverse[title],
    "image_url": imageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class LatestListing {
  int? id;
  int? userId;
  String? price;
  String? latitude;
  String? longitude;
  CategoryEnum? category;
  String? image;
  String? jsonData;
  String? status;
  dynamic rejectionReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? viewCount;
  int? planId;
  String? trnxId;
  String? paymentType;
  DateTime? startDate;
  DateTime? endDate;
  int? usedBoost;
  double? distance;
  int? likes;
  int? dislikes;
  bool? userlike;

  LatestListing({
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
    this.planId,
    this.trnxId,
    this.paymentType,
    this.startDate,
    this.endDate,
    this.usedBoost,
    this.distance,
    this.likes,
    this.dislikes,
    this.userlike,
  });

  factory LatestListing.fromJson(Map<String, dynamic> json) => LatestListing(
    id: json["id"],
    userId: json["user_id"],
    price: json["price"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    category: categoryEnumValues.map[json["category"]]!,
    image: json["image"],
    jsonData: json["json_data"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    viewCount: json["view_count"],
    planId: json["plan_id"],
    trnxId: json["trnx_id"],
    paymentType: json["payment_type"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    usedBoost: json["used_boost"],
    distance: json["distance"]?.toDouble(),
    likes: json["likes"],
    dislikes: json["dislikes"],
    userlike: json["userlike"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": categoryEnumValues.reverse[category],
    "image": image,
    "json_data": jsonData,
    "status": status,
    "rejection_reason": rejectionReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "view_count": viewCount,
    "plan_id": planId,
    "trnx_id": trnxId,
    "payment_type": paymentType,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "used_boost": usedBoost,
    "distance": distance,
    "likes": likes,
    "dislikes": dislikes,
    "userlike": userlike,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
*/



// To parse this JSON data, do
//
//     final homepageModel = homepageModelFromJson(jsonString);





import 'dart:convert';

HomepageModel homepageModelFromJson(String str) => HomepageModel.fromJson(json.decode(str));

String homepageModelToJson(HomepageModel data) => json.encode(data.toJson());

class HomepageModel {
  bool? status;
  String? location;
  List<Category>? categories;
  List<AllProduct>? latestListings;
  List<AllProduct>? allProducts;

  HomepageModel({
    this.status,
    this.location,
    this.categories,
    this.latestListings,
    this.allProducts,
  });

  factory HomepageModel.fromJson(Map<String, dynamic> json) => HomepageModel(
    status: json["status"],
    location: json["location"],
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    latestListings: json["latest_listings"] == null ? [] : List<AllProduct>.from(json["latest_listings"]!.map((x) => AllProduct.fromJson(x))),
    allProducts: json["all_products"] == null ? [] : List<AllProduct>.from(json["all_products"]!.map((x) => AllProduct.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "location": location,
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "latest_listings": latestListings == null ? [] : List<dynamic>.from(latestListings!.map((x) => x.toJson())),
    "all_products": allProducts == null ? [] : List<dynamic>.from(allProducts!.map((x) => x.toJson())),
  };
}

class AllProduct {
  int? id;
  int? userId;
  String? price;
  String? latitude;
  String? longitude;
  String? category;
  String? image;
  String? jsonData;
  int? status;
  dynamic rejectionReason;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? viewCount;
  String? city;
  String? state;
  String? country;
  double? distance;
  int? likes;
  int? dislikes;
  bool? userlike;
  String? listingType;

  AllProduct({
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
    this.city,
    this.state,
    this.country,
    this.distance,
    this.likes,
    this.dislikes,
    this.userlike,
    this.listingType,
  });

  factory AllProduct.fromJson(Map<String, dynamic> json) => AllProduct(
    id: json["id"],
    userId: json["user_id"],
    price: json["price"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    category: json["category"],
    image: json["image"],
    jsonData: json["json_data"],
    status: json["status"],
    rejectionReason: json["rejection_reason"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    viewCount: json["view_count"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    distance: json["distance"]?.toDouble(),
    likes: json["likes"],
    dislikes: json["dislikes"],
    userlike: json["userlike"],
    listingType: json["listing_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "price": price,
    "latitude": latitude,
    "longitude": longitude,
    "category": category,
    "image": image,
    "json_data": jsonData,
    "status": status,
    "rejection_reason": rejectionReason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "view_count": viewCount,
    "city": city,
    "state": state,
    "country": country,
    "distance": distance,
    "likes": likes,
    "dislikes": dislikes,
    "userlike": userlike,
    "listing_type": listingType,
  };
}

class Category {
  int? id;
  String? title;
  String? imageUrl;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.title,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    imageUrl: json["image_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image_url": imageUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
