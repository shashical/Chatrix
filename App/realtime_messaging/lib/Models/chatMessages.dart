import 'dart:convert';

ChatMessage chatMessageFromJson(String str) => ChatMessage.fromJson(json.decode(str));
String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  String id;
  String senderId;
  String text;
  String contentType;
  DateTime timestamp;
  Map<String, bool> deletedForMe;
  bool deletedForEveryone;
  String? repliedTo;
  bool delivered;
  bool read;
  bool edited;
  String? senderUrl;
  String? receiverUrl;
  bool uploaded;
  bool downloaded;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.contentType,
    required this.timestamp,
    this.deletedForMe = const {},
    this.deletedForEveryone = false,
    this.repliedTo,
    this.delivered = false,
    this.read = false,
    this.edited = false,
    this.senderUrl,
    this.receiverUrl,
    this.uploaded=false,
    this.downloaded=false
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      text: json['text'],
      contentType: json['contentType'],
      timestamp: DateTime.parse(json['timestamp']),
      deletedForMe: Map<String, bool>.from(json['deletedForMe'] ?? {}),
      deletedForEveryone: json['deletedForEveryone'] ?? false,
      repliedTo: json['repliedTo'],
      delivered: json['delivered'] ?? false,
      read: json['read'] ?? false,
      edited: json['edited'] ?? false,
      senderUrl:json['senderUrl'],
      receiverUrl: json['receiverUrl'],
      uploaded: json['uploaded'],
      downloaded: json['downloaded'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'contentType': contentType,
      'timestamp': timestamp.toIso8601String(),
      'deletedForMe': deletedForMe,
      'deletedForEveryone': deletedForEveryone,
      'repliedTo': repliedTo,
      'delivered': delivered,
      'read': read,
      'edited': edited,
      'senderUrl':senderUrl,
      'receiverUrl':receiverUrl,
      'uploaded':uploaded,
      'downloaded':downloaded,
    };
  }
}
