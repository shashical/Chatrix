import 'dart:convert';

Chat chatsFromJson(String str) => Chat.fromJson(json.decode(str));
String chatsToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String id;
  List<String> participantIds;
  List<String>? blockedList;

  Chat({
    required this.id,
    required this.participantIds,
    this.blockedList,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      blockedList: List<String>.from(json['blockedList'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'blockedList': blockedList,
    };
  }
}
