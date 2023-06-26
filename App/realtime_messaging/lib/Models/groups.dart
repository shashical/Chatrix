import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));
String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  String id;
  List<String> participantIds;
  DateTime creationTimestamp;
  String createdBy;
  String? description;
  List<String>? admins;

  Group({
    required this.id,
    required this.participantIds,
    required this.creationTimestamp,
    required this.createdBy,
    this.description,
    this.admins,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      creationTimestamp: DateTime.parse(json['creationTimestamp']),
      createdBy: json['createdBy'],
      description: json['description'],
      admins: List<String>.from(json['admins'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'creationTimestamp': creationTimestamp.toIso8601String(),
      'createdBy': createdBy,
      'description': description,
      'admins': admins,
    };
  }
}
