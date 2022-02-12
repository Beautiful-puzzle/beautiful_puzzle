import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/game/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
import 'package:flutter/material.dart';

class GameFieldWidget extends StatefulWidget {
  const GameFieldWidget({Key? key}) : super(key: key);

  @override
  State<GameFieldWidget> createState() => _GameFieldWidgetState();
}

class _GameFieldWidgetState extends State<GameFieldWidget> {
  @override
  Widget build(BuildContext context) {
    GameFieldBloc.of(context).screenSize = MediaQuery.of(context).size;

    final field = RxBuilder<List<GameCardModel>?>(
      stream: GameFieldBloc.of(context).generatedCards,
      builder: (context, sList) {
        if (sList.data == null) {
          return const SizedBox();
        }

        return Stack(
          children: sList.data!.map((e) => GameCard(card: e)).toList(),
        );
      },
    );

    final elapsedTime = RxBuilder<int>(
      stream: GameFieldBloc.of(context).elapsedTime,
      builder: (context, sTime) {
        final time = sTime.data ?? 0;

        final seconds = time % 60;
        final minutes = time ~/ 60;
        final secondsText = seconds >= 10 ? '$seconds' : '0$seconds';
        final minutesText = minutes >= 10 ? '$minutes' : '0$minutes';
        return Text('Elapsed time: $minutesText:$secondsText');
      },
    );

    final counterText = RxBuilder<List<Map<GameCardModel, GameCardModel>>>(
      stream: GameFieldBloc.of(context).movesLogs,
      builder: (_, sLogs) {
        final count = sLogs.data?.length ?? 0;
        return Text(
          'Slides count: $count',
          style: TextStyle(
            fontSize: 20,
            color: ColorsResource.background,
          ),
        );
      },
    );

    final shuffleButton = AnimatedGestureDetector(
      onTap: () => GameFieldBloc.of(context).shuffle(),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsResource.primary,
          borderRadius: BorderRadius.circular(100.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        child: Text(
          'Shuffle',
          style: TextStyle(
            color: ColorsResource.surface,
            fontSize: 20,
          ),
        ),
      ),
    );

    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 20,
          child: Column(
            children: [
              counterText,
              const SizedBox(height: 20),
              elapsedTime,
              const SizedBox(height: 20),
              shuffleButton,
            ],
          ),
        ),
        Center(
          child: Container(
            color: ColorsResource.secondary,
            height: GameFieldBloc.of(context).fieldSize.height,
            width: GameFieldBloc.of(context).fieldSize.width,
            child: field,
          ),
        ),
      ],
    );
  }
}
