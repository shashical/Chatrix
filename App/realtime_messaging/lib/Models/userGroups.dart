import 'dart:convert';

UserGroup userGroupFromJson(String str) => UserGroup.fromJson(json.decode(str));
String userGroupToJson(UserGroup data) => json.encode(data.toJson());

class UserGroup {
  String id;
  String groupId;
  bool exited;
  String? backgroundImage;
  bool pinned;

  UserGroup({
    required this.id,
    required this.groupId,
    required this.exited,
    this.backgroundImage,
    required this.pinned,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
      id: json['id'],
      groupId: json['groupId'],
      exited: json['exited'],
      backgroundImage: json['backgroundImage'],
      pinned: json['pinned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'exited': exited,
      'backgroundImage': backgroundImage,
      'pinned': pinned,
    };
  }
}
