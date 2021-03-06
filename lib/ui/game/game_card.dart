import 'dart:ui';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room.bloc.dart';
import 'package:beautiful_puzzle/utils/screen.data.dart';
import 'package:beautiful_puzzle/utils/simple_code.dart';
import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  const GameCard({
    Key? key,
    required this.card,
    this.isSecondField = false,
  }) : super(key: key);

  final GameCardModel card;
  final bool isSecondField;

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  late Offset offset;

  double _margin = Dimens.marginBetweenCards;
  double cardSize = Dimens.cardSize;

  Color cardColor = Colors.blue.withOpacity(.5);

  @override
  void initState() {
    positionToOffset(-2);

    runAfterBuild((_) async {
      final totalDuration = Dimens.delayAfterGameCompleted.inMilliseconds;
      final delayDuration = totalDuration ~/
          (Dimens.cardsInRow * Dimens.cardsInRow) *
          widget.card.position;

      await Future.delayed(Duration(milliseconds: delayDuration));

      positionToOffset(widget.card.position);

      if (!mounted) return;
      final bloc = widget.isSecondField
          ? RoomBloc.of(context).isMateGameComplete
          : GameFieldBloc.of(context).isGameComplete;

      bloc.listen((isComplete) async {
        await Future.delayed(Duration(milliseconds: delayDuration));

        if (isComplete) {
          cardColor = Colors.amber.withOpacity(.5);
        } else {
          cardColor = Colors.blue.withOpacity(.5);
        }
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GameCard oldWidget) {
    positionToOffset(widget.card.position);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    cardSize = ScreenDataBloc.of(context).getCardSize() /
        (widget.isSecondField ? 2 : 1);
    _margin = ScreenDataBloc.of(context).getMarginSize() /
        (widget.isSecondField ? 2 : 1);
    final child = Container(
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(widget.isSecondField ? 10.0 : 20.0)),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          color: cardColor,
          child: Center(
            child: Text(
              '${widget.card.id}',
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.isSecondField ? 12 : 34,
              ),
            ),
          ),
        ),
      ),
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linearToEaseOut,
      left: offset.dx,
      top: offset.dy,
      height: cardSize,
      width: cardSize,
      child: widget.card.isEmpty
          ? const SizedBox()
          : Draggable(
              maxSimultaneousDrags: 1,
              feedback: Container(),
              childWhenDragging: Opacity(
                opacity: 1,
                child: child,
              ),
              onDragUpdate: (details) => widget.isSecondField
                  ? null
                  : updatePosition(details.localPosition),
              onDragEnd: widget.isSecondField
                  ? null
                  : (_) {
                      setState(
                        () => positionToOffset(
                          GameFieldBloc.of(context).swapCardsPositions(
                            currentOffset: offset,
                            offsetRadius:
                                Offset(cardSize + _margin, cardSize + _margin),
                            card: widget.card,
                            isMateGameComplete: GameFieldBloc.of(context)
                                    .isAutoStart
                                ? RoomBloc.of(context).isMateGameComplete.value
                                : false,
                          ),
                        ),
                      );

                      if (!widget.isSecondField &&
                          GameFieldBloc.of(context).isAutoStart) {
                        RoomBloc.of(context).updateMovesLogs(
                            GameFieldBloc.of(context).generatedCards.value ??
                                []);
                      }
                    },
              child: child,
            ),
    );
  }

  void updatePosition(Offset newPosition) {
    if (GameFieldBloc.of(context).isGameComplete.value) return;

    final screenSize = ScreenDataBloc.of(context).screenSize.value /
        (widget.isSecondField ? 2 : 1);
    final fieldSize = ScreenDataBloc.of(context).getFieldSize() /
        (widget.isSecondField ? 2 : 1);

    /// margin of game field from screen edge
    final marginHeight = (screenSize.height - fieldSize.height) / 2;
    final marginWidth = (screenSize.width - fieldSize.width) / 2;

    /// so user's pointer be in the center of a card
    final halfOfButton = cardSize / 2;

    final tempHeight = -marginHeight - halfOfButton + newPosition.dy;
    final tempWidth = -marginWidth - halfOfButton + newPosition.dx;

    setState(() => offset = Offset(tempWidth, tempHeight));
  }

  void positionToOffset(int position) {
    final y = position < 5
        ? 0
        : position < 10
            ? 1
            : position < 15
                ? 2
                : position < 20
                    ? 3
                    : position < 25
                        ? 4
                        : 0;

    offset = Offset(
      (position % Dimens.cardsInRow) * (cardSize + _margin) + _margin,
      y * (cardSize + _margin) + _margin,
    );

    if (position == -2) {
      offset = Offset(
        (17 % Dimens.cardsInRow) * (cardSize + _margin) + _margin,
        5.2 * (cardSize + _margin) + _margin,
      );
    }

    runAfterBuild((_) {
      if (widget.card.id == -1 && mounted && !widget.isSecondField) {
        GameFieldBloc.of(context).emptyCardOffset = offset;
      }
    });
  }
}
