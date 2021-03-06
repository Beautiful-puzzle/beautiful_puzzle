import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/models/player.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/game/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room.bloc.dart';
import 'package:beautiful_puzzle/utils/rx_builder.dart';
import 'package:beautiful_puzzle/utils/screen.data.dart';
import 'package:beautiful_puzzle/utils/time.dart';
import 'package:flutter/cupertino.dart';
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

        return Text(
          'Elapsed time: ${ParsedTime.secondsToString(time)}',
          style: const TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 18,
          ),
        );
      },
    );

    final counterText = RxBuilder<List<Map<GameCardModel, GameCardModel>>>(
      stream: bloc.movesLogs,
      builder: (_, sLogs) {
        final count = sLogs.data?.length ?? 0;
        return Text(
          'Slides: $count',
          style: TextStyle(
            fontSize: 20,
            color: ColorsResource.background,
            fontWeight: FontWeight.w200,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
                child: Text(
                  isGameStarted
                      ? isGameComplete
                          ? 'Restart'
                          : 'Shuffle'
                      : 'Start game',
                  style: TextStyle(
                    color: ColorsResource.surface,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  counterText,
                  const SizedBox(height: 10),
                  elapsedTime,
                ],
              ),
            ),
            if (bloc.isAutoStart)
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  color: ColorsResource.secondary,
                  height: fieldSize.height / 2,
                  width: fieldSize.width / 2,
                  child: _secondField(),
                ),
              ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!GameFieldBloc.of(context).isAutoStart) ...[
                    const SizedBox(height: 20),
                    Opacity(
                        opacity: 0, child: IgnorePointer(child: shuffleButton)),
                  ],
                  Container(
                    color: ColorsResource.secondary,
                    height: fieldSize.height,
                    width: fieldSize.width,
                    child: field,
                  ),
                  if (!GameFieldBloc.of(context).isAutoStart) ...[
                    const SizedBox(height: 20),
                    shuffleButton,
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _secondField() {
    return RxBuilder<Player?>(
      stream: RoomBloc.of(context).mate,
      builder: (context, sPlayer) {
        if (sPlayer.data?.movesLogs == null) {
          return const SizedBox();
        }

        return Stack(
          clipBehavior: Clip.none,
          children: sPlayer.data!.movesLogs
              .map((e) => GameCard(card: e, isSecondField: true))
              .toList(),
        );
      },
    );
  }

  void updateFieldSize() {
    fieldSize = ScreenDataBloc.of(context).getFieldSize();
  }
}
