import 'dart:convert';

UserChat userChatFromJson(String str) => UserChat.fromJson(json.decode(str));
String userChatToJson(UserChat data) => json.encode(data.toJson());

class UserChat {
  String id;
  String chatId;
  String recipientPhoto;
  bool deleted;
  String? backgroundImage;
  bool pinned;
  String recipientPhoneNo;

  UserChat({
    required this.id,
    required this.chatId,
    required this.recipientPhoto,
    required this.deleted,
    this.backgroundImage = "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
    required this.pinned,
    required this.recipientPhoneNo,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
      id: json['id'],
      chatId: json['chatId'],
      recipientPhoto: json['recipientPhoto'],
      deleted: json['deleted'],
      backgroundImage: json['backgroundImage'],
      pinned: json['pinned'],
      recipientPhoneNo: json['recipientPhoneNo']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'recipientPhoto': recipientPhoto,
      'deleted': deleted,
      'backgroundImage': backgroundImage,
      'pinned': pinned,
      'recipientPhoneNo': recipientPhoneNo,
    };
  }
}
