import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendNotificationService{
  void sendFCMChatMessage(String token, Map<String,dynamic> notification, Map<String,dynamic> data) async {
  final serverKey = 'AAAAEsCHAK8:APA91bEteWHVo6bO4H6MF4AljWHLWMOhdnIRKTP5I-b9t99jU-Y8sJK2tsbQ2CDK9oAxhDiY0ZY5wXXy0apz21BEsBU0MWB6DnHuVeUNNSxNIqH5gd8N6QsjKqhmW1114qldBH6aX5wF';
  final url = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final body = {
    'to': token,
    'notification': notification,
    'data': data,
    // 'notification': {
    //   'title': 'Notification Title',
    //   'body': 'Notification Body',
    // },
    // 'data': {
    //   'customKey': 'customValue',
    // },
    'direct_boot_ok': true,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    debugPrint('Message sent successfully');
  } else {
    debugPrint('Failed to send message. Error: ${response.body}');
  }
}

void sendFCMGroupMessage(List<String> tokens, Map<String,dynamic> notification, Map<String,dynamic> data) async {
  final serverKey = 'AAAAEsCHAK8:APA91bEteWHVo6bO4H6MF4AljWHLWMOhdnIRKTP5I-b9t99jU-Y8sJK2tsbQ2CDK9oAxhDiY0ZY5wXXy0apz21BEsBU0MWB6DnHuVeUNNSxNIqH5gd8N6QsjKqhmW1114qldBH6aX5wF';
  final url = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final body = {
    'registration_ids': tokens,
    'notification': notification,
    'data': data,
    // 'notification': {
    //   'title': 'Notification Title',
    //   'body': 'Notification Body',
    // },
    // 'data': {
    //   'customKey': 'customValue',
    // },
    'direct_boot_ok': true,
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    debugPrint('Message sent successfully');
  } else {
    debugPrint('Failed to send message. Error: ${response.body}');
  }
}
}