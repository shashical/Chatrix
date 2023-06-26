import 'dart:convert';

Chat chatsFromJson(String str) => Chat.fromJson(json.decode(str));
String chatsToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String id;
  List<String> participantIds;

  Chat({
    required this.id,
    required this.participantIds,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
    };
  }
}
