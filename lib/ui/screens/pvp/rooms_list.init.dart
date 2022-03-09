import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/rooms_list.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/rooms_list.screen.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:flutter/material.dart';

class RoomsListInit extends StatelessWidget {
  const RoomsListInit({Key? key}) : super(key: key);

  static const String routeName = '/rooms';

  static void navigate(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      blocBuilder: () {
        final bloc = RoomsListBloc(
          roomsRepository: RoomsRepository.of(context),
        );
        return bloc..setRoomsStream();
      },
      builder: (context, bloc) {
        return const RoomsListScreen();
      },
    );
  }
}
