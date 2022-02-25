import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard.screen.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:flutter/material.dart';

class LeaderBoardInit extends StatelessWidget {
  const LeaderBoardInit({Key? key}) : super(key: key);

  static const String routeName = '/leaderboard';

  static void navigate(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      blocBuilder: () {
        return LeaderboardBloc();
      },
      builder: (context, bloc) {
        return const LeaderBoardScreen();
      },
    );
  }
}
