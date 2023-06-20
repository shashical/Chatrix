import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:realtime_messaging/screens/login_page.dart';
import 'package:realtime_messaging/screens/verify_otp_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

//hey
void main()async{
 // final ref=FirebaseFirestore.instance;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:VerifyOtpPage( phoneNo: '9811286230', verificationId: 'dbddb', token: 123456,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];
  bool isg = false;
  bool contactsFetched = false;

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }


  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContact();
      setState(() {
        isg = true;
      });
    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        fetchContact();
        setState(() {
          isg = true;
        });
      }
    }
    print("${contacts.length}");
  }

  void fetchContact() async {
    contacts = await FlutterContacts.getContacts();
    setState(() {
      contactsFetched = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('people'),
      ),
      body: isg == false
          ? Center(child: Text('Please restart the app and provide the permission to continue'))
              : contactsFetched
                  ? ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(contacts[index].displayName),
                      ),
                    )
                  :  CircularProgressIndicator() // Placeholder when contacts are not yet fetched
    );
  }
}

