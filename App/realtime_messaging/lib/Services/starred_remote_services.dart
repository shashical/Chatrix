
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtime_messaging/Models/starredMessages.dart';

class StarredMessageRemoteServices{
  final reference=FirebaseFirestore.instance;
  Stream<List<StarredMessage>> getStarredMessages() {
    return reference.collection('starredMessages').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => StarredMessage.fromJson(doc.data())).toList());
  }

  Future<StarredMessage?> getSingleStarredMessage(String id) async {
    final docsnap = await reference
        .collection('starredMessages')
        .doc(id)
        .get()
        .catchError((e) => throw Exception('$e'));

    if (docsnap.exists) {
      return StarredMessage.fromJson(docsnap.data()!);
    }
    return null;
  }

  Future<void> setStarredMessage(StarredMessage starredMessage) async {
    final DocumentSnapshot docSnap =
    await reference.collection('starredMessages').doc(starredMessage.id).get();
    if (!docSnap.exists) {
      try {
        reference
            .collection('starredMessages')
            .doc(starredMessage.id)
            .set(starredMessage.toJson())
            .catchError((e) => throw Exception('$e'));
      } on FirebaseException catch (e) {
        throw Exception('$e');
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> updateStarredMessage(String id, Map<String, dynamic> upd) async {
    try {
      reference
          .collection('starredMessages')
          .doc(id)
          .update(upd)
          .catchError((e) => throw Exception('$e'));
    } on FirebaseException catch (e) {
      throw Exception('$e');
    } catch (e) {
      rethrow;
    }
  }

}