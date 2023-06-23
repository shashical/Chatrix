
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/users.dart';

class RemoteServices{
  final reference=FirebaseFirestore.instance;
  Stream<List<Users>>getUsers(){
    return reference.collection('user').snapshots().map((snapshot) => snapshot
        .docs.map((doc) => Users.Fromjson(doc.data())).toList()
    );
  }
  Future<Users?> getSinleUser(String id)async{
     final docsnap=await reference.collection('user').doc(id).get();

     if( docsnap.exists){
       return Users.Fromjson(docsnap.data()!);
     }
     return null;

  }
  Future<void>setUsers(Users user) async{
    final DocumentSnapshot docsnap=await reference.collection('user').doc(user.id).get();
    if(!docsnap.exists)
      {
        try{

          reference.collection('user').doc(user.id).set(user.Tojson()).catchError((e)=>
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
        reference.collection('user').doc(id).update(upd).catchError((e)=>
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
}