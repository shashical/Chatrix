import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/Services/local_notifications.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/theme_provider.dart';
import 'screens/splash.dart';

bool darkmode=false;
Future<void> backgroundHandler(RemoteMessage message)async{
  debugPrint("This message is from background");
  LocalNotificationService.showNotificationOnForeground(message);
debugPrint(message.notification!.title);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
}

List<String> savedNumber = [];
List<String> savedUsers = [];
Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await ThemeProvider().loadThemePreference();

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
  String? themePreference = await const FlutterSecureStorage().read(key: 'theme_preference');
  if(themePreference=='true'){
    darkmode=true;
  }



  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) {
      if (message != null) {
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
    },
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage? message) {
      if (message != null) {
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

  MyApp(
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

  final lightTheme = ThemeData(
    brightness: Brightness.light,
  );

  final darkTheme = ThemeData(
    brightness: Brightness.dark,
  );


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: 
    (_) => ThemeProvider(),
    child: Consumer<ThemeProvider>(
      builder: (_, themeProvider, __) {
        return MaterialApp(
          title: 'Chatrix',
          theme: themeProvider.isDarkMode ? darkTheme : lightTheme,
          debugShowCheckedModeBanner: false,
          home: (openedFromNotification?HomePage():SplashPage())
        );
      },
    ),
    );
      // home: (openedFromNotification?(containsSymmKey?HomePage():(isGroup?GroupWindow(backgroundImage: backgroundImage, groupId: id, groupName: groupName, groupPhoto: groupPhoto,):ChatWindow(otherUserId: otherUserId, backgroundImage: backgroundImage, chatId: id,))):SplashPage()),
  }
}
