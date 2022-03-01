import 'dart:async';

import 'package:beautiful_puzzle/models/errors/error.dart';
import 'package:beautiful_puzzle/models/errors/server_errors.dart';
import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/models/response.dart';
import 'package:beautiful_puzzle/repositories/leaderboard/network_leaderboard.repository.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class LeaderboardRepository {
  LeaderboardRepository(this._networkRepo) : super();

  final NetworkLeaderboardRepository _networkRepo;

  final _leaders = BehaviorSubject<List<LeaderboardModel>?>.seeded(null);
  ValueStream<List<LeaderboardModel>?> get hubContacts => _leaders;

  Future<Response<List<LeaderboardModel>>> getLeaderBoard() async {
    try {
      final info = await _networkRepo.getLeaderboard();

      return Response.value(info);
    } on ServerError catch (e) {
      return Response.error(BaseError.fromDynamic(e));
    }
  }

  /// Cleans resources.
  void dispose() {
    _leaders.close();
  }

  static LeaderboardRepository of(BuildContext context) =>
      ProviderService.of<LeaderboardRepository>(context);
}
