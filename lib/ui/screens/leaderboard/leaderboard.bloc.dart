import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class LeaderboardBloc extends Bloc {

  LeaderboardBloc() {
    _tempLeaders();
  }
  final _leaderboardList = BehaviorSubject<List<LeaderboardModel>?>.seeded(
      null);

  ValueStream<List<LeaderboardModel>?> get leaderboardList => _leaderboardList;

  Future<void> updateData() async {
    await _tempLeaders();
  }
  Future<void> _tempLeaders() async {
    await Future.delayed(Duration(seconds: 1));
    _leaderboardList
        .add(List.generate(15, (index) => LeaderboardModel(time: 0, slides: 0, username: "name"),)
    );
  }

  @override
  void dispose() {
    _leaderboardList.close();
    super.dispose();
  }

  static LeaderboardBloc of(BuildContext context) =>
      ProviderService.of<LeaderboardBloc>(context);
}