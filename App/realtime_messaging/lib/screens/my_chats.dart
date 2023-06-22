import 'package:flutter/material.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';

class MyChatsPage extends StatefulWidget {
  const MyChatsPage({super.key});

  @override
  State<MyChatsPage> createState() => _MyChatsPageState();
}

class _MyChatsPageState extends State<MyChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(onPressed: () {
        Navigator.push((context), MaterialPageRoute(builder: (context)=>SearchContactPage()));
      }, child: Text('Go to search'),
        
      ),),
    );
  }
}