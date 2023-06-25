
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/groups.dart';

class GroupRemoteServices{
    final reference=FirebaseFirestore.instance;
  Future<Group> getSingleGroup(String id)async{
    final  docSnapshot= await reference.collection('groups').doc(id).get().catchError((e)=>throw Exception('$e'));
    if(docSnapshot.exists){
      return Group.fromJson(docSnapshot.data()!);
    }
    throw Exception('document does not id');



  }

}