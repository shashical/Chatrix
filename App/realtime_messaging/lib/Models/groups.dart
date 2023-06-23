import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));
String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  String id;
  String name;
  String? imageUrl;
  List<String> participantIds;
  Map<String, int>? unreadMessageCounts;
  DateTime creationTimestamp;
  String createdBy;
  String? lastMessage;
  DateTime? lastMessageTime;
  String? lastMessageType;
  String? description;
  List<String>? admins;
  List<String>? mutedBy;

  Group({
    required this.id,
    required this.name,
    this.imageUrl = "https://geodash.gov.bd/uploaded/people_group/default_group.png",
    required this.participantIds,
    this.unreadMessageCounts,
    required this.creationTimestamp,
    required this.createdBy,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageType,
    this.description,
    this.admins,
    this.mutedBy,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      participantIds: List<String>.from(json['participantIds']),
      unreadMessageCounts: Map<String, int>.from(json['unreadMessageCounts']),
      creationTimestamp: DateTime.parse(json['creationTimestamp']),
      createdBy: json['createdBy'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      lastMessageType: json['lastMessageType'],
      description: json['description'],
      admins: List<String>.from(json['admins'] ?? []),
      mutedBy: List<String>.from(json['mutedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'participantIds': participantIds,
      'unreadMessageCounts': unreadMessageCounts,
      'creationTimestamp': creationTimestamp.toIso8601String(),
      'createdBy': createdBy,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'lastMessageType': lastMessageType,
      'description': description,
      'admins': admins,
      'mutedBy': mutedBy,
    };
  }
}
