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
  Map<String, bool> deliveredTo;
  Map<String, bool> readBy;
  bool edited;
  String? senderUrl;
  bool isUploaded;
  Map<String,bool>? downloaded;
  Map<String,String>? receiverUrls;

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
    this.deliveredTo = const {},
    this.readBy = const {},
    this.edited = false,
    this.senderUrl,
    this.isUploaded=false,
    this.downloaded=const {},
    this.receiverUrls=const {},

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
      senderUrl: json['senderUrl'],
      isUploaded: json['isUploaded'],
      downloaded: Map<String,bool>.from(json['downloaded']??{}),
      receiverUrls: Map<String,String>.from(json['receiverUrls']),
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
      'senderUrl':senderUrl,
      'isUploaded':isUploaded,
      'downloaded':downloaded,
      'receiverUrls':receiverUrls,
    };
  }
}
