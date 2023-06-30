
import 'package:file_picker/file_picker.dart';

import '../Models/chatMessages.dart';
import '../Models/chats.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
class ChatsRemoteServices {
  final reference = FirebaseFirestore.instance;

  Future<Chat> getSingleChat(String id) async {
    final docsnap = await reference
        .collection('chats')
        .doc(id)
        .get()
        .catchError((e) => throw Exception('$e'));
    return Chat.fromJson(docsnap.data()!);
  }

  Stream<List<ChatMessage>> getChatMessages(String id) {
    return reference.collection('chats/$id/chatMessages').snapshots().map(
        (event) =>
            event.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList());
  }

  Future<void> setChat(Chat chat) async {
    final DocumentSnapshot docSnap =
        await reference.collection('chats').doc(chat.id).get();
    if (!docSnap.exists) {
      try {
        reference
            .collection('chats')
            .doc(chat.id)
            .set(chat.toJson())
            .catchError((e) => throw Exception('$e'));
      } on FirebaseException catch (e) {
        throw Exception('$e');
      } catch (e) {
        rethrow;
      }
    }
  }
  Future<void> updateChatMessage(String id, Map<String, dynamic> upd,String messageId) async {
    try {
      reference
          .collection('chats')
          .doc(id).collection('chatMessages').doc(messageId)
          .update(upd)
          .catchError((e) => throw Exception('$e'));
    } on FirebaseException catch (e) {
      throw Exception('$e');
    } catch (e) {
      rethrow;
    }
  }
  Future<void> deleteSingleChatMessage(String id,String messageId)async {
    try {
      FirebaseFirestore.instance.collection('chats').doc(id).collection('chatMessages').doc(messageId).delete()
          .catchError((e) => throw Exception('$e'));
    }catch(e){
      rethrow;
    }
  }

  Future<void> setChatMessage(String chatId, ChatMessage chatmessage) async {
    final DocumentSnapshot docSnap = await reference
        .collection("chats/$chatId/chatMessages")
        .doc(chatmessage.id)
        .get();
    if (!docSnap.exists) {
      try {
        reference
            .collection("chats/$chatId/chatMessages")
            .doc(chatmessage.id)
            .set(chatmessage.toJson())
            .catchError((e) => throw Exception("$e"));
      } on FirebaseException catch (e) {
        throw Exception("$e");
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteAllChatMessages(String chatid)async{
    try{
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').doc(chatid).collection('chatMessages').get();
                        final batch = FirebaseFirestore.instance.batch();

                        querySnapshot.docs.forEach((documentSnapshot) {
                          batch.delete(documentSnapshot.reference);
                        });

                        await batch.commit();
                      }
                      catch(e){
                        throw Exception("$e");
                      }
  }

  Future<void> deleteAllChatMessagesForMe(String cid, String chatid)async{
    try{
                        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').doc(chatid).collection('chatMessages').get();
                        final batch = FirebaseFirestore.instance.batch();

                        querySnapshot.docs.forEach((documentSnapshot) {
                          batch.update(documentSnapshot.reference,
                            {'deletedForMe.$cid' : true}
                          );
                        });

                        await batch.commit();
                      }
                      catch(e){
                        throw Exception("$e");
                      }
  }
 firebase_storage.UploadTask createUploadTask(File doc,String name){
   firebase_storage.Reference ref =
   firebase_storage.FirebaseStorage.instance.ref('/documents/$name');
   firebase_storage.UploadTask uploadTask = ref.putFile(doc.absolute);
   return uploadTask;
 }

  Future<String> uploadDocument(File doc,String name) async {
    try {
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('/documents/${name}');
     final uploadTask=createUploadTask(doc,name);
      await Future.value(uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    } catch (e) {
      rethrow;
    }
  }
  Future<FilePickerResult?> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {

      return result;
    } else {
      return null;
    }
  }
  // Future<bool>checkChat(String chatId)async{
  //   final DocumentSnapshot docSnap =
  //       await reference.collection('chats').doc(chatId).get();
  //   if(docSnap.exists){
  //     return true;
  //   }
  //   else{
  //     return false;
  //   }
  // }
}
