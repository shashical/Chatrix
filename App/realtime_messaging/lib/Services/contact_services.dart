import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_app/restart_app.dart';

import '../main.dart';

class ContactServices{
  List<Contact> contacts = [];
  Set<String> helper = {};
  void getContactPermission(BuildContext context) async {
    if (await Permission.contacts.isGranted) {
      fetchContact();

    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        fetchContact();

      }
      else{
        showDialog(context: context, builder: (context)=> AlertDialog(
          title: Text('Permission Required !',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),),
          content: Text('Please restart your app  and provide permission to continue'),
          actions: [
            ElevatedButton(
                onPressed: (){
             Restart.restartApp();
            },
                child: Text('Ok restart')
            )
          ],
        ));
      }
    }
  }
  void fetchContact() async {
    contacts = await FlutterContacts.getContacts(withProperties: true);

      for (int i = 0; i < contacts.length; i++) {
        int a = helper.length;
        if (contacts[i].phones.isNotEmpty) {
          if(!contacts[i].phones[0].normalizedNumber.startsWith('+91')){
            contacts[i].phones[0].normalizedNumber='+91${contacts[i].phones[0].normalizedNumber}';
          }
          helper.add(contacts[i].phones[0].normalizedNumber);
          if (helper.length > a) {
            savedNumber.add(contacts[i].phones[0].normalizedNumber);
            savedUsers.add(contacts[i].displayName);
          }
        }
      }
      debugPrint("${savedUsers.length}");
      debugPrint('${savedNumber.length}');

  }
}