import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({super.key});
  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  List<Contact> contacts = [];
  bool isg = false;
  bool isloading = false;
  bool contactsFetched = false; 

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  @override
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
          : isloading
              ? CircularProgressIndicator()
              : contactsFetched 
                  ? ListView.builder(
                      itemCount: contacts.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(contacts[index].displayName),
                      ),
                    )
                  : Container(), 
    );
  }
}