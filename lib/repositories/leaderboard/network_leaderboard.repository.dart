import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/repositories/base/remote_static.repository.dart';

/// Network implementation of feed repository.
class NetworkLeaderboardRepository {
  final _repo = RemoteStaticRepository();

  Future<List<LeaderboardModel>> getLeaderboard() async {
    final response = await _repo.getCollection('leaderboard').get();

    final result = response.docs
        .map((e) => LeaderboardModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    return result;
  }
}
