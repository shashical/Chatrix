import 'dart:convert';

UserChat userChatFromJson(String str) => UserChat.fromJson(json.decode(str));
String userChatToJson(UserChat data) => json.encode(data.toJson());

class UserChat {
  String id;
  String chatId;
  String recipientPhoto;
  String? backgroundImage;
  bool pinned;
  String recipientPhoneNo;
  int? unreadMessageCount;
  String? lastMessage;
  String? lastMessageType;
  DateTime? lastMessageTime;
  bool muted;
  bool blocked;
  String? containsSymmKey;
  String? displayName;
  bool isSender;

  UserChat({
    required this.id,
    required this.chatId,
    required this.recipientPhoto,
    this.backgroundImage,
    required this.pinned,
    required this.recipientPhoneNo,
    this.unreadMessageCount,
    this.lastMessage='',
    this.lastMessageType='',
    this.lastMessageTime,
    this.muted = false,
    this.blocked = false,
    this.containsSymmKey,
    this.displayName='',
    this.isSender=false,
  });

  factory UserChat.fromJson(Map<String, dynamic> json) {
    return UserChat(
      id: json['id'],
      chatId: json['chatId'],
      recipientPhoto: json['recipientPhoto'],
      backgroundImage: json['backgroundImage'],
      pinned: json['pinned'],
      recipientPhoneNo: json['recipientPhoneNo'],
      unreadMessageCount: json['unreadMessageCount'],
      lastMessage: json['lastMessage'],
      lastMessageType: json['lastMessageType'],
      lastMessageTime:(json['lastMessageTime']!=null)? DateTime.parse(json['lastMessageTime']):null,
      muted: json['muted'],
      blocked: json['blocked'],
      containsSymmKey: json['containsSymmKey'],
      displayName:json['displayName']??'',
      isSender: json['isSender']??false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'recipientPhoto': recipientPhoto,
      'backgroundImage': backgroundImage,
      'pinned': pinned,
      'recipientPhoneNo': recipientPhoneNo,
      'unreadMessageCount': unreadMessageCount,
      'lastMessage': lastMessage,
      'lastMessageType': lastMessageType,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'muted': muted,
      'blocked': blocked,
      'containsSymmKey': containsSymmKey,
      'displayName':displayName,
      'isSender':isSender,
    };
  }
}
