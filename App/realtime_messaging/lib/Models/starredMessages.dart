
import 'dart:convert';

StarredMessage StarredMessageFromJson(String str) => StarredMessage.fromJson(json.decode(str));
String chatMessageToJson(StarredMessage data) => json.encode(data.toJson());
class StarredMessage{
  String id;
  String messageId;
  String collectionId;
  bool isGroup;
  String? recipientPhoneNo;
  String? groupName;
  String senderPhoneNo;
  String senderPhoto;
  String text;
  String contentType;
  DateTime timestamp;

  StarredMessage({
    required this.id,
    required this.messageId,
    required this.collectionId,
    required this.isGroup,
     this.recipientPhoneNo='',
     this.groupName='',
    required this.senderPhoneNo,
    required this.senderPhoto,
    required this.text,
    required this.contentType,
    required this.timestamp,

  });
  factory StarredMessage.fromJson(Map<String,dynamic>json){
    return StarredMessage(
        id: json['id'],
        messageId: json['messageId'],
        collectionId: json['collectionId'],
        isGroup: json['isGroup'],
        recipientPhoneNo:json['recipientPhoneNo'],
        groupName:json['groupName'],
        senderPhoneNo: json['senderPhoneNo'],
        senderPhoto: json['senderPhoto'],
        text:json['text'],
        contentType: json['contentType'],
        timestamp:DateTime.parse(json['timestamp'],

        )
    );
  }
  Map<String,dynamic> toJson(){
    return{
      'id':id,
      'messageId':messageId,
      'collectionId':collectionId,
      'isGroup':isGroup,
      'recipientPhoneNo':recipientPhoneNo,
      'groupName':groupName,
      'senderPhoneNo':senderPhoneNo,
      'senderPhoto':senderPhoto,
      'text':text,
      'contentType':contentType,
      'timestamp':timestamp.toIso8601String(),

    };
  }


}