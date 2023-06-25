import '../Models/chats.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ChatsRemoteServices{
  final reference= FirebaseFirestore.instance;

  Future<Chat> getSingleChat(String id)async{
    final docsnap = await reference.collection('chats').doc(id).get().catchError((e)=>throw Exception('$e'));
    return Chat.fromJson(docsnap.data()!);
  }
}