import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:realtime_messaging/Services/local_notifications.dart';
import 'package:realtime_messaging/screens/chat_window.dart';
import 'package:realtime_messaging/screens/current_user_profile_page.dart';
import 'package:realtime_messaging/screens/group_window.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/screens/login_page.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/verify_otp_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'screens/my_chats.dart';
import 'screens/splash.dart';
import 'screens/user_info.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  debugPrint("This message is from foreground");
  debugPrint(message.notification!.title);
}

List<String> savedNumber = [];
List<String> savedUsers = [];
Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  LocalNotificationService.initialize();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  bool openedFromNotification = false;
  // String backgroundImage = '';
  // String otherUserId = '';
  // String id = '';
  // bool isGroup = false;
  // String groupPhoto = '';
  // String groupName = '';
  // bool containsSymmKey = false;


  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) {
      if (message != null) {
        // openedFromNotification = true;
        // backgroundImage = message.data['backgroundImage'];
        // id = message.data['chatId'];
        // isGroup = message.data['isGroup'];
        // containsSymmKey = message.data['containsSymmKey'];
        // if(isGroup){
        //   groupPhoto = message.data['groupPhoto'];
        //   groupName = message.data['groupName'];
        // }
        // else{
        //   otherUserId = message.data['otherUserId'];
        // }
      }
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage? message) {
      if (message != null) {
        // openedFromNotification = true;
        // backgroundImage = message.data['backgroundImage'];
        // id = message.data['chatId'];
        // isGroup = message.data['isGroup'];
        // containsSymmKey = message.data['containsSymmKey'];
        // if(isGroup){
        //   groupPhoto = message.data['groupPhoto'];
        //   groupName = message.data['groupName'];
        // }
        // else{
        //   otherUserId = message.data['otherUserId'];
        // }
      }
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    if(message!=null){
      LocalNotificationService.showNotificationOnForeground(message);
      openedFromNotification = true;
      // backgroundImage = message.data['backgroundImage'];
      // id = message.data['chatId'];
      // isGroup = message.data['isGroup'];
      // containsSymmKey = message.data['containsSymmKey'];
      // if(isGroup){
      //   groupPhoto = message.data['groupPhoto'];
      //   groupName = message.data['groupName'];
      // }
      // else{
      //   otherUserId = message.data['otherUserId'];
      // }
    }
  },);

  runApp(MyApp(
    // backgroundImage: backgroundImage,
    // id: id,
    openedFromNotification: openedFromNotification,
    // otherUserId: otherUserId,
    // groupName: groupName,
    // groupPhoto: groupPhoto,
    // isGroup: isGroup,
    // containsSymmKey: containsSymmKey,
  ));
}

class MyApp extends StatelessWidget {
  final bool openedFromNotification;
  // final String backgroundImage;
  // final String id;
  // final String otherUserId;
  // final bool isGroup;
  // final String groupPhoto;
  // final String groupName;
  // final bool containsSymmKey;

  const MyApp(
      {Key? key,
      // required this.containsSymmKey,
      // required this.groupPhoto,
      // required this.groupName,
      // required this.isGroup,
      required this.openedFromNotification,})
      // required this.backgroundImage,
      // required this.id,
      // required this.otherUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: (openedFromNotification?HomePage():SplashPage())
      // home: (openedFromNotification?(containsSymmKey?HomePage():(isGroup?GroupWindow(backgroundImage: backgroundImage, groupId: id, groupName: groupName, groupPhoto: groupPhoto,):ChatWindow(otherUserId: otherUserId, backgroundImage: backgroundImage, chatId: id,))):SplashPage()),
    );
  }
}
