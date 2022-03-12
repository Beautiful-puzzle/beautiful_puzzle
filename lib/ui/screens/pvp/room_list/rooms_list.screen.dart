import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/models/room_item.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room_await.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room_init.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room_list/rooms_list.bloc.dart';
import 'package:beautiful_puzzle/ui/widgets/animated_swap.widget.dart';
import 'package:beautiful_puzzle/ui/widgets/refresh_indicator.widget.dart';
import 'package:beautiful_puzzle/ui/widgets/shimmer.widget.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
import 'package:flutter/material.dart';

import '../widgets/enter_room.alert.dart';

class RoomsListScreen extends StatefulWidget {
  const RoomsListScreen({Key? key}) : super(key: key);

  @override
  State<RoomsListScreen> createState() => _RoomsListScreenState();
}

class _RoomsListScreenState extends State<RoomsListScreen> {
  @override
  Widget build(BuildContext context) {
    final list = RxBuilder<List<RoomModel>?>(
      stream: RoomsListBloc.of(context).roomsList,
      builder: (context, sList) {
        final list = sList.data ?? [];

        return AnimatedSwapWidget(
          child: RefreshIndicatorWidget(
            onRefresh: RoomsListBloc.of(context).updateData,
            child: ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = list[index];
                return _listItem(
                  context,
                  id: index + 1,
                  name: item.name,
                  onTap: () async {
                    final bloc = RoomsListBloc.of(context);

                    bloc.createdRoom = item;

                    final response =
                        await EnterRoomAlert.navigate(context, bloc: bloc)
                            as String?;

                    if (response == item.password) {
                      if (!mounted) return;
                      RoomInitScreen.navigate(context, RoomArgs(bloc.createdRoom!));
                    }
                  },
                );
              },
            ),
          ),
          child1: ListView.builder(
            itemCount: 20,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _listItem(context);
            },
          ),
          isFirstVisible: sList.data != null,
        );
      },
    );

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                const Text('Leaderboard'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsResource.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _titleText(text: 'Place'),
                      ),
                      Expanded(
                        flex: 3,
                        child: _titleText(text: 'Name'),
                      ),
                      Expanded(
                        flex: 1,
                        child: _titleText(text: 'Time'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicatorWidget(
                    onRefresh: RoomsListBloc.of(context).updateData,
                    child: list,
                  ),
                ),
              ],
            ),
            _addRoomButton(),
          ],
        ),
      ),
    );
  }

  Widget _addRoomButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: AnimatedGestureDetector(
        onTap: () async {
          final bloc = RoomsListBloc.of(context)..createdRoom = null;
          final response =
              await EnterRoomAlert.navigate(context, bloc: bloc) as String?;

          if (response == null) return;
          await bloc.addRoom(
            name: bloc.lateGeneratedRoomName!,
            password: response,
          );

          if (!mounted) return;
          RoomAwaitScreen.navigate(context, RoomArgs(bloc.createdRoom!));
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorsResource.primary,
            borderRadius: BorderRadius.circular(100.0),
          ),
          padding: EdgeInsets.all(20),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _titleText({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _listItem(
    BuildContext context, {
    int? id,
    String? name,
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
