import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Models/userGroups.dart';
import '../Models/users.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class RemoteServices{
  final reference=FirebaseFirestore.instance;
  //users
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
  //UserChat


  Stream<List<UserChat>>getUserChats(String id){
    return reference.collection('users/$id/userChats').snapshots().map((event) => 
    event.docs.map((doc) => UserChat.fromJson(doc.data())).toList()
    );
  }
  Future<UserChat?> getSingleUserChat(String id,String userChatId)async{
    final docsnap=await reference.collection('users/$id/userChats').doc(userChatId).get().catchError((e)=>throw Exception('$e'));

    if( docsnap.exists){
      return UserChat.fromJson(docsnap.data()!);
    }
    return null;

  }

  Future<void>updateUserChat(String id,Map<String,dynamic> upd,String chatId)async {
    try{
      reference.collection('users/$id/userChat').doc(chatId).update(upd).catchError((e)=>
      throw Exception('$e'));
    }
    on FirebaseException catch(e){
      throw Exception('$e');
    }
    catch(e){
      rethrow;
    }
  }
//UserGroups
  Stream<List<UserGroup>>getUserGroups(String id){
    return reference.collection('users/$id/userGroups')
    .snapshots().map((event) => event.docs.map((doc) => UserGroup
    .fromJson(doc.data()))
    .toList()
    );
  }
  Future<UserGroup?> getSingleUserGroup(String id,String userGroupId)async{
    final docsnap=await reference.collection('users/$id/userGroups').doc(userGroupId).get().catchError((e)=>throw Exception('$e'));

    if( docsnap.exists){
      return UserGroup.fromJson(docsnap.data()!);
    }
    return null;

  }
  Future<void>updateUserGroup(String id,Map<String,dynamic> upd,String groupId)async {
    try{
      reference.collection('users/$id/userGroups').doc(groupId).update(upd).catchError((e)=>
      throw Exception('$e'));
    }
    on FirebaseException catch(e){
      throw Exception('$e');
    }
    catch(e){
      rethrow;
    }
  }




//general
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

}