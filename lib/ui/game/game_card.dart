import 'dart:async';
import 'dart:math';

import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/ui/game/game_field.bloc.dart';
import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  const GameCard({Key? key, required this.initOffset}) : super(key: key);

  final Offset initOffset;

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  late var position = Offset.zero;

  var randomColor =
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      randomColor =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = AnimatedGestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: randomColor,
        ),
      ),
    );

    final cardSize = GameFieldBloc.of(context).cardSize;

    return Positioned(
      left:
          position.dx,
      top: position.dy,
      height: cardSize,
      width: cardSize,
      child: Draggable(
        maxSimultaneousDrags: 1,
        feedback: child,
        childWhenDragging: Opacity(
          opacity: 1,
          child: child,
        ),
        //onDragEnd: (details) => updatePosition(details.offset),
        onDragUpdate: (details) => updatePosition(details.localPosition),
        child: child,
      ),
    );
  }

  void updatePosition(Offset newPosition) {
    final bloc = GameFieldBloc.of(context);
    final tempHeight = newPosition.dy - (bloc.screenSize.height / 2) +
        (bloc.fieldSize.height / 8) - (bloc.cardSize / 2);
    final tempWidth = newPosition.dx - (bloc.screenSize.width / 2) +
        (bloc.fieldSize.width / 8) - (bloc.cardSize / 2);
    setState(() => position = Offset(tempWidth, tempHeight));
  }
}
