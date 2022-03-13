import 'dart:async';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/models/player.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class RoomBloc extends Bloc {
  RoomBloc({
    required this.roomsRepository,
    required this.room,
  }) {
    roomStream.listen((value) {
      _mate.add(value?.players
          .firstWhereOrNull((element) => element.name != _player.value?.name));
      if (_isAllPlayersReady()) {
        _startTimer();
      } else {
        _stopTimer();
      }

      _mate.listen((value) {
        if(value != null) isGameCompleted();
      });
    });
  }

  final RoomsRepository roomsRepository;

  final RoomModel room;
  Timer? timer;

  final _room = BehaviorSubject<RoomModel?>.seeded(null);
  final _player = BehaviorSubject<Player?>.seeded(null);
  final _mate = BehaviorSubject<Player?>.seeded(null);
  final _timerValue = BehaviorSubject<int>.seeded(4);
  final _isMateGameComplete = BehaviorSubject<bool>.seeded(false);

  ValueStream<RoomModel?> get roomStream => _room;

  ValueStream<Player?> get player => _player;
  ValueStream<Player?> get mate => _mate;
  ValueStream<int?> get timerValue => _timerValue;
  ValueStream<bool> get isMateGameComplete => _isMateGameComplete;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerValue.value == 0) {
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

    if (roomStream.value == null) return false;

    for (final player in roomStream.value!.players) {
      if (player.isReady == false) {
        isReady = false;
        break;
      }
    }

    return isReady;
  }

  void isGameCompleted() {
    var isCompleted = false;
    for (final element in _mate.value!.movesLogs) {
      if (element.id == -1) continue;

      isCompleted = element.id == element.position + 1;

      if (element.id != element.position + 1) break;
    }

    if (isCompleted != _isMateGameComplete.value) {
      _isMateGameComplete.add(isCompleted);
    }
  }

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

  void updateMovesLogs(List<GameCardModel> list) {
    _player.add(_player.value!..movesLogs = list);

    addPlayer(name: _player.value!.name);
  }

  @override
  void dispose() {
    _room.close();
    _player.close();
    _timerValue.close();
    _mate.close();
    _isMateGameComplete.close();

    super.dispose();
  }

  static RoomBloc of(BuildContext context) =>
      ProviderService.of<RoomBloc>(context);
}
