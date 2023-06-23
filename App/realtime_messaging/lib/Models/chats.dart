import 'dart:convert';

Chat chatsFromJson(String str) => Chat.fromJson(json.decode(str));
String chatsToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String id;
  List<String> participantIds;
  Map<String, int>? unreadMessageCounts;
  String? lastMessage;
  String? lastMessageType;
  DateTime? lastMessageTime;
  List<String>? blockedList;
  List<String>? mutedBy;

  Chat({
    required this.id,
    required this.participantIds,
    this.unreadMessageCounts,
    this.lastMessage,
    this.lastMessageType,
    this.lastMessageTime,
    this.blockedList,
    this.mutedBy,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      unreadMessageCounts: Map<String, int>.from(json['unreadMessageCounts']),
      lastMessage: json['lastMessage'],
      lastMessageType: json['lastMessageType'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      blockedList: List<String>.from(json['blockedList'] ?? []),
      mutedBy: List<String>.from(json['mutedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'unreadMessageCounts': unreadMessageCounts,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'blockedList': blockedList,
      'mutedBy': mutedBy,
    };
  }
}
