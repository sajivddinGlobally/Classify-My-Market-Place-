// To parse this JSON data, do
//
//     final messageListResponse = messageListResponseFromJson(jsonString);

import 'dart:convert';

MessageListResponse messageListResponseFromJson(String str) =>
    MessageListResponse.fromJson(json.decode(str));

String messageListResponseToJson(MessageListResponse data) =>
    json.encode(data.toJson());

class MessageListResponse {
  String message;
  List<Chat> chat;
  int status;

  MessageListResponse({
    required this.message,
    required this.chat,
    required this.status,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) =>
      MessageListResponse(
        message: json["message"],
        chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "chat": List<dynamic>.from(chat.map((x) => x.toJson())),
    "status": status,
  };
}

class Chat {
  String id;
  int sender;
  String message;
  DateTime timestamp;

  Chat({required this.sender, required this.message, required this.timestamp, required this.id});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['id'] ?? "null",
    sender: json["sender"],
    message: json["message"],
    timestamp: DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "sender": sender,
    "message": message,
    "timestamp": timestamp.toIso8601String(),
  };
}
