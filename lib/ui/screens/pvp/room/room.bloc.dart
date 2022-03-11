import 'dart:async';

import 'package:beautiful_puzzle/models/player.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RoomBloc extends Bloc {
  RoomBloc({
    required this.roomsRepository,
    required this.room,
  }) {
    roomStream.listen((value) {
      if (_isAllPlayersReady()) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  final RoomsRepository roomsRepository;

  final RoomModel room;
  Timer? timer;

  final _room = BehaviorSubject<RoomModel?>.seeded(null);
  final _player = BehaviorSubject<Player?>.seeded(null);
  final _timerValue = BehaviorSubject<int>.seeded(4);

  ValueStream<RoomModel?> get roomStream => _room;
  ValueStream<Player?> get player => _player;
  ValueStream<int?> get timerValue => _timerValue;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_timerValue.value == 0) {
        timer.cancel();
        return;
      }

      if (!_timerValue.isClosed) {
        _timerValue.add(--_timerValue.value);
      }
    });
  }
  void _stopTimer() {
    _timerValue.add(4);
    timer?.cancel();
  }

  bool _isAllPlayersReady() {
    var isReady = true;

    if(roomStream.value == null) return false;

    for(final player in roomStream.value!.players) {
      if(player.isReady == false) {
        isReady = false;
        break;
      }
    }

    return isReady;
  }

  void toggleIsPlayerReady() {
    _player.add(_player.value!
      ..isReady = !_player.value!.isReady);

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
    _timerValue.close();

    super.dispose();
  }

  static RoomBloc of(BuildContext context) =>
      ProviderService.of<RoomBloc>(context);
}
