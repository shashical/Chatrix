import 'dart:convert';

UserGroup userGroupFromJson(String str) => UserGroup.fromJson(json.decode(str));
String userGroupToJson(UserGroup data) => json.encode(data.toJson());

class UserGroup {
  String id;
  String groupId;
  bool exited;
  String backgroundImage;
  bool pinned;
  String name;
  String imageUrl;
  int? unreadMessageCount;
  String? lastMessage;
  DateTime? lastMessageTime;
  String? lastMessageType;
  bool muted;

  UserGroup({
    required this.id,
    required this.groupId,
    required this.exited,
    this.backgroundImage = "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
    required this.pinned,
    required this.name,
    required this.imageUrl,/* = "https://geodash.gov.bd/uploaded/people_group/default_group.png"*/
    this.unreadMessageCount,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
    this.muted = false,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      id: json['id'],
      groupId: json['groupId'],
      exited: json['exited'],
      backgroundImage: json['backgroundImage'],
      pinned: json['pinned'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      unreadMessageCount: json['unreadMessageCount'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessageType: json['lastMessageType'],
      muted: json['muted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'exited': exited,
      'backgroundImage': backgroundImage,
      'pinned': pinned,
      'name': name,
      'imageUrl': imageUrl,
      'unreadMessageCount': unreadMessageCount,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'lastMessageType': lastMessageType,
      'muted': muted
    };
  }
}
