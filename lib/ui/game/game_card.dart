import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
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
  late var position = widget.card.offset;

  var randomColor =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      randomColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      clipBehavior: Clip.hardEdge,
      child: widget.card.isEmpty
          ? null
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                color: Colors.white.withOpacity(.5),
                child: Center(
                  child: Text(
                    '${widget.card.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ),
              ),
            ),
    );

    final cardSize = GameFieldBloc.of(context).cardSize;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.linearToEaseOut,
      left: position.dx,
      top: position.dy,
      height: cardSize,
      width: cardSize,
      child: Draggable(
        maxSimultaneousDrags: 1,
        feedback: Container(),
        childWhenDragging: Opacity(
          opacity: 1,
          child: child,
        ),
        onDragUpdate: (details) => updatePosition(details.localPosition),
        onDragStarted: () => GameFieldBloc.of(context).topOrder(widget.card.id),
        onDragEnd: (_) => setState(() => position = widget.card.offset),
        child: child,
      ),
    );
  }

  void updatePosition(Offset newPosition) {
    final bloc = GameFieldBloc.of(context);

    /// margin of game field from screen edge
    final marginHeight = (bloc.screenSize.height - bloc.fieldSize.height) / 2;
    final marginWidth = (bloc.screenSize.width - bloc.fieldSize.width) / 2;

    /// so user's pointer be in the center of a card
    final halfOfButton = bloc.cardSize / 2;

    final tempHeight = -marginHeight - halfOfButton + newPosition.dy;
    final tempWidth = -marginWidth - halfOfButton + newPosition.dx;

    setState(() => position = Offset(tempWidth, tempHeight));
  }
}
