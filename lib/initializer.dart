import 'package:beautiful_puzzle/repositories/leaderboard.repository.dart';
import 'package:beautiful_puzzle/repositories/leaderboard/network_leaderboard.repository.dart';
import 'package:beautiful_puzzle/utils/firebase.initializer.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';

/// App-wide initializer of all services, repositories, plugins, etc.
class Initializer extends StatefulWidget {
  /// Constructs an instance of [Initializer].
  const Initializer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {

  late LeaderboardRepository leaderboardRepository;

  @override
  void initState() {
    FirebaseInitializer.initialize();

    final networkLeaderboardRepository = NetworkLeaderboardRepository();
    leaderboardRepository = LeaderboardRepository(networkLeaderboardRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderService(
      data: <Type, dynamic>{
        LeaderboardRepository: leaderboardRepository,
      },
      builder: (context) {
        return widget.child;
      },
    );
  }
}
