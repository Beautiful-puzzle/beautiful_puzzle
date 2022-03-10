import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/main.bloc.dart';
import 'package:beautiful_puzzle/models/player.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/repositories/rooms/rooms.repository.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room_list/rooms_list.bloc.dart';
import 'package:beautiful_puzzle/ui/widgets/shimmer.widget.dart';
import 'package:beautiful_puzzle/utils/bloc.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
import 'package:beautiful_puzzle/utils/simple_code.dart';
import 'package:flutter/material.dart';

class RoomArgs {
  final RoomModel room;

  RoomArgs(this.room);
}

class RoomAwaitScreen extends StatelessWidget {
  const RoomAwaitScreen({Key? key, required this.args}) : super(key: key);

  static const String routeName = '/room_await';

  static void navigate(BuildContext context, RoomArgs args) {
    Navigator.of(context).pushNamed(routeName, arguments: args);
  }

  final RoomArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      blocBuilder: () {
        final bloc = RoomBloc(
          roomsRepository: RoomsRepository.of(context),
          room: args.room,
        )..setRoomStream();
        return bloc;
      },
      builder: (context, bloc) {
        return const _Screen();
      },
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({Key? key}) : super(key: key);

  @override
  State<_Screen> createState() => _RoomAwaitScreenState();
}

class _RoomAwaitScreenState extends State<_Screen> {
  @override
  void initState() {
    runAfterBuild((_) {
      RoomBloc.of(context).addPlayer(name: MainBloc.of(context).username);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = RoomBloc.of(context);

    final startButton = RxBuilder<Player?>(
      stream: bloc.player,
      builder: (_, sPlayer) {
        final isReady = sPlayer.data?.isReady ?? false;

        return AnimatedGestureDetector(
          onTap: RoomBloc.of(context).toggleIsPlayerReady,
          child: Container(
            decoration: BoxDecoration(
              color: isReady ? ColorsResource.primary : ColorsResource.shade,
              borderRadius: BorderRadius.circular(100.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
            child: Text(
              'Start',
              style: TextStyle(
                color: ColorsResource.surface,
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );

    return WillPopScope(
      onWillPop: () {
        final bloc = RoomBloc.of(context);
        if (bloc.roomStream.value!.players.length <= 1) {
          bloc.removeRoom();
        } else {
          bloc.removePlayer();
        }

        return Future.value(true);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              Text('Room name: ${bloc.room.name}'),
              Text('Room password: ${bloc.room.password}'),
              const Spacer(),
              _playerList(),
              const Spacer(),
              startButton,
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playerList() {
    return RxBuilder<RoomModel?>(
      stream: RoomBloc.of(context).roomStream,
      builder: (_, sRoom) {
        final list = sRoom.data?.players;

        return ListView.builder(
          itemCount: list?.length ?? 4,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (list == null) return _listItem(context);

            if (list[index].name == RoomBloc.of(context).player.value!.name) return const SizedBox();

            final item = list[index];
            return _listItem(
              context,
              id: index + 1,
              name: item.name,
              isReady: item.isReady,
              onTap: () {},
            );
          },
        );
      },
    );
  }

  Widget _listItem(
    BuildContext context, {
    int? id,
    String? name,
    bool? isReady,
    VoidCallback? onTap,
  }) {
    final item = AnimatedGestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsResource.shade,
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          //horizontal: 20,
        ),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text('$id')),
            Expanded(flex: 3, child: Text('$name')),
            Expanded(flex: 2, child: Text('isReady: $isReady')),
          ],
        ),
      ),
    );

    if (id == null || name == null) {
      return ShimmerWidget(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 15 + 8,
            horizontal: 20,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            //horizontal: 20,
          ),
        ),
      );
    }
    return item;
  }
}
