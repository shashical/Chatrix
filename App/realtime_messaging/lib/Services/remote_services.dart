
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/userChats.dart';

import '../Models/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class RemoteServices{
  final reference=FirebaseFirestore.instance;
  Stream<List<Users>>getUsers(){
    return reference.collection('users').snapshots().map((snapshot) => snapshot
        .docs.map((doc) => Users.fromJson(doc.data())).toList()
    );
  }
  Future<Users?> getSingleUser(String id)async{
     final docsnap=await reference.collection('users').doc(id).get().catchError((e)=>throw Exception('$e'));

     if( docsnap.exists){
       return Users.fromJson(docsnap.data()!);
     }
     return null;

  }

  Stream<List<UserChat>>getUserChats(String id){
    return reference.collection('users/$id/userChats').snapshots().map((event) => 
    event.docs.map((doc) => UserChat.fromJson(doc.data())).toList()
    );
  }

  Future<Chat> getSingleChat(String id)async{
    final docsnap = await reference.collection('chats').doc(id).get().catchError((e)=>throw Exception('$e'));
    return Chat.fromJson(docsnap.data()!);
  }

  Future<void>setUsers(Users user) async{
    final DocumentSnapshot docSnap=await reference.collection('users').doc(user.id).get();
    if(!docSnap.exists)
      {
        try{

          reference.collection('users').doc(user.id).set(user.toJson()).catchError((e)=>
          throw Exception('$e'));
          }on FirebaseException catch(e){
          throw Exception('$e');
        }catch(e){
          rethrow;
        }
      }


  }
  Future<void> updateUser(String id,Map<String,dynamic> upd)async{
    try{
        reference.collection('users').doc(id).update(upd).catchError((e)=>
        throw Exception('$e'));
    }
    on FirebaseException catch(e){
      throw Exception('$e');
    }
    catch(e){
      rethrow;
    }
  }

  Future<bool> doesDocumentExist(String documentPath) async {
    final DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.doc(documentPath).get();

    return documentSnapshot.exists;
  }

  Future<dynamic> getDocumentField(String documentPath, String fieldName)async{

    final DocumentSnapshot documentSnapshot = await reference.doc(documentPath).get();

    if(documentSnapshot.exists){
      return documentSnapshot.get(fieldName);
    }
    else{
      throw Exception("Document does not exist.");
    }
  }
  Future<String> uploadNewImage(File _image,String id)async{
    try {
      firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance.ref(
          '/Profile_images/$id');
      firebase_storage.UploadTask uploadTask = ref.putFile(
          _image.absolute);
      await Future.value(uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    }catch(e){
      rethrow;
    }
  }
}