import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:rxdart/rxdart.dart';

class RoomsListBloc extends Bloc {
  RoomsListBloc({
    required this.roomsRepository,
  });

  String? lateGeneratedRoomName;
  final RoomsRepository roomsRepository;

  ValueStream<List<RoomModel>?> get roomsList => roomsRepository.rooms;

  Future<void> updateData() async {
    await getRooms();
  }

  Future<Response<bool>> setRoomsStream() async {
    final result = await roomsRepository.setRoomsStream();

    return Response.value(!result.hasError);
  }

  Future<Response<bool>> getRooms() async {
    final result = await roomsRepository.getRooms();

    return Response.value(!result.hasError);
  }

  Future<Response<bool>> addRoom({
    required String name,
    required String password,
  }) async {
    final result = await roomsRepository.addRoom(
      RoomModel(name: name, password: password),
    );

    return Response.value(!result.hasError);
  }

  static RoomsListBloc of(BuildContext context) =>
      ProviderService.of<RoomsListBloc>(context);

  String generateRoomName() => lateGeneratedRoomName = randomAlphaNumeric(6);
}
