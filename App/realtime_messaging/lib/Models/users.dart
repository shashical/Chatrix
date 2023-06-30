import 'dart:convert';

Users userFromJson(String str) => Users.fromJson(json.decode(str));
String userToJson(Users data) => json.encode(data.toJson());

class Users {
  String id;
  String? name;
  String? photoUrl;
  bool? isOnline;
  String phoneNo;
  String? about;
  DateTime? lastOnline;
  bool isOnlineVisibility;
  bool lastOnlineVisibility;
  List<String>? blockedBy;
  String publicKey;

  Users({
    required this.id,
    this.name,
    this.photoUrl = 'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg',
    this.isOnline=true,
    required this.phoneNo,
    this.about,
    this.lastOnline,
    this.isOnlineVisibility = true,
    this.lastOnlineVisibility = true,
    this.blockedBy = const [],
    required this.publicKey,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        name: json["name"],
        photoUrl: json["photoUrl"],
        isOnline: json["isOnline"],
        phoneNo: json["phoneNo"],
        about: json["about"],
        lastOnline: json["lastOnline"] != null ? DateTime.parse(json["lastOnline"]) : null,
        isOnlineVisibility: json["isOnlineVisibility"],
        lastOnlineVisibility: json["lastOnlineVisibility"],
        blockedBy: List<String>.from(json['blockedBy'] ?? []),
        publicKey: json['publicKey']
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photoUrl": photoUrl,
        "isOnline": isOnline,
        "phoneNo": phoneNo,
        "about": about,
        "lastOnline": lastOnline?.toIso8601String(),
        "isOnlineVisibility": isOnlineVisibility,
        "lastOnlineVisibility": lastOnlineVisibility,
        "blockedBy": blockedBy,
        "publicKey": publicKey
      };
}
