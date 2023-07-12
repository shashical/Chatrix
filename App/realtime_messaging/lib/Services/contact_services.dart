import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class ContactServices{
  List<Contact> contacts = [];
  Set<String> helper = {};
  Future<void> getContactPermission(BuildContext context) async {
    if (await Permission.contacts.isGranted) {
      fetchContact();

    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        fetchContact();

      }
      else  {


        await showDialog(context: context, builder: (context)=> AlertDialog(
          title:  Text('Permission Required !',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
          ),),
          content: const Text('Please allow permission to continue'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
             Navigator.of(context,rootNavigator:true).pop();
            },
                child: const Text('Open Settings')
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