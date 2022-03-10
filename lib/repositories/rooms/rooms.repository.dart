import 'dart:async';

import 'package:beautiful_puzzle/models/errors/error.dart';
import 'package:beautiful_puzzle/models/errors/server_errors.dart';
import 'package:beautiful_puzzle/models/player.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/rooms/network_rooms.repository.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class RoomsRepository {
  RoomsRepository(this._networkRepo) : super();

  final NetworkRoomsRepository _networkRepo;

  final _rooms = BehaviorSubject<List<RoomModel>?>.seeded(null);

  ValueStream<List<RoomModel>?> get rooms => _rooms;

  Future<Response<bool>> setRoomsStream() async {
    try {
      _networkRepo.setRoomsStream().listen((list) {
        updateList(list ?? []);
      });

      return const Response.value(true);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }

  Future<Response<List<RoomModel>>> getRooms() async {
    try {
      final info = await _networkRepo.getRooms();

      if (info != null) {
        updateList(info);
      }

      return Response.value(info);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }

  Future<Response<bool>> addRoom(RoomModel room) async {
    try {
      final info = await _networkRepo.addRoom(room);

      return const Response.value(true);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }

  Future<Response<bool>> removeRoom(String roomName) async {
    try {
      final info = await _networkRepo.removeRoom(roomName);

      return const Response.value(true);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }
  Future<Response<bool>> removePlayer(String roomName, String username) async {
    try {
      final info = await _networkRepo.removePlayer(roomName, username);

      return const Response.value(true);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }

  Future<Response<bool>> addPlayer(String roomName, Player player) async {
    try {
      final info = await _networkRepo.addPlayer(roomName, player);

      return const Response.value(true);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }

  ValueStream<RoomModel?> getRoomStream(String roomName) {
    final _stream = BehaviorSubject<RoomModel?>.seeded(null);

    _networkRepo.getRoomStream(roomName).listen(_stream.add);

    return _stream;
  }

  void updateList(List<RoomModel>? list) {
    _rooms.add(list);
  }

  /// Cleans resources.
  void dispose() {
    _rooms.close();
  }

  static RoomsRepository of(BuildContext context) =>
      ProviderService.of<RoomsRepository>(context);
}
