import 'package:beautiful_puzzle/models/leaderboard_item.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/leaderboard/leaderboard.bloc.dart';
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
        if (sList.data == null) {
          return const SizedBox();
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return _listItem(
              id: index,
              name: item.username,
              time: item.time,
            );
          },
        );
      },
    );

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          Text('Leaderboard'),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
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
          Expanded(child: list),
        ],
      ),
    );
  }

  Widget _titleText({required String text}) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _listItem({required int id, required String name, required int time}) {
    return Container(
      color: Colors.blueGrey,
      child: Row(
        children: [
          Text('$id'),
          Text('$name'),
          Text('$time'),
        ],
      ),
    );
  }
}
