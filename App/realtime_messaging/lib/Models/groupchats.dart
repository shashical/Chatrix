import 'dart:convert';

GroupChat groupChatFromJson(String str) => GroupChat.fromJson(json.decode(str));
String groupChatToJson(GroupChat data) => json.encode(data.toJson());

class GroupChat {
  String id;
  String chatId;
  bool exited;
  String? backgroundImage;
  bool pinned;

  GroupChat({
    required this.id,
    required this.chatId,
    required this.exited,
    this.backgroundImage,
    required this.pinned,
  });

  factory GroupChat.fromJson(Map<String, dynamic> json) {
    return GroupChat(
      id: json['id'],
      chatId: json['chatId'],
      exited: json['exited'],
      backgroundImage: json['backgroundImage'],
      pinned: json['pinned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'exited': exited,
      'backgroundImage': backgroundImage,
      'pinned': pinned,
    };
  }
}
