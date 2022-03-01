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
  final _leaderboardList =
      BehaviorSubject<List<LeaderboardModel>?>.seeded(null);

  ValueStream<List<LeaderboardModel>?> get leaderboardList => _leaderboardList;

  Future<void> updateData() async {
    await getLeaderboard();
  }

  Future<Response<bool>> getLeaderboard() async {
    final result = await leaderboardRepository.getLeaderBoard();

    if (!result.hasError && result.value != null) {
      _leaderboardList.add(result.value);
    }
    return Response.value(!result.hasError);
  }

  @override
  void dispose() {
    _leaderboardList.close();
    super.dispose();
  }

  static LeaderboardBloc of(BuildContext context) =>
      ProviderService.of<LeaderboardBloc>(context);
}
