// To parse this JSON data, do
//
//     final createPlanResponseModel = createPlanResponseModelFromJson(jsonString);

import 'dart:convert';

CreatePlanResponseModel createPlanResponseModelFromJson(String str) => CreatePlanResponseModel.fromJson(json.decode(str));

String createPlanResponseModelToJson(CreatePlanResponseModel data) => json.encode(data.toJson());

class CreatePlanResponseModel {
  bool? success;
  Order? order;
  Payment? payment;
  bool? isFirstTimeUser;

  CreatePlanResponseModel({
    this.success,
    this.order,
    this.payment,
    this.isFirstTimeUser,
  });

  factory CreatePlanResponseModel.fromJson(Map<String, dynamic> json) => CreatePlanResponseModel(
    success: json["success"],
    order: json["order"] == null ? null : Order.fromJson(json["order"]),
    payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
    isFirstTimeUser: json["is_first_time_user"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "order": order?.toJson(),
    "payment": payment?.toJson(),
    "is_first_time_user": isFirstTimeUser,
  };
}

class Order {
  Order();

  factory Order.fromJson(Map<String, dynamic> json) => Order(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Payment {
  dynamic userId;
  int? planId;
  String? orderId;
  dynamic amount;
  String? currency;
  String? status;
  String? description;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Payment({
    this.userId,
    this.planId,
    this.orderId,
    this.amount,
    this.currency,
    this.status,
    this.description,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    userId: json["user_id"],
    planId: json["plan_id"],
    orderId: json["order_id"],
    amount: json["amount"],
    currency: json["currency"],
    status: json["status"],
    description: json["description"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "plan_id": planId,
    "order_id": orderId,
    "amount": amount,
    "currency": currency,
    "status": status,
    "description": description,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
