import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../Models/groups.dart';

class GroupsRemoteServices{
  final reference= FirebaseFirestore.instance;

  Future<Group>getSingleGroup(String id)async{
    final docsnap= await reference.collection('groups')
    .doc(id).get()
    .catchError((e)=>throw Exception("$e"));
    return Group.fromJson(docsnap.data()!);
  }
}