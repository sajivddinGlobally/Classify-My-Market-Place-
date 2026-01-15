// To parse this JSON data, do
//
//     final activePlan = activePlanFromJson(jsonString);

import 'dart:convert';

ActivePlan activePlanFromJson(String str) => ActivePlan.fromJson(json.decode(str));

String activePlanToJson(ActivePlan data) => json.encode(data.toJson());

class ActivePlan {
    ActivePlanClass activePlan;

    ActivePlan({
        required this.activePlan,
    });

    factory ActivePlan.fromJson(Map<String, dynamic> json) => ActivePlan(
        activePlan: ActivePlanClass.fromJson(json["active_plan"]),
    );

    Map<String, dynamic> toJson() => {
        "active_plan": activePlan.toJson(),
    };
}

class ActivePlanClass {
    int id;
    int userId;
    int planId;
    String trnxId;
    String paymentType;
    String status;
    DateTime startDate;
    DateTime endDate;
    int usedBoost;
    DateTime createdAt;
    DateTime updatedAt;
    Plan plan;

    ActivePlanClass({
        required this.id,
        required this.userId,
        required this.planId,
        required this.trnxId,
        required this.paymentType,
        required this.status,
        required this.startDate,
        required this.endDate,
        required this.usedBoost,
        required this.createdAt,
        required this.updatedAt,
        required this.plan,
    });

    factory ActivePlanClass.fromJson(Map<String, dynamic> json) => ActivePlanClass(
        id: json["id"],
        userId: json["user_id"],
        planId: json["plan_id"],
        trnxId: json["trnx_id"],
        paymentType: json["payment_type"],
        status: json["status"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        usedBoost: json["used_boost"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        plan: Plan.fromJson(json["plan"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "plan_id": planId,
        "trnx_id": trnxId,
        "payment_type": paymentType,
        "status": status,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "used_boost": usedBoost,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "plan": plan.toJson(),
    };
}

class Plan {
    int id;
    String price;
    int duration;
    String planType;
    String description;
    int boostCount;
    DateTime createdAt;
    DateTime updatedAt;

    Plan({
        required this.id,
        required this.price,
        required this.duration,
        required this.planType,
        required this.description,
        required this.boostCount,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        price: json["price"],
        duration: json["duration"],
        planType: json["plan_type"],
        description: json["description"],
        boostCount: json["boost_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "duration": duration,
        "plan_type": planType,
        "description": description,
        "boost_count": boostCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
