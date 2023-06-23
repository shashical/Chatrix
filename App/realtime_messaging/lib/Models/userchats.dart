import 'dart:convert';

UserChat userChatFromJson(String str) => UserChat.fromJson(json.decode(str));
String userChatToJson(UserChat data) => json.encode(data.toJson());

class UserChat {
  String id;
  String chatId;
  String recipientPhoto;
  String recipientName;
  bool deleted;
  String? backgroundImage;
  bool pinned;

  UserChat({
    required this.id,
    required this.chatId,
    required this.recipientPhoto,
    required this.recipientName,
    required this.deleted,
    this.backgroundImage,
    required this.pinned,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
      id: json['id'],
      chatId: json['chatId'],
      recipientPhoto: json['recipientPhoto'],
      recipientName: json['recipientName'],
      deleted: json['deleted'],
      backgroundImage: json['backgroundImage'],
      pinned: json['pinned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'recipientPhoto': recipientPhoto,
      'recipientName': recipientName,
      'deleted': deleted,
      'backgroundImage': backgroundImage,
      'pinned': pinned,
    };
  }
}
