
import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/repositories/leaderboard/leaderboard.repository.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class MainBloc extends Bloc {
  MainBloc({
    required this.leaderboardRepository,
  });

  final String username = 'Test player${DateTime.now().millisecondsSinceEpoch}';
  final LeaderboardRepository leaderboardRepository;

  ValueStream<List<LeaderboardModel>?> get leaderboardList =>
      leaderboardRepository.leaders;

  Future<Response<bool>> addLeader({
    required String username,
    required int slides,
    required int time,
  }) async {
    final model = LeaderboardModel(
      username: username,
      time: time,
      slides: slides,
    );

    final result = await leaderboardRepository.addLeader(model);

    return Response.value(!result.hasError);
  }

  static MainBloc of(BuildContext context) =>
      ProviderService.of<MainBloc>(context);
}
