import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

List<Contact> contacts=[];
bool isg=false;
bool isloading=false;


  @override
  // void initState(){
  //   super.initState();
  //   getContactPermission();
  //
  //
  // }
  // void getContactPermission()async{
  //  if(await Permission.contacts.isGranted){
  //    fetchContact();
  //   setState(() {
  //     isg=true;
  //   });
  //
  //  }
  //  else{
  //    await Permission.contacts.request();
  //    if( await Permission.contacts.isGranted){
  //      fetchContact();
  //       setState(() {
  //         isg=true;
  //       });
  //
  //    }
  //
  //
  //  }
  //
  // }
  // void fetchContact()async {
  //   contacts=await ContactsService.getContacts();
  // }

  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title:  Text('people'),
      ),

      // body:isg?Center(child: Container(child:Text('please restart the app and provide the permission to continue'),)):isloading?CircularProgressIndicator():ListView.builder(
      //     itemCount: contacts.length,
      //     itemBuilder:(context,index)=>ListTile(title: Text(contacts[index].displayName!),) )
    );
  }
}
