import 'dart:convert';

GroupMessage groupMessageFromJson(String str) => GroupMessage.fromJson(json.decode(str));
String groupMessageToJson(GroupMessage data) => json.encode(data.toJson());

class GroupMessage {
  String id;
  String senderId;
  String senderName;
  String senderPhotoUrl;
  String senderPhoneNo;
  String text;
  String contentType;
  DateTime timestamp;
  Map<String, bool> deletedForMe;
  bool deletedForEveryone;
  String? repliedTo;
  Map<String, bool>? deliveredTo;
  Map<String, bool>? readBy;
  bool edited;

  GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderPhotoUrl,
    required this.senderPhoneNo,
    required this.text,
    required this.contentType,
    required this.timestamp,
    this.deletedForMe = const {},
    this.deletedForEveryone = false,
    this.repliedTo,
    this.deliveredTo,
    this.readBy,
    this.edited = false,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) {
    return GroupMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderPhotoUrl: json['senderPhotoUrl'],
      senderPhoneNo: json['senderPhoneNo'],
      text: json['text'],
      contentType: json['contentType'],
      timestamp: DateTime.parse(json['timestamp']),
      deletedForMe: Map<String, bool>.from(json['deletedForMe'] ?? {}),
      deletedForEveryone: json['deletedForEveryone'] ?? false,
      repliedTo: json['repliedTo'],
      deliveredTo: Map<String, bool>.from(json['deliveredTo'] ?? {}),
      readBy: Map<String, bool>.from(json['readBy'] ?? {}),
      edited: json['edited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'senderPhoneNo': senderPhoneNo,
      'text': text,
      'contentType': contentType,
      'timestamp': timestamp.toIso8601String(),
      'deletedForMe': deletedForMe,
      'deletedForEveryone': deletedForEveryone,
      'repliedTo': repliedTo,
      'deliveredTo': deliveredTo,
      'readBy': readBy,
      'edited': edited,
    };
  }
}
