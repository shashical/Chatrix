import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import '../Models/groups.dart';

class GroupsRemoteServices{
  final reference= FirebaseFirestore.instance;

  Future<Group>getSingleGroup(String id)async{
    final docsnap= await reference.collection('groups')
    .doc(id).get()
    .catchError((e)=>throw Exception("$e"));
    if(docsnap.exists) {
      return Group.fromJson(docsnap.data()!);
    }
    throw Exception('Document does not exists');
  }
  Future<void> updateUser(String id,Map<String,dynamic> upd)async{
    try{
      reference.collection('groups').doc(id).update(upd).catchError((e)=>
      throw Exception('$e'));
    }
    on FirebaseException catch(e){
      throw Exception('$e');
    }
    catch(e){
      rethrow;
    }
  }

  Future<String> uploadNewImage(File image,String id)async{
    try {
      firebase_storage.Reference ref = firebase_storage
          .FirebaseStorage.instance.ref(
          '/Group_images/$id');
      firebase_storage.UploadTask uploadTask = ref.putFile(
          image.absolute);
      await Future.value(uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    }catch(e){
      rethrow;
    }
  }
}