
import 'dart:convert';

StarMessage StarMessageFromJson(String str) => StarMessage.fromJson(json.decode(str));
String chatMessageToJson(StarMessage data) => json.encode(data.toJson());
class StarMessage{
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

  StarMessage({
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
  factory StarMessage.fromJson(Map<String,dynamic>json){
    return StarMessage(
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