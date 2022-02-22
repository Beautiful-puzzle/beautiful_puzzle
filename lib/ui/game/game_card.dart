import 'dart:ui';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/resources/dimens.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:beautiful_puzzle/utils/screen.data.dart';
import 'package:beautiful_puzzle/utils/simple_code.dart';
import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  const GameCard({
    Key? key,
    required this.card,
  }) : super(key: key);

  final GameCardModel card;

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  late Offset offset;

  double _margin = Dimens.marginBetweenCards;
  double cardSize = Dimens.cardSize;


  @override
  void initState() {
    positionToOffset(widget.card.position);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant GameCard oldWidget) {
    positionToOffset(widget.card.position);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    cardSize = ScreenDataBloc.of(context).getCardSize();
    _margin = ScreenDataBloc.of(context).getMarginSize();
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Container(
          color: Colors.white.withOpacity(.5),
          child: Center(
            child: Text(
              '${widget.card.id}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
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
              onDragUpdate: (details) => updatePosition(details.localPosition),
              onDragEnd: (_) => setState(
                () => positionToOffset(
                  GameFieldBloc.of(context).swapCardsPositions(
                    currentOffset: offset,
                    offsetRadius: Offset(cardSize + _margin, cardSize + _margin),
                    card: widget.card,
                  ),
                ),
              ),
              child: child,
            ),
    );
  }

  void updatePosition(Offset newPosition) {
    final screenSize = ScreenDataBloc.of(context).screenSize.value;
    final fieldSize = ScreenDataBloc.of(context).getFieldSize();

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

    runAfterBuild((_) {
      if(widget.card.id == -1) {
        GameFieldBloc.of(context).emptyCardOffset = offset;
      }
    });
  }
}
