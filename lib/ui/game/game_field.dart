import 'dart:math' as math;

import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:flutter/material.dart';

const cardSize = 60.0;
const rowCount = 5;
const colCount = 5;
const margin = 10;

class GameFieldWidget extends StatelessWidget {
  const GameFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.amber,
        height: rowCount * (margin + cardSize) + margin,
        width: colCount * (margin + cardSize) + margin,
        child: Stack(
          children: _generateCards(),
        ),
      ),
    );
  }

  List<Widget> _generateCards() {
    final list = <Widget>[];

    for (var i = 0; i < rowCount; i++) {
      for (var j = 0; j < colCount; j++) {
        final randomColor =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0);

        list.add(
          Positioned(
            left: i * (cardSize + margin) + margin,
            top: j * (cardSize + margin) + margin,
            height: cardSize,
            width: cardSize,
            child: AnimatedGestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: randomColor,
                ),
              ),
            ),
          ),
        );
      }
    }

    return list;
  }
}
