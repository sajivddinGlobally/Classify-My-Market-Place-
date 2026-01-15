/*
// To parse this JSON data, do
//
//     final inboxListResponse = inboxListResponseFromJson(jsonString);

import 'dart:convert';

InboxListResponse inboxListResponseFromJson(String str) =>
    InboxListResponse.fromJson(json.decode(str));

String inboxListResponseToJson(InboxListResponse data) =>
    json.encode(data.toJson());

class InboxListResponse {
  String message;
  List<Inbox> inbox;
  EgedUser egedUser;
  int status;

  InboxListResponse({
    required this.message,
    required this.inbox,
    required this.egedUser,
    required this.status,
  });

  // factory InboxListResponse.fromJson(Map<String, dynamic> json) =>
  //     InboxListResponse(
  //       message: json["@message"],
  //       inbox: List<Inbox>.from(json["@inbox"].map((x) => Inbox.fromJson(x))),
  //       egedUser: EgedUser.fromJson(json["@eged_user"]),
  //       status: json["@status"],
  //     );
  factory InboxListResponse.fromJson(Map<String, dynamic> json) =>
      InboxListResponse(
        message: json["@message"] ?? '',
        inbox:
            json["@inbox"] == null
                ? [] // 👈 return empty list instead of calling map on null
                : List<Inbox>.from(
                  json["@inbox"].map((x) => Inbox.fromJson(x)),
                ),
        egedUser:
            json["@eged_user"] != null
                ? EgedUser.fromJson(json["@eged_user"])
                : EgedUser(
                  id: 0,
                  address: '',
                  pincode: '',
                  profileApproved: '',
                  fcmToken: '',
                  updatedAt: DateTime.now(),
                  city: '',
                  fullName: '',
                  phoneNumber: '',
                  image: '',
                  lastActiveAt: DateTime.now(),
                  createdAt: DateTime.now(),
                ),
        status: json["@status"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "@message": message,
    "@inbox": List<dynamic>.from(inbox.map((x) => x.toJson())),
    "@eged_user": egedUser.toJson(),
    "@status": status,
  };
}

class EgedUser {
  int id;
  String address;
  String pincode;
  String profileApproved;
  String fcmToken;
  DateTime updatedAt;
  String city;
  String fullName;
  String phoneNumber;
  String? image;
  DateTime lastActiveAt;
  DateTime createdAt;

  EgedUser({
    required this.id,
    required this.address,
    required this.pincode,
    required this.profileApproved,
    required this.fcmToken,
    required this.updatedAt,
    required this.city,
    required this.fullName,
    required this.phoneNumber,
    this.image,
    required this.lastActiveAt,
    required this.createdAt,
  });

  factory EgedUser.fromJson(Map<String, dynamic> json) => EgedUser(
    id: json["id"],
    address: json["address"],
    pincode: json["pincode"],
    profileApproved: json["profile_approved"],
    fcmToken: json["fcm_Token"],
    updatedAt: DateTime.parse(json["updated_at"]),
    city: json["city"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    image: json["image"].toString(),
    lastActiveAt: DateTime.parse(json["last_active_at"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "pincode": pincode,
    "profile_approved": profileApproved,
    "fcm_Token": fcmToken,
    "updated_at": updatedAt.toIso8601String(),
    "city": city,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "image": image,
    "last_active_at": lastActiveAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}

class Inbox {
  String conversationId;
  OtherUser otherUser;
  String lastMessage;
  DateTime timestamp;

  Inbox({
    required this.conversationId,
    required this.otherUser,
    required this.lastMessage,
    required this.timestamp,
  });

  factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
    conversationId: json["conversation_id"],
    otherUser: OtherUser.fromJson(json["other_user"]),
    lastMessage: json["last_message"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "conversation_id": conversationId,
    "other_user": otherUser.toJson(),
    "last_message": lastMessage,
    "timestamp": timestamp.toIso8601String(),
  };
}

class OtherUser {
  int id;
  String name;
  String? profilePick;
  bool isReaded;
  bool senderYou;

  OtherUser({
    required this.id,
    required this.name,
    required this.profilePick,
    required this.isReaded,
    required this.senderYou,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
    id: json["_id"],
    name: json["name"],
    profilePick: json["profilePick"],
    isReaded: json["is_readed"],
    senderYou: json["sender_you"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profilePick": profilePick,
    "is_readed": isReaded,
    "sender_you": senderYou,
  };
}


*/






// To parse this JSON data, do
//
//     final inboxListResponse = inboxListResponseFromJson(jsonString);

import 'dart:convert';

InboxListResponse inboxListResponseFromJson(String str) => InboxListResponse.fromJson(json.decode(str));

String inboxListResponseToJson(InboxListResponse data) => json.encode(data.toJson());

class InboxListResponse {
  String? message;
  List<Inbox>? inbox;
  EgedUser? egedUser;
  int? status;

  InboxListResponse({
    this.message,
    this.inbox,
    this.egedUser,
    this.status,
  });

  factory InboxListResponse.fromJson(Map<String, dynamic> json) => InboxListResponse(
    message: json["@message"],
    inbox: json["@inbox"] == null ? [] : List<Inbox>.from(json["@inbox"]!.map((x) => Inbox.fromJson(x))),
    egedUser: json["@eged_user"] == null ? null : EgedUser.fromJson(json["@eged_user"]),
    status: json["@status"],
  );

  Map<String, dynamic> toJson() => {
    "@message": message,
    "@inbox": inbox == null ? [] : List<dynamic>.from(inbox!.map((x) => x.toJson())),
    "@eged_user": egedUser?.toJson(),
    "@status": status,
  };
}

class EgedUser {
  int? id;
  String? phoneNumber;
  dynamic otpExpiresAt;
  String? firebaseUid;
  String? city;
  String? image;
  DateTime? lastActiveAt;
  DateTime? createdAt;
  dynamic otp;
  String? fullName;
  int? isOtpVerified;
  String? address;
  String? pincode;
  String? profileApproved;
  String? fcmToken;
  DateTime? updatedAt;

  EgedUser({
    this.id,
    this.phoneNumber,
    this.otpExpiresAt,
    this.firebaseUid,
    this.city,
    this.image,
    this.lastActiveAt,
    this.createdAt,
    this.otp,
    this.fullName,
    this.isOtpVerified,
    this.address,
    this.pincode,
    this.profileApproved,
    this.fcmToken,
    this.updatedAt,
  });

  factory EgedUser.fromJson(Map<String, dynamic> json) => EgedUser(
    id: json["id"],
    phoneNumber: json["phone_number"],
    otpExpiresAt: json["otp_expires_at"],
    firebaseUid: json["firebase_uid"],
    city: json["city"],
    image: json["image"],
    lastActiveAt: json["last_active_at"] == null ? null : DateTime.parse(json["last_active_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    otp: json["otp"],
    fullName: json["full_name"],
    isOtpVerified: json["is_otp_verified"],
    address: json["address"],
    pincode: json["pincode"],
    profileApproved: json["profile_approved"],
    fcmToken: json["fcm_token"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phone_number": phoneNumber,
    "otp_expires_at": otpExpiresAt,
    "firebase_uid": firebaseUid,
    "city": city,
    "image": image,
    "last_active_at": lastActiveAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "otp": otp,
    "full_name": fullName,
    "is_otp_verified": isOtpVerified,
    "address": address,
    "pincode": pincode,
    "profile_approved": profileApproved,
    "fcm_token": fcmToken,
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Inbox {
  String? conversationId;
  OtherUser? otherUser;
  String? lastMessage;
  DateTime? timestamp;

  Inbox({
    this.conversationId,
    this.otherUser,
    this.lastMessage,
    this.timestamp,
  });

  factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
    conversationId: json["conversation_id"],
    otherUser: json["other_user"] == null ? null : OtherUser.fromJson(json["other_user"]),
    lastMessage: json["last_message"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "conversation_id": conversationId,
    "other_user": otherUser?.toJson(),
    "last_message": lastMessage,
    "timestamp": timestamp?.toIso8601String(),
  };
}

class OtherUser {
  int? id;
  String? name;
  String? profilePic;
  bool? isReaded;
  bool? senderYou;

  OtherUser({
    this.id,
    this.name,
    this.profilePic,
    this.isReaded,
    this.senderYou,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
    id: json["_id"],
    name: json["name"],
    profilePic: json["profilePic"],
    isReaded: json["is_readed"],
    senderYou: json["sender_you"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profilePic": profilePic,
    "is_readed": isReaded,
    "sender_you": senderYou,
  };
}

