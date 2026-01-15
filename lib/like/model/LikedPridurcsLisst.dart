import 'dart:convert';

LikesProductListModel likesProductListModelFromJson(String str) => LikesProductListModel.fromJson(json.decode(str));

String likesProductListModelToJson(LikesProductListModel data) => json.encode(data.toJson());

class LikesProductListModel {
    bool status;
    List<LikedProduct> likedProducts;

    LikesProductListModel({
        required this.status,
        required this.likedProducts,
    });

    factory LikesProductListModel.fromJson(Map<String, dynamic> json) => LikesProductListModel(
        status: json["status"] ?? false,
        likedProducts: List<LikedProduct>.from(json["liked_products"].map((x) => LikedProduct.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "liked_products": List<dynamic>.from(likedProducts.map((x) => x.toJson())),
    };
}

class LikedProduct {
    int id;
    int userId;
    dynamic price;
    dynamic latitude;
    dynamic longitude;
    String category;
    String image;
    String jsonDataRaw; // raw string from API
    Map<String, dynamic> jsonData; // parsed map
    int status;
    DateTime createdAt;
    DateTime updatedAt;
    int likes;
    int dislikes;

    LikedProduct({
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
        required this.likes,
        required this.dislikes,
    });

    factory LikedProduct.fromJson(Map<String, dynamic> json) {
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

        return LikedProduct(
            id: json["id"] ?? 0,
            userId: json["user_id"] ?? 0,
            price: json["price"],
            latitude: json["latitude"],
            longitude: json["longitude"],
            category: json["category"] ?? "",
            image: json["image"] ?? "",
            jsonDataRaw: raw,
            jsonData: parsed,
            status: json["status"] ?? 0,
            createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
            updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
            likes: json["likes"] ?? 0,
            dislikes: json["dislikes"] ?? 0,
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
    };
}