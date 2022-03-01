import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteStaticRepository {

  Future<DocumentSnapshot> getDocument(String collection, String documentId) {
    return getCollection(collection).doc(documentId).get();
  }

  CollectionReference getCollection(String collection) {
    return FirebaseFirestore.instance.collection(collection);
  }
}