import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/repositories/leaderboard.repository.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LeaderboardBloc extends Bloc {
  LeaderboardBloc({
    required this.leaderboardRepository,
  });

  final LeaderboardRepository leaderboardRepository;

  ValueStream<List<LeaderboardModel>?> get leaderboardList => leaderboardRepository.leaders;

  Future<void> updateData() async {
    await getLeaderboard();
  }

  Future<Response<bool>> getLeaderboard() async {
    final result = await leaderboardRepository.getLeaderBoard();

    return Response.value(!result.hasError);
  }

  static LeaderboardBloc of(BuildContext context) =>
      ProviderService.of<LeaderboardBloc>(context);
}
