import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SendNotificationService{
  void sendFCMChatMessage(String token, Map<String,dynamic> notification, Map<String,dynamic> data) async {
  final url = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=${dotenv.env['SERVER_KEY']}',
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
  final url = 'https://fcm.googleapis.com/fcm/send';

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=${dotenv.env['SERVER_KEY']}',
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
