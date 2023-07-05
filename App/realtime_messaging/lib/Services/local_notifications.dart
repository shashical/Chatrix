import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print(details.payload);
      },
    );
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    _notificationPlugin.show(
        payload: message.data['id'],
        DateTime.now().microsecondsSinceEpoch,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                "com.example.realtime_messaging", "realtime_messaging",
                importance: Importance.max, priority: Priority.high)));
  }
}
