import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard.bloc.dart';
import 'package:beautiful_puzzle/ui/widgets/animated_swap.widget.dart';
import 'package:beautiful_puzzle/ui/widgets/refresh_indicator.widget.dart';
import 'package:beautiful_puzzle/ui/widgets/shimmer.widget.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
import 'package:flutter/material.dart';

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final list = RxBuilder<List<LeaderboardModel>?>(
      stream: LeaderboardBloc.of(context).leaderboardList,
      builder: (context, sList) {
        final list = sList.data ?? [];

        return AnimatedSwapWidget(
          child: RefreshIndicatorWidget(
            onRefresh: LeaderboardBloc.of(context).updateData,
            child: ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = list[index];
                return _listItem(
                  id: index,
                  name: item.username,
                  time: item.time,
                );
              },
            ),
          ),
          child1: ListView.builder(
            itemCount: 20,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return _listItem();
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
                    onRefresh: LeaderboardBloc.of(context).updateData,
                    child: list,
                  ),
                ),
              ],
            ),
          ],
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

  Widget _listItem({
    int? id,
    String? name,
    int? time,
  }) {
    final item = Container(
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
          Expanded(flex: 1, child: Text('$time')),
        ],
      ),
    );

    if (id == null || name == null || time == null) {
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
