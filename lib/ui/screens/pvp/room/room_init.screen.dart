import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room_await.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/router.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:flutter/material.dart';

class RoomInitScreen extends StatelessWidget {
  const RoomInitScreen({Key? key, required this.args}) : super(key: key);

  static const String routeName = '/room_init';

  static void navigate(BuildContext context, RoomArgs args) {
    Navigator.of(context).pushNamed(routeName, arguments: args);
  }

  final RoomArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      blocBuilder: () {
        final bloc = RoomBloc(
          roomsRepository: RoomsRepository.of(context),
          room: args.room,
        )..setRoomStream();
        return bloc;
      },
      builder: (context, bloc) {
        return RoomRouter(args: args);
      },
    );
  }
}