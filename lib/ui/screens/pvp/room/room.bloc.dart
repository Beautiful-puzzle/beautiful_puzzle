import 'package:beautiful_puzzle/models/player.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:rxdart/rxdart.dart';

class RoomBloc extends Bloc {
  RoomBloc({
    required this.roomsRepository,
    required this.room,
  });

  final RoomsRepository roomsRepository;

  final RoomModel room;

  final _room = BehaviorSubject<RoomModel?>.seeded(null);
  final _player = BehaviorSubject<Player?>.seeded(null);

  ValueStream<RoomModel?> get roomStream => _room;

  ValueStream<Player?> get player => _player;

  void toggleIsPlayerReady() {
    _player.add(_player.value!..isReady = !_player.value!.isReady);

    addPlayer(name: _player.value!.name);
  }

  Future<Response<bool>> addPlayer({
    required String name,
  }) async {
    if (_player.value == null) {
      _player.add(Player(name: name));
    }

    final result = await roomsRepository.addPlayer(
      room.name,
      _player.value!,
    );

    return Response.value(!result.hasError);
  }

  void setRoomStream() {
    roomsRepository.getRoomStream(room.name).listen(_room.add);
  }

  Future<Response<bool>> removeRoom() async {
    final result = await roomsRepository.removeRoom(room.name);

    return Response.value(!result.hasError);
  }

  Future<Response<bool>> removePlayer() async {
    final result =
        await roomsRepository.removePlayer(room.name, _player.value!.name);

    return Response.value(!result.hasError);
  }

  @override
  void dispose() {
    _room.close();
    _player.close();

    super.dispose();
  }

  static RoomBloc of(BuildContext context) =>
      ProviderService.of<RoomBloc>(context);
}
