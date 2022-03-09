import 'package:firebase_database/firebase_database.dart';

class RemoteRealtimeRepository {
  Stream<DatabaseEvent> getData(String path) {
    return FirebaseDatabase.instance.ref(path).onValue;
  }

  DatabaseReference getRef(String path) {
    return FirebaseDatabase.instance.ref('/$path');
  }

  Stream<DatabaseEvent> setData(String path, Map<String, dynamic> data) {
    return FirebaseDatabase.instance.ref(path).onValue;
  }
}
