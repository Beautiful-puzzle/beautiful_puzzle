import 'package:beautiful_puzzle/repositories/leaderboard/leaderboard.repository.dart';
import 'package:beautiful_puzzle/repositories/leaderboard/network_leaderboard.repository.dart';
import 'package:beautiful_puzzle/repositories/rooms/network_rooms.repository.dart';
import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/utils/firebase.initializer.dart';
import 'package:beautiful_puzzle/utils/provider.service.dart';
import 'package:flutter/material.dart';

typedef InitializationBuilder = Widget Function(
  BuildContext context,
  String initialRoute,
);

/// App-wide initializer of all services, repositories, plugins, etc.
class Initializer extends StatefulWidget {
  /// Constructs an instance of [Initializer].
  const Initializer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final InitializationBuilder builder;

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  late LeaderboardRepository leaderboardRepository;
  late RoomsRepository roomsRepository;

  @override
  void initState() {
    FirebaseInitializer.initialize();

    final networkLeaderboardRepository = NetworkLeaderboardRepository();
    leaderboardRepository = LeaderboardRepository(networkLeaderboardRepository);

    final networkRoomsRepository = NetworkRoomsRepository();
    roomsRepository = RoomsRepository(networkRoomsRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderService(
      data: <Type, dynamic>{
        LeaderboardRepository: leaderboardRepository,
        RoomsRepository: roomsRepository,
      },
      builder: (context) {
        return widget.builder(context, '/');
      },
    );
  }
}
