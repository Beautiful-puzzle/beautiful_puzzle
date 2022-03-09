import 'dart:convert';

import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/base/remote_realtime.repository.dart';

// TODO: find better decision without 'ignore: avoid_dynamic_calls' and doble convertation
class NetworkRoomsRepository {
  final _repo = RemoteRealtimeRepository();

  Stream<List<RoomModel>?> setRoomsStream() {
    return _repo.getRef('rooms').onValue.map((event) {
      //ignore: avoid_dynamic_calls
      final parsedList = jsonDecode(jsonEncode(event.snapshot.value)).values.toList() as List<dynamic>;

      //ignore: avoid_dynamic_calls
      final result = <RoomModel>[];

      //ignore: avoid_dynamic_calls
      for (final e in parsedList) {
        result.add(RoomModel.fromJson(e as Map<String, dynamic>));
      }

      return result;
    });
  }

  Future<List<RoomModel>?> getRooms() async {
    final response = await _repo.getRef('rooms').get();

    //ignore: avoid_dynamic_calls
    final parsedList = jsonDecode(jsonEncode(response.value)).values.toList() as List<dynamic>;

    //ignore: avoid_dynamic_calls
    final result = <RoomModel>[];

    //ignore: avoid_dynamic_calls
    for (final e in parsedList) {
      result.add(RoomModel.fromJson(e as Map<String, dynamic>));
    }

    return result;
  }

  Future<bool> addRoom(RoomModel room) async {
    final response = await _repo.getRef('rooms').update(room.toJson());

    return true;
  }
}
