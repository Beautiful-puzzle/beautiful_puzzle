import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/game/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
import 'package:beautiful_puzzle/utils/screen.data.dart';
import 'package:beautiful_puzzle/utils/time.dart';
import 'package:flutter/material.dart';

class GameFieldWidget extends StatefulWidget {
  const GameFieldWidget({Key? key}) : super(key: key);

  @override
  State<GameFieldWidget> createState() => _GameFieldWidgetState();
}

class _GameFieldWidgetState extends State<GameFieldWidget> {
  Size fieldSize = Size.zero;

  @override
  Widget build(BuildContext context) {
    final bloc = GameFieldBloc.of(context);

    final field = RxBuilder<List<GameCardModel>?>(
      stream: bloc.generatedCards,
      builder: (context, sList) {
        if (sList.data == null) {
          return const SizedBox();
        }

        return Stack(
          clipBehavior: Clip.none,
          children: sList.data!.map((e) => GameCard(card: e)).toList(),
        );
      },
    );

    final elapsedTime = RxBuilder<int>(
      stream: bloc.elapsedTime,
      builder: (context, sTime) {
        final time = sTime.data ?? 0;

        return Text('Elapsed time: ${ParsedTime.secondsToString(time)}');
      },
    );

    final counterText = RxBuilder<List<Map<GameCardModel, GameCardModel>>>(
      stream: bloc.movesLogs,
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

    final isGameCompleted = RxBuilder<bool>(
      stream: bloc.isGameComplete,
      builder: (_, sIsComplete) {
        final isComplete = sIsComplete.data ?? false;
        return Text(
          'Is complete: $isComplete',
          style: TextStyle(
            fontSize: 20,
            color: ColorsResource.background,
          ),
        );
      },
    );

    final shuffleButton = RxBuilder<bool>(
      stream: bloc.isGameStarted,
      builder: (_, sIsStarted) {
        final isGameStarted = sIsStarted.data ?? false;

        return RxBuilder<bool>(
          stream: bloc.isGameComplete,
          builder: (_, sIsComplete) {
            final isGameComplete = sIsComplete.data ?? false;
            return AnimatedGestureDetector(
              onTap: isGameStarted ? bloc.shuffle : bloc.startGame,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsResource.primary,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                child: Text(
                  isGameStarted ? isGameComplete ? 'Restart' : 'Shuffle' : 'Start game',
                  style: TextStyle(
                    color: ColorsResource.surface,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    return RxBuilder<Size>(
      stream: ScreenDataBloc.of(context).screenSize,
      builder: (context, sSize) {
        updateFieldSize();

        return Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                children: [
                  counterText,
                  const SizedBox(height: 20),
                  isGameCompleted,
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
                height: fieldSize.height,
                width: fieldSize.width,
                child: field,
              ),
            ),
          ],
        );
      },
    );
  }

  void updateFieldSize() {
    fieldSize = ScreenDataBloc.of(context).getFieldSize();
  }
}
